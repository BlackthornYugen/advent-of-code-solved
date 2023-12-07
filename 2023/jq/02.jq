#!/usr/bin/env -S jq --slurp --raw-input --from-file --raw-output

split("\n") 
  | reduce .[] as $item (
    $bag
    ;
    $item | capture("(?<game>\\d+): (?<b>.*)") | . + {b: (.b | split(";"))}
  | debug 
)