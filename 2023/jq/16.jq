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

def trace_ray($x; $y; $direction):
    . as $table |
    ($direction_names | index($direction)) as $z |
    .cells[$x][$y].light_directions[$z] = true |
    foreach $directions[] as $direction (
        {table: $table}
        ;
        . + $direction
        ;
        debug
    ) | $table + {rays: []}
;

parse_input | trace_ray(0; 0; "east")