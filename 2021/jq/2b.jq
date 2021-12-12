# map instructions to x & y transformations
{
    "up":       {"x":  0, "aim":  1},
    "down":     {"x":  0, "aim": -1},
    "forward":  {"x":  1, "aim":  0},
    "backward": {"x": -1, "aim":  0},
} as $instructions |

# break up data on newlines
split("\n") |

# loop through data
reduce .[] as $command ({"x": 0, "y": 0, "aim": 0}; 
    . as $submarine | $command | capture("(?<instruction>\\w+) (?<distance>\\d+)"; "g") | { distance: (.distance | tonumber), instruction } |

    # Update the submarine's aim
    {distance, instruction, aim: ($submarine.aim + $instructions[.instruction].aim * .distance) } |

    # Update the submarine's location
    { 
        "x": ($submarine.x + ($instructions[.instruction].x * .distance)),
        "y": ($submarine.y + ($instructions[.instruction].x * $submarine.aim * .distance)),
        aim
    } | debug
)

# Multiply x and -y (depth)
| .x * (.y * -1)