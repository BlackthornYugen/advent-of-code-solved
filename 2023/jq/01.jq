#!/usr/bin/env -S jq --slurp --raw-input --from-file --raw-output

def normalize:
  . as $input_text |
  reduce ({
    "one":   "1",
    "two":   "2",
    "three": "3",
    "four":  "4",
    "five":  "5",
    "six":   "6",
    "seven": "7",
    "eight": "8",
    "nine":  "9"
  } | to_entries | .[]) as $number ( 
    # INIT 
    .
    ;
    # UPDATE
    sub($number["key"] ; $number["value"])
    ) 
;

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

split("\n")
    | map( debug | normalize | debug |
        (capture("(?<first>\\d).*(?<second>\\d)") // capture("(?<first>\\d).*"))
          | "\(.first)\(.second // .first)" | tonumber | debug
    ) | add