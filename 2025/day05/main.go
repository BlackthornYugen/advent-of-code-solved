package main

import (
	"context"
	"fmt"
	"log/slog"
	"os"
	"strconv"
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

type Range struct {
	Start int
	End   int
}

func Part1(input string) string {
	freshIngredients := 0
	freshRanges := []Range{}
	lines := strings.Split(input, "\n")
	parseRanges := true
	for _, line := range lines {
		// Check for blank line separating sections
		if line == "" {
			parseRanges = false
			continue
		}

		if parseRanges {
			// parse fresh ranges
			parts := strings.Split(line, "-")
			freshRange := Range{}
			from, _ := strconv.Atoi(parts[0])
			to, _ := strconv.Atoi(parts[1])
			freshRange.Start = from
			freshRange.End = to
			freshRanges = append(freshRanges, freshRange)
			slog.Log(context.TODO(), lib.TraceLogLevel, "Processing fresh ranges", "from", freshRange.Start, "to", freshRange.End)
		} else {
			// parse ingredients
			ingredient, _ := strconv.Atoi(line)
			for _, freshRange := range freshRanges {
				// slog.Log(context.TODO(), lib.TraceLogLevel, "Checking ingredient", "from", from, "to", to)
				if ingredient >= freshRange.Start && ingredient <= freshRange.End {
					freshIngredients++
					slog.Debug("Ingredient is fresh",
						"ingredient", ingredient,
						"from", freshRange.Start,
						"to", freshRange.End,
						"freshIngredients", freshIngredients,
					)
					break
				}
			}
			slog.Log(context.TODO(), lib.TraceLogLevel, "Ingredient is spoiled",
				"ingredient", ingredient,
				"freshIngredients", freshIngredients,
			)
		}
	}
	return strconv.Itoa(freshIngredients)
}

func Part2(input string) string {
	return "Not implemented"
}
