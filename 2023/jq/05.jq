#!/usr/bin/env -S jq --slurp --raw-input --from-file --raw-output

split("\n") | map(match("(.*): ?(.*)"; "")) | reduce .[] as $line (
    {lines: []}; 
    
    .lines += [$line]
)