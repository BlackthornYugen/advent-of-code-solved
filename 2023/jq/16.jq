#!/usr/bin/env -S jq --slurp --raw-input --from-file --raw-output

def cell_ctor($type):
    {type: $type, light_directions: [false, false, false, false]}
;

def process_line:
    .[0:2] | [reduce scan(".") as $cell (
        [] ; . + [cell_ctor($cell)]
    )]
;

def parse_input:
    split("\n") | .[0:2] | reduce .[] as $line (
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

def trace_rays:
    . as $table |
    foreach .rays[] as $ray (
        $table + {rays: []}
        ;
        ($directions[$ray.direction]) as $vector |
        ($ray.x + $vector.x) as $next_x |
        ($ray.y + $vector.y) as $next_y | 
        if   (.cells[$next_y][$next_x] != null) and $next_x >= 0 and $next_y >= 0
        then (.cells[$next_y][$next_x].light_directions[$direction_names | index($ray.direction)]) = true | 
              .rays += [{x: $next_x, y: $next_y, direction: $ray.direction}] 
        else . 
        end
        ;
        if (.rays | length | debug > 0) then debug | trace_rays else . end
    ) | .
;

parse_input | . + {rays: [{x: -1, y: 0, direction: "east"}]} | trace_rays