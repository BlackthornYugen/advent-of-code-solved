#!/usr/bin/env -S jq --slurp --raw-input --from-file --raw-output

def process_turns($turns):
    $turns
            | split("; ")
            | map(split(", "; "")
                | map(split(" ")
                | {"value": .[0] | tonumber, "key": .[1]}) 
                | from_entries)
;

def is_subset_of($obj1; $obj2):
    all(($obj1 | keys | map(. as $key | $obj1[$key] <= $obj2[$key]))[]; .)
;

def max_merge($obj1; $obj2): 
    #($obj1 | keys | map(. as $key | ($obj1[$key] = $obj2[$key])))
    {} | $obj2 | keys | reduce .[] as $key (
        $obj1
        ; 
        .[$key] = ([$obj1[$key], $obj2[$key]] | max)
    ) 
;

split("\n") 
  | map(capture("(?<game>\\d+): (?<turns>.*)") 
        | .turns = process_turns(.turns)
        | .game = (.game | tonumber)
        | .min = (reduce .turns[] as $turn ({}; max_merge(.; $turn)))
  ) | map(.min 
            | to_entries 
            | reduce .[].value as $multiplican (1; $multiplican * .)) 
    | add