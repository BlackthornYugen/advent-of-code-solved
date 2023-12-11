#!/usr/bin/env -S jq --slurp --raw-input --from-file --raw-output

def math_max($min; $value):
    [$min, $value] | max
;

def exclude_collisions($window):
    map(
        .string as $part_candidate | 
         $window[0][math_max(0; .offset - 1)      : .offset + .length + 1] +
         $window[1][math_max(0; .offset - 1)      : .offset              ] +
         $window[1][math_max(0; .offset + .length): .offset + .length + 1] +
         $window[2][math_max(0; .offset - 1)      : .offset + .length + 1]
         | gsub("[\\.\\d]";"") | if length == 0 then $part_candidate else "" end
     | select (length > 0) | tonumber )
;

split("\n") | . + ["",""] | [foreach .[] as $line ( 
    # init
    {window: ["","",""]}; 
    
    # update
    .window += [$line] | .window = .window[1:4]; 
    
    # extract
    .window as $window
     | .parts = ( [.window[1] | match("\\d+"; "g") ] | exclude_collisions($window))
)] | [.[].parts ] | flatten | add