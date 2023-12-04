#!/usr/bin/env -S jq --slurp --raw-input --from-file --raw-output

def normalize($in):
{
    "one":   "1",
    "two":   "2",
    "three": "3",
    "four":  "4",
    "five":  "5",
    "six":   "6",
    "seven": "7",
    "eight": "8",
    "nine":  "9"
} as $text_to_numeric |

$text_to_numeric 
    | to_entries 
    | map(.key) 
    | "(?<cap>\(join("|")))" as $pattern |

[$in | debug | scan($pattern)] | debug | reduce .[] as $item (
    $in
    ;
    sub($pattern; $text_to_numeric[.["cap"]]) 
)
;


split("\n")
    | map( normalize(.) |
        (capture("(?<first>\\d).*(?<second>\\d)") // capture("(?<first>\\d).*"))
          | "\(.first)\(.second // .first)" | tonumber | debug
    ) | add