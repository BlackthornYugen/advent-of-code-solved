import "3" as lib;

# break up data on newlines
split("\n") |

# loop through diagnostic data keeping a running
# total of data that can be normalized and used
# to calculate gamma or epsilon
reduce .[] as $diagnostic ([];
  if . | length == 0
  then [$diagnostic | lib::parse_numeric_array]
  else [.[0], ($diagnostic | lib::parse_numeric_array)] | [lib::add_arrays]
  end
) | lib::normalize_binary |

{ gamma: lib::calculate_gamma, epsilon: lib::calculate_epsilon } |

# Print calculated values ["DEBUG:",{"epsilon":#,"gamma":#}]
debug |

# Calculate power consumption
.gamma * .epsilon

# Usage
# jq --slurp --raw-input --from-file "2021/jq/3.jq" "2021/03_demo.input"