# https://adventofcode.com/2020/day/5 part 1 in jq

def binarySearch($max; $true):
    # debug
    ( split("") | . | debug| to_entries  | reduce .[] as $item (
        1;
        if $item.value == $true then . + pow(2;$item.key) | debug else . end
    ) )
;

split("\n") | .[0:5] | 
    map([ 
            (.[0:7]  | binarySearch(128; "F")), 
            (.[7:10] | binarySearch(8;   "R" )) 
        ])
    