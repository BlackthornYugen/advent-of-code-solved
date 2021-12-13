import "3" as lib;

# break up data on newlines
split("\n") |

# loop through diagnostic data keeping a running
# total of data that can be normalized and used
# to extract the oxygen generator rating and CO2 
# scrubber rating
reduce .[] as $diagnostic ([];
  if . | length == 0
  then [$diagnostic | lib::parse_numeric_array, [$diagnostic]]
  else [.[0], ($diagnostic | lib::parse_numeric_array), .[1]] | [lib::add_arrays, .[2] + [$diagnostic]]
  end
) | [lib::find_oxygen_generator_rating, lib::find_cO2_scrubber_rating]

# { oxygen: lib::calculate_oxygen_generator, co2: lib::calculate_co2_scrubber } |



