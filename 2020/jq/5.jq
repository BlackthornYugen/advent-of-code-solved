# https://adventofcode.com/2020/day/5 part 1 in jq

def parse:
    split("\n")
;

def binarySearch($low; $high; $target):
    # debug |
    # ("binarySearch(\($low); \($high); \($target))" | debug | empty), 
    if length > 1 
    then 
        if .[0:1] == $target
        then .[1:] | binarySearch( (($high + $low) / 2) | ceil ; $high ; $target)
        else .[1:] | binarySearch( $low ; ($high + $low) / 2 | floor ; $target)
        end
    else
        if .[0:1] == $target
        then $high
        else $low
        end
    end
;



parse | map({
           row:    (.[0:7]  | binarySearch(0; 127; "B")),
           column: (.[7:10] | binarySearch(0;   7; "R")) 
        } | . + {seatId: (.row * 8 + .column)} )
        | sort_by(.seatId)
        | .[-1:][0].seatId
