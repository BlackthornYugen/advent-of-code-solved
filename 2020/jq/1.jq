# https://adventofcode.com/2020/day/2 part 2 in jq

# Watched @rem at https://youtu.be/Hb3mkbIaFE8 
# so this is just me following along with what he was doing, NOT ORIGNAL, I solved with #1 with js only.
# See https://github.com/remy/advent-of-code-solved/blob/master/2020/jq/1-b.jq

def loop3($k): 
    # debug |
    .k = $k + 1 |
    until(
        .k == (.src | length) or .res != 0;
        .k = .k + 1 |
        .res = 
            if (.src[.i] + .src[.j] + .src[.k]) == 2020 
                then 
                    .src[.i] * .src[.j] * .src[.k] 
                else 
                    0 
            end
    )
;

def loop2($j): 
    .j = $j + 1 |
    until(
        .j == (.src | length) - 1 or .res != 0;
        if (.src[.i] + .src[.j]) > 2019
            then 
                .
            else
                loop3(.j + 1) 
        end | 
        .j = .j + 1
    )
;

def loop1:
    .i = 0 | 
    until(
        .i == (.src | length) - 2  or .res != 0;
        if .src[.i] > 2018 then . else loop2(.i + 1) end | 
        .i = .i + 1
    )
;

. | 
. as $source | {
    src: $source,
    i: 0,
    j: 0,
    k: 0,
    res: 0,
} | loop1 | .res