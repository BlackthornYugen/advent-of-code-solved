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

def gapFinder:
    sort_by(.id) |
    # foreach EXP as $var (INIT; UPDATE; EXTRACT)
    foreach .[] as $seat (
        #INIT;
        # Rolling window of seats scanned
        [0, 0];

        #UPDATE
        # On each update, let seat n-2 fall off, and keep track of seat n and n - 1
        [ .[1], $seat.id ];

        #EXTRACT
        # When we find a gap of 2, output the gap seat id
        if .[1] - .[0] == 2 then $seat.id - 1 else empty end
    )
;


parse | map({
           row:    (.[0:7]  | binarySearch(0; 127; "B")),
           column: (.[7:10] | binarySearch(0;   7; "R")) 
        } 
        # Part 1
        # | . + {seatId: (.row * 8 + .column)} )
        # | sort_by(.seatId)
        # | .[-1:][0].seatId
        # part 2
        | . + {id: (.row * 8 + .column)} )
        | gapFinder