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

# Gamma is the decimal equivelant of a binary string
def calculate_gamma:
    bin_array_to_dec
;

# epsilon is the decimal equivelant of a bitwise negation of a
# binary string.
def calculate_epsilon:
    map (if . == 0 then 1 else 0 end) | bin_array_to_dec
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

# break up data on newlines
split("\n") |

# loop through diagnostic data keeping a running
# total of data that can be normalized and used
# to calculate gamma or epsilon
reduce .[] as $diagnostic ([];
  if . | length == 0
  then [$diagnostic | parse_numeric_array]
  else [.[0], ($diagnostic | parse_numeric_array)] | [add_arrays]
  end
) | normalize_binary |

{ gamma: calculate_gamma, epsilon: calculate_epsilon } |

# Print calculated values ["DEBUG:",{"epsilon":#,"gamma":#}]
debug |

# Calculate power consumption
.gamma * .epsilon

# Usage
# jq --slurp --raw-input --from-file "2021/jq/3.jq" "2021/03_demo.input"