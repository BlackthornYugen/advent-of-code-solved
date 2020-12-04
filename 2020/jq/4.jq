# https://adventofcode.com/2020/day/4 part 1 in jq

# split("\n| "; "") # 2381 lines, 5.3 seconds to parse!

def parseDocuments: 
    # foreach EXP as $var (INIT; UPDATE; EXTRACT)
    foreach .[] as $item (
        #INIT;
        [[],[]];

        #UPDATE 
        if 
            $item == "" 
        then 
            [[],.[0]]
        else 
            [(.[0] + ($item | split(" "))),[]] #| debug 
        end;

        #EXTRACT
        if 
            $item == "" 
        then .[1] | [ .[] | split(":") | { "\(.[0])": .[1]} | add]
        else empty 
        end
    ) 
;




split("\n") | .[0:15]
    | [ parseDocuments
    | debug
    # | split(" ")
]
| length
