# https://adventofcode.com/2020/day/5 part 1 in jq

def binarySearch($max; $true):
    # debug
    ( split("") | reverse | to_entries | reduce .[] as $item (
        1;
        if $item.value == $true then . * ($item.key + 1) else . end
    ) )
;

split("\n") | .[0:5] | 
    map( 
        [ 
            (.[0:7]  | binarySearch(5; "F") ), 
            (.[7:10] | binarySearch(5; "R" )) 
        ] )
    | debug | length