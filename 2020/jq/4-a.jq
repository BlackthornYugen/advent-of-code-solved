# https://adventofcode.com/2020/day/4 part 1 in jq

.[][] | split(":") | { "\(.[0])": .[1]}