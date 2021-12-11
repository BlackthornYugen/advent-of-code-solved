def move:
  {
      "up":       {"x":  0, "y":  1},
      "down":     {"x":  0, "y": -1},
      "forward":  {"x":  1, "y":  0},
      "backward": {"x": -1, "y":  0},
  } as $directions | debug |
  
  capture("(?<direction>\\w+) (?<distance>\\d+)"; "ig") | { 
      "x": ($directions[.direction].x * (.distance | tonumber)),
      "y": ($directions[.direction].y * (.distance | tonumber))
  }
;

move

