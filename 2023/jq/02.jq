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

split("\n") 
  | map(capture("(?<game>\\d+): (?<turns>.*)") 
        | .turns = process_turns(.turns)
      # | Filter out imposible games | #
        | select(.turns | all(map(is_subset_of(.; $bag))[]; .))
  ) | map(.game | tonumber | debug) | add
