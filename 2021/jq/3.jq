def parse_numeric_array:
    split("") | map (. | tonumber)
;

def add_arrays:
    .[0] as $first_array  |
    .[1] as $second_array |
    foreach .[0] as $ee (
        #INIT;
        [];

        #UPDATE
        . + ([$first_array + $second_array]);

        #EXTRACT
        if ($second_array | length | debug ) >= (. | length | debug)
        then .
        else .
        end
    )
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