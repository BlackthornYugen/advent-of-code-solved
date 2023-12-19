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

def get_movement_left_right($direction):
    reduce (-1, 1) as $x ( [] ; . + [
            {
                x: $x,
                y: (if ($x == 0) then 1 else 0 end)
            } |
            if $direction.y == 0 
            then {x: .y, y: .x} 
            else . 
            end
        ]
    )
;

# $path an object like {heat_lost: #, crucible_stability: #, steps: [{x: #, y: #}, ...]}
# $map a list of ints representing heat loss in a cell
# returns an array of $path
def get_next_moves($path; $map):
    # If we have moved forward fewer than 3 times in a row, add forward as
    # a possible move. Add left and right as possible moves. Filter out
    # moves that take us out of bounds. Update heat lost to equal previous
    # heat lost + heat loss of cell we are entering.
    $path.steps | get_direction as $direction |
    if $path.crucible_stability > 0
    then [{ heat_lost: $path.heat_lost,
            crucible_stability: ($path.crucible_stability - 1),
            steps: ($path.steps + [{x: ($path.steps[-1].x + $direction.x), y: ($path.steps[-1].y + $direction.y)}])
    }]
    else []
    end | 
    . + reduce get_movement_left_right($direction)[] as $turn ([] ; 
        . + [{ heat_lost: $path.heat_lost,
            crucible_stability: ($path.crucible_stability - 1),
            steps: ($path.steps + [{x: ($path.steps[-1].x + $direction.x), y: ($path.steps[-1].y + $direction.y)}])
        }]
    ) | map(.heat_lost = .heat_lost + $map[.steps[-1].y][.steps[-1].x])
;

def breadth_search($map):
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
    end |
    if (.frontier | length) == 0
    then error("Path cannot be found.")
    else .
    end
    # If the cheapest path isn't the solution, we have replaced it with the next 
    # possible moves. We also re-sorted it. 
    # TODO: 
    #   + return to the caller who is looping 
    #                  // or // 
    #   + recurse into breadth_search again.
;

def print_path($path; $map):
    reduce $path[] as $step (
        $map;
        .[$step.y][$step.x] = "X"
    )
    |
    .[] | (map(tostring) | join(" ")) + "\n"
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
    | {frontier: [{crucible_stability: 3, heat_lost: 0, steps: [{x: 0, y: 0}]}] }
    | breadth_search($map)
    | (
        "Heat lost:\t\(.frontier[0].heat_lost)\nSteps:\t\t\(.frontier[0].steps | length)\n", 
        print_path(.frontier[0].steps; $map)
    ) | stderr | empty