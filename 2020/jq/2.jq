# https://adventofcode.com/2020/day/2 part 2 in jq

# x ^ y
def xor($x;$y): 
    ($x or $y)        # Either $x or $y
        and           # but
    ($x and $y | not) # not both
;

# Read in src data as array of strings
split("\n")

# Operate on each entry ["2-7 p: pbhhzpmppb", ...]
|
[ .[]

    # Build an object from captured data
    | capture("(?<min>\\d+)-(?<max>\\d+) (?<charactor>\\w+): (?<password>\\w+)")

    # Now we have something like this
    # [{
    #   "min": "2",
    #   "max": "7",
    #   "charactor": "p",
    #   "password": "pbhhzpmppb",
    # }, {}, ...]

    # Parse numeric values
    | {min: .min|tonumber, max: .max|tonumber, charactor, password}

    # Extract chars
    | . + {chars: [.password[.min-1:.min|tonumber], .password[.max-1:.max]] }

    # Now we have something like this
    # [{
    #   "min": 2,
    #   "max": 7,
    #   "charactor": "p",
    #   "password": "pbhhzpmppb",
    #   "chars": [
    #     "b",
    #     "m"
    #   ]
    # }, {}, ...]

    # Filter out anything that doesn't match our rule
    | select (xor(.chars[0] == .charactor ; .chars[1] == .charactor ))
    | debug
]

# Count em up
| length