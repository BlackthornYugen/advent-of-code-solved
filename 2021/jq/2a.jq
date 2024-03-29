# map directions to x & y transformations
{
    "up":       {"x":  0, "y":  1},
    "down":     {"x":  0, "y": -1},
    "forward":  {"x":  1, "y":  0},
    "backward": {"x": -1, "y":  0},
} as $directions |

# break up data on newlines
split("\n") |

# loop through data
reduce .[] as $command ({"x": 0, "y": 0}; 
    . as $position | $command | capture("(?<direction>\\w+) (?<distance>\\d+)"; "g") | { 
        "x": ($position.x + ($directions[.direction].x * (.distance | tonumber))),
        "y": ($position.y + ($directions[.direction].y * (.distance | tonumber)))
    } | debug
)

# Multiply x and -y (depth)
| .x * (.y * -1)