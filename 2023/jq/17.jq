#!/usr/bin/env -S jq --slurp --raw-input --from-file --raw-output

# PSUDOCODE

# takes a path (set of moves, with heat lost so far)
# {heat_lost: 14, steps: [{x: 0, y: 1}, {x: 1, y: 1}, {x: 2, y: 1}]}
def get_next_moves($path; $map):
    [
        {heat_lost: 18, steps: [{x: 0, y: 1}, {x: 1, y: 1}, {x: 2, y: 1}, {x: 2, y: 0}]},
        {heat_lost: 15, steps: [{x: 0, y: 1}, {x: 1, y: 1}, {x: 2, y: 1}, {x: 3, y: 1}]},
        {heat_lost: 44, steps: [{x: 0, y: 1}, {x: 1, y: 1}, {x: 2, y: 1}, {x: 2, y: 2}]}
    ]
;

# takes $frontier and returns $frontier
def breadth_search($frontier; $map):
    # Each time we are called, we gets something like this: 
    {
        goal_reached: false, frontier: [
            # frontier moves will be kept sorted by the moveset,  
            {heat_lost: 14, steps: [{x: 0, y: 0}, {x: 0, y: 0}, {x: 0, y: 0}]},
            {heat_lost: 16, steps: [{x: 0, y: 0}, {x: 0, y: 0}, {x: 0, y: 0}]},
            {heat_lost: 21, steps: [{x: 0, y: 0}, {x: 0, y: 0}, {x: 0, y: 0}]}
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
    # $path | debug | $map | debug |
    reduce $path[] as $step (
        $map;
        .[$step.y][$step.x] = "X"
    )
    |
    .[] | map(tostring) | join("  ")
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
        "Heat lost:\t\(.frontier[0].heat_lost)\nSteps:\t\t\(.frontier[0].steps | length)", 
        print_path(.frontier[0].steps; $map)
    )