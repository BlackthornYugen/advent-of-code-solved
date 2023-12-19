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
# $map is a list of ints representing heat loss in a cell
# returns an array of $path
def get_next_moves($map):
    .frontier[0] as $path |
    # If we have moved forward fewer than 3 times in a row, add forward as
    # a possible move. Add left and right as possible moves. Filter out
    # moves that take us out of bounds. Update heat lost to equal previous
    # heat lost + heat loss of cell we are entering.
    ($path.steps | get_direction) as $direction |
    (
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
                steps: ($path.steps + [{x: ($path.steps[-1].x + $turn.x), y: ($path.steps[-1].y + $turn.y)}])
            }]
        ) | #debug("Next Moves", .[0:5][].steps) |
        
        # Drop paths that lead out of bounds
        map(if (.steps[-1].y >=0 and .steps[-1].x >=0) then . else empty end) |
        
        # Calculate heat lost
        map(.heat_lost = .heat_lost + $map[.steps[-1].y][.steps[-1].x])
    ) as $new_paths |
    .frontier += (reduce $new_paths[] as $path ([]; 
        # Drop paths that lead out of bounds
        if ($path.steps[-1].y >=0 and $path.steps[-1].x >=0)
        then . + [$path]
        else .
        end
        # |
        # # Drop paths that have been visited
        # if try .[$path.steps[-1].y][$path.steps[-1].x][$path.crucible_stability][$path.heat_lost] catch false
        # then . + [$path]
        # else .
        # end
    )) |
    del(.frontier[0]) | 
    .frontier = (.frontier | sort_by(.heat_lost))
;

def breadth_search($map):
    .search_count = .search_count // -1 |
    .search_count += 1 |
    if (.frontier[0].steps[-1].x == 12) and 
       (.frontier[0].steps[-1].y == 0)
    then
       .goal_reached = true | debug("Goal", .frontier[0].steps[-1])
    else
        get_next_moves($map)
    end |
    if (.frontier | length) == 0
    then error("Path cannot be found.")
    elif (.goal_reached | not) and (.search_count <= 2000)
    then breadth_search($map)
    end
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
        "Heat lost:\t\(.frontier[0].heat_lost)\n" +
        "Steps:\t\t\(.frontier[0].steps | length)\n" +
        "Checks:\t\t\(.search_count)\n", 
        print_path(.frontier[0].steps; $map)
    ) | stderr | empty