#!/usr/bin/env -S jq --slurp --raw-input --from-file --raw-output

# takes an object like [{x: #, y: #}, ...]
# returns a direction like {"x":  1, "y":  0}
def get_direction:
    if (length < 2)
    then {"x":  1, "y":  0}
    else
        {x: (.[-1].x - .[-2].x), y: (.[-1].y - .[-2].y)}
    end
;

# $path an object like {heat_lost: #, crucible_stability: #, steps: [{x: #, y: #}, ...]}
# $map a list of ints representing heat loss in a cell
# returns an array of $path
def get_next_moves($path; $map):
    # If we have moved forward fewer than 3 times in a row, add forward as
    # a possible move. Add left and right as possible moves. Filter out
    # moves that take us out of bounds. Update heat lost to equal previous
    # heat lost + heat loss of cell we are entering.
    if $path.crucible_stability > 0
    then 
    [
        {heat_lost: 18, crucible_stability: 3, steps: [{x: 0, y: 0}, {x: 0, y: 1}, {x: 1, y: 1}, {x: 1, y: 0}]},
        {heat_lost: 15, crucible_stability: 1, steps: [{x: 0, y: 0}, {x: 0, y: 1}, {x: 1, y: 1}, {x: 2, y: 1}]},
        {heat_lost: 44, crucible_stability: 3, steps: [{x: 0, y: 0}, {x: 0, y: 1}, {x: 1, y: 1}, {x: 1, y: 2}]}
    ]
    else
    [
        {heat_lost: 18, crucible_stability: 3, steps: [{x: 0, y: 0}, {x: 0, y: 1}, {x: 1, y: 1}, {x: 1, y: 0}]},
        {heat_lost: 44, crucible_stability: 3, steps: [{x: 0, y: 0}, {x: 0, y: 1}, {x: 1, y: 1}, {x: 1, y: 2}]}
    ]
    end
;

# takes $frontier and returns $frontier
def breadth_search($frontier; $map):
    # Each time we are called, we gets something like this: 
    {
        goal_reached: false, frontier: [
            # frontier moves will be kept sorted by the moveset,  
            {heat_lost: 14, crucible_stability: 1, steps: [{x: 0, y: 0}, {x: 0, y: 0}, {x: 0, y: 0}]},
            {heat_lost: 16, crucible_stability: 2, steps: [{x: 0, y: 0}, {x: 0, y: 0}, {x: 0, y: 0}]},
            {heat_lost: 21, crucible_stability: 3, steps: [{x: 0, y: 0}, {x: 0, y: 0}, {x: 0, y: 0}]}
        ]
    } |
    # We will take the cheapest path, check if it's already a solution, if so, set 
    # goal_reached and return without changes
    if (.frontier[0].steps[-1].x == ($map[0] | length)) and 
       (.frontier[0].steps[-1].y == ($map    | length))
    then
       .goal_reached = true
    else
        .frontier += get_next_moves(.frontier[0]; map) |
        del(.frontier[0]) |
        .frontier = (.frontier | sort_by(.heat_lost))
    end

    # If the cheapest path isn't the solution, we will replace it with the possible
    # moves. We will insert them into the frontier, re-sort it, and either return
    # to the caller who is looping or recurse into breadth_search again.
;

def print_path($path; $map):
    reduce $path[] as $step (
        $map;
        .[$step.y][$step.x] = "X"
    )
    |
    .[] | (map(tostring) | join("  ")) + "\n"
;

def parse_input:
    split("\n") | map(select(length > 0)) | reduce .[] as $line (
        [] ;
        . += ($line | [
              reduce scan(".") as $cell (
                [] ; . + [$cell | tonumber]
            )]
            )
    )
;

parse_input as $map 
    | breadth_search({
        goal_reached: false, frontier: [
            # frontier moves will be kept sorted by the moveset,  
            {heat_lost: 14, steps: [{x: 0, y: 0}, {x: 0, y: 0}, {x: 0, y: 0}]},
            {heat_lost: 16, steps: [{x: 0, y: 0}, {x: 0, y: 0}, {x: 0, y: 0}]},
            {heat_lost: 21, steps: [{x: 0, y: 0}, {x: 0, y: 0}, {x: 0, y: 0}]}
        ]
    }; $map) 
    | (
        "Heat lost:\t\(.frontier[0].heat_lost)\nSteps:\t\t\(.frontier[0].steps | length)\n", 
        print_path(.frontier[0].steps; $map)
    ) | stderr | empty