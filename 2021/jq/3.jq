def parse_numeric_array:
    split("") | map (. | tonumber)
;

# Given two equal size arrays with numeric data [[a1, a2, a3, a...], [b1, b2, b3, b...]]
# return [a1+b1, a2+b2, a3+b3, ...]
def add_arrays:
    reduce range(0, (.[0] | length)) as $i (.; .[0][$i] += .[1][$i] ) | .[0]
;

# break up data on newlines
split("\n") |

# loop through data
reduce .[] as $diagnostic ([];
  if . | length == 0
  then [$diagnostic | parse_numeric_array]
  else [($diagnostic | parse_numeric_array), .[0]] | add_arrays
  end
)

# Usage
# jq --slurp --raw-input --from-file "2021/jq/3.jq" "2021/03_demo.input"