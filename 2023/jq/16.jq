#!/usr/bin/env -S jq --slurp --raw-input --from-file --raw-output

def cell_ctor($type):
    {type: $type, light_directions: [false, false, false, false]}
;

def process_line:
    [reduce scan(".") as $cell (
        [] ; . + [cell_ctor($cell)]
    )]
;

def parse_input:
    split("\n") | map(select(length > 0)) | reduce .[] as $line (
        {cells: []} ;
        .cells += ($line | process_line)
    )
;

{
    "north": {"x":  0, "y": -1},
    "east":  {"x":  1, "y":  0},
    "south": {"x":  0, "y":  1},
    "west":  {"x": -1, "y":  0},
} as $directions |

["north", "east", "south", "west"] as $direction_names |

def to_name:
    . as $vector
    | $directions | keys | reduce .[] as $direction (
        null;
        if
            $directions[$direction] == $vector
        then 
            $direction
        else 
            .
        end
    )
;

def trace_ray($ray):
    if (.cells[$ray.y][$ray.x] != null) and
       ($ray.x >= 0 and $ray.y >= 0) and
       (.cells[$ray.y][$ray.x].light_directions[$direction_names | index($ray.direction)]) != true
    then
        (.cells[$ray.y][$ray.x].light_directions[$direction_names | index($ray.direction)]) = true
        | ($directions[$ray.direction]) as $vector
        | (.cells[$ray.y][$ray.x].type) as $type
        |
        if   $type == "." or 
            ($type == "|" and $vector.x == 0) or 
            ($type == "-" and $vector.y == 0)
        then .rays += [{x: ($ray.x + $vector.x), y: ($ray.y + $vector.y), direction: $ray.direction}]
        elif $type == "|"
        then .rays += [{x: $ray.x, y: ($ray.y + 1), direction: "south"},
                       {x: $ray.x, y: ($ray.y - 1), direction: "north"}]
        elif $type == "-"
        then .rays += [{x: ($ray.x + 1), y: $ray.y, direction: "east"},
                       {x: ($ray.x - 1), y: $ray.y, direction: "west"}]
        elif $type == "/"
        then ({x: ($vector.y * -1), y: ($vector.x * -1)} | . + {direction: to_name}) as $new_vector
            | .rays += [{x: ($ray.x + $new_vector.x), y: ($ray.y + $new_vector.y), direction: $new_vector.direction}]
        elif $type == "\\" 
        then ({x: ($vector.y), y: ($vector.x)} | . + {direction: to_name}) as $new_vector
            | .rays += [{x: ($ray.x + $new_vector.x), y: ($ray.y + $new_vector.y), direction: $new_vector.direction}]
        else . 
        end
    else . end
;

def trace_rays:
    . as $table |
    reduce .rays[] as $ray (
        $table + {rays: []}
        ;
        trace_ray($ray)
        | if (.rays | length) > 0
        then trace_rays
        else .
        end
    )
;

def print:
    .cells[] | reduce .[] as $cell (
        "";
        . + if (
                $cell.light_directions | any 
                # and $cell.type == "."
                ) 
            then "#" 
            else $cell.type 
            end
    )
;

def count:
    [.cells[]
    | map(select(.light_directions | any)) 
    | length] | add
;

def simulate_then_count($x; $y; $direction):
. as $input |
{$x, $y, energized: ($input
            | . + {rays: [{x: $x, y: $y, direction: $direction}]}
            | trace_rays
            | count)}
;

parse_input
    | . + {rays: [{x: ($x | tonumber), y: ($y | tonumber), direction: $direction}]} 
    | trace_rays | {$x, $y, energized: count}
