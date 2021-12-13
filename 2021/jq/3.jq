# Given a string of numbers, return an array of numbers
# "123" -> [1,2,3]
def parse_numeric_array:
    split("") | map (. | tonumber)
;

# Given an array where positive numbers represent a binary 1
# and negative numbers represent a binary 0, normalize said
# array to binary reprenstations 0 and 1.
def normalize_binary:
    .[] | map (if . < 0 then 0 else 1 end)
;

# Convert an array of 0s and 1s into it's decimal form
def bin_array_to_dec:
    reduce range(0; length) as $i
        # INIT
        # [running value [0], incoming array [1], array of base2 multipliers [2]]
        ( [ 0               , .                 , (pow( 2; length - 1) | [while(.>0; ./2 | floor)])]

    ;   # UPDATE running value ([0])
        # by multipling incoming array[1][$i] by multipliers [2][$i]
        .[0] += ( .[1][$i] * .[2][$i]) )

        # RETURN running value ([0])
    |   .[0]
;

# Given two arrays where array 1 is numeric data and array two is an array of binary data (0,1)
# return [a1 + (b1 == 1 ? 1 : -1),  a2 + (b2 == 1 ? 1 : -1), ...]
#
# [1,1,0]   [1, 2, 0]    [4, 5, 6, 7, 8]   <- decimal array
# [0,0,1]   [1, 1, 0]    [0, 0, 0, 0, 0]   <- binary array
# =======   =========    ===============
# [0,0,0]   [2, 3,-2]    [3, 4, 5, 6, 7]   <- sum
def add_arrays:
    reduce range(0, (.[0] | length)) as $i (.; .[0][$i] += (if .[1][$i] == 0 then -1 else 1 end) ) | .[0]
;

def bitwise_negate: 
    map (if . == 0 then 1 else 0 end)
;

# Gamma is the decimal equivelant of a binary string
def calculate_gamma:
    normalize_binary | bin_array_to_dec
;

# epsilon is the decimal equivelant of a bitwise negation of a
# binary string.
def calculate_epsilon:
    normalize_binary | bitwise_negate | bin_array_to_dec
;

def find_rating:
    label $out | foreach range(0, .[0] | length + 2) as $i (
    ([([.[0]] | normalize_binary), .[1]]) ;

    .[0] as $j | [.[0], [
        ( 
            if (.[1] | length) == 1 then 
            # We have started a new loop after already finding our canidate, break loop!
            break $out 
            else 
            # Narrow ther search with the next digit
            .[1][] | select ((. | split("") | .[$i] | tonumber) == ($j)[$i]) 
            end
        )
        ] ];

        # Log result when it has been narrowed down to one canidate
        if (.[1] | length) == 1 then . else empty end
    ) | debug | .[0]
;

def find_oxygen_generator_rating: 
    debug | find_rating | bin_array_to_dec
;

def find_cO2_scrubber_rating: 
    debug | [(( [ .[0], [1,1,1,1,1] ] | add_arrays | bitwise_negate ) | debug), .[1]] | debug | find_rating | bin_array_to_dec
;

# Usage:
# import 3 as lib;