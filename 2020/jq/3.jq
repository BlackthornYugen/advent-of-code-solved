# https://adventofcode.com/2020/day/3 part 3 in jq

def simulateToboggan($x; $y):
to_entries | 
[
    .[] 
    | { 
        key, value, line: .value, path: (
            (
                . + {y: (.key / $y)} 
              | . + {x: (.y * $x % (.value | length))}
            ) as $params 
            | .value
            | 
            if   $params.key != 0 and $params.key % $y == 0
            then capture("(?<left>.{\($params.x)})(?<path>.{\(1)})(?<right>.*)") | (.left + ( .path | sub("#"; "X" ) | sub("\\."; "O")) + .right) 
            else $params.value
            end )
      }
    | . + { trees: .path | indices("X") | length }
    | { path, trees, simulation: "Right \($x), down \($y)", linenumber: (.key + 1)}
    | debug
]
| reduce .[] as $item (0; . + $item.trees )
;


split("\n")
|  simulateToboggan(1;1) *
   simulateToboggan(3;1) *
   simulateToboggan(5;1) *
   simulateToboggan(7;1) *
   simulateToboggan(1;2)


# That's not the right answer. If you're stuck, make sure you're using the full input data; there are also some general tips on the about page, or you can ask for hints on the subreddit. Please wait one minute before trying again. (You guessed 13.) [Return to Day 3]
# That's not the right answer. If you're stuck, make sure you're using the full input data; there are also some general tips on the about page, or you can ask for hints on the subreddit. Please wait one minute before trying again. (You guessed 7.)  [Return to Day 3]
# OH! Add modulos! 
# That's the right answer! You are one gold star closer to saving your vacation. [Continue to Part Two]
# That's not the right answer; your answer is too high. If you're stuck, make sure you're using the full input data; there are also some general tips on the about page, or you can ask for hints on the subreddit. Please wait one minute before trying again. (You guessed 2568729240.) [Return to Day 3]
# That's not the right answer; your answer is too high. If you're stuck, make sure you're using the full input data; there are also some general tips on the about page, or you can ask for hints on the subreddit. Please wait one minute before trying again. (You guessed 2568729240.) [Return to Day 3]
# Oh, I forgot to handle not adding to x on lines skipped by y.
# That's the right answer! You are one gold star closer to saving your vacation.


#          ..##.......
#          #...#...#..
#          .#....#..#.
#          ..#.#...#.#
#          .#...##..#.
#          ..#.##.....
#          .#.#.#....#
#          .#........#
#          #.##...#...
#          #...##....#
#          .#..#...#.#