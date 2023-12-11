#!/usr/bin/env -S jq --slurp --raw-input --from-file --raw-output

def parse_numbers($numbers):
    $numbers 
        | split(" +";"") 
        | map(select(length > 0) 
                | tonumber)
;

def score_card:
    # 1 point for first match and doubled for
    # every additional match
    select(length > 0) | length - 1 | exp2
;

def innter_join($left; $right):
    $left | reduce .[] as $value ([] ; . + if ($right | index($value)) then [$value] else null end) 
;

split("\n") | map(
    capture("^card (?<card>\\d+): (?<numbers>.*) *\\| *(?<winning_numbers>.*)$"; "i") |
    .numbers = parse_numbers(.numbers) |
    .winning_numbers = innter_join(parse_numbers(.winning_numbers); .numbers)
) | [.[].winning_numbers | score_card] | add 