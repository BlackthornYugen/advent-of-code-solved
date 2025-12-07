package main

import (
	"context"
	"fmt"
	"log/slog"
	"os"
	"strings"

	"github.com/BlackthornYugen/advent-of-code-solved/2025/lib"
)

func main() {
	inputFilename := lib.Setup()

	input, err := os.ReadFile(inputFilename)
	if err != nil {
		panic(err)
	}
	inputStr := strings.TrimSpace(string(input))

	fmt.Printf("Part 1: %s\n", Part1(inputStr))
	fmt.Printf("Part 2: %s\n", Part2(inputStr))
}

func Part1(input string) string {
	lines := strings.Split(input, "\n")
	accessibleObjects := 0
	for y, line := range lines {
		slog.Log(context.TODO(), lib.TraceLogLevel, "Processing line", "index", y, "value", line)
		for x := 0; x < len(line); x++ {
			// slog.Debug("Processing character", "index", i, "value", string(line[i]))
			switch string(line[x]) {
			case ".":
				slog.Log(context.TODO(), lib.TraceLogLevel, "Found open space", "value", string(line[x]))
			case "@":
				nearbyObjects := -1 // default to -1 to not count self
				// check above
				if y > 0 {
					aboveMe := lines[y-1][max(x-1, 0):min(x+2, len(lines[y-1]))]
					nearbyObjects += strings.Count(aboveMe, "@")
				}
				// check beside
				{
					besideMe := line[max(x-1, 0):min(x+2, len(line))]
					nearbyObjects += strings.Count(besideMe, "@")
				}
				// check below
				if y < len(lines)-1 {
					belowMe := lines[y+1][max(x-1, 0):min(x+2, len(lines[y+1]))]
					nearbyObjects += strings.Count(belowMe, "@")
				}

				if nearbyObjects < 4 {
					accessibleObjects++
					slog.Debug("Object is accessible",
						"value", string(lines[y][x]),
						"position", fmt.Sprintf("(%d,%d)", x, y),
						"nearby_objects", nearbyObjects,
						"accessible_objects_count", accessibleObjects,
					)
				} else {
					slog.Log(context.TODO(), lib.TraceLogLevel, "Object is not accessible",
						"value", string(lines[y][x]),
						"position", fmt.Sprintf("(%d,%d)", x, y),
						"nearby_objects", nearbyObjects,
						"accessible_objects_count", accessibleObjects,
					)
				}
			default:
				slog.Debug("Unknown character", "value", string(line[x]))
			}
		}
	}
	return fmt.Sprintf("%d", accessibleObjects)
}

func Part2(input string) string {
	return "Not implemented"
}
