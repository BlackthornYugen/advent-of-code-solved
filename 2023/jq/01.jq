#!/usr/bin/env -S jq --slurp --raw-input --from-file --raw-output

split("\n")
    | map(debug |
        (capture("(?<first>\\d).*(?<second>\\d)") // capture("(?<first>\\d).*"))
          | "\(.first)\(.second // .first)" | tonumber | debug
    ) | add