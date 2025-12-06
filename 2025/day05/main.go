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

func Part1(input string) string {
	// map the range from int to the range to int
	freshIngredients := 0
	rangeMap := make(map[int]int)
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
			from, _ := strconv.Atoi(parts[0])
			to, _ := strconv.Atoi(parts[1])
			slog.Log(context.TODO(), lib.TraceLogLevel, "Processing fresh ranges", "from", from, "to", to)
			rangeMap[from] = to
		} else {
			// parse ingredients
			for from, to := range rangeMap {
				slog.Log(context.TODO(), lib.TraceLogLevel, "Checking ingredient", "from", from, "to", to)
				ingredient, _ := strconv.Atoi(line)
				if ingredient >= from && ingredient <= to {
					freshIngredients++
					slog.Debug("Ingredient found in range",
						"ingredient", ingredient,
						"from", from,
						"to", to,
						"freshIngredients", freshIngredients,
					)
					break
				} else {
					slog.Log(context.TODO(), lib.TraceLogLevel, "Ingredient not in range",
						"ingredient", ingredient,
						"from", from,
						"to", to,
						"freshIngredients", freshIngredients,
					)
				}
			}
		}
	}
	return strconv.Itoa(freshIngredients)
}

func Part2(input string) string {
	return "Not implemented"
}
