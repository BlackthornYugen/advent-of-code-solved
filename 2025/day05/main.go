package main

import (
	"context"
	"fmt"
	"log/slog"
	"os"
	"sort"
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

type Ranges []Range

func (r Ranges) Len() int {
	return len(r)
}

func (r Ranges) Swap(i, j int) {
	r[i], r[j] = r[j], r[i]
}

// Sort by start, then by end.
func (r Ranges) Less(i, j int) bool {
	startCmp := 0
	if r[i].Start < r[j].Start {
		startCmp = -1
	} else if r[i].Start > r[j].Start {
		startCmp = 1
	}

	if startCmp != 0 {
		return startCmp < 0
	}

	return r[i].End < r[j].End
}

func Part1(input string) string {
	freshIngredients := 0
	freshRanges := Ranges{}
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
			freshRanges = append(freshRanges, parseRange(line))
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
	freshRanges := Ranges{}
	freshCount := 0

	lines := strings.Split(input, "\n")
	for _, line := range lines {
		if line == "" {
			break
		}
		freshRanges = append(freshRanges, parseRange(line))
	}
	slog.Debug("Starting Part 2 processing",
		"linesCount", len(lines),
		"freshRangesCount", len(freshRanges),
	)

	// Sort the fresh ranges
	sort.Sort(freshRanges)
	for index, freshRange := range freshRanges {
		slog.Debug("Merged fresh range",
			"index", index,
			"start", freshRange.Start,
			"end", freshRange.End,
		)
	}
	slog.Debug("Sorted fresh ranges", "count", len(freshRanges))

	// merge ranges in new collection
	mergedRanges := Ranges{}
	activeRange := freshRanges[0]
	for index := 1; index < len(freshRanges); index++ {
		currentRange := freshRanges[index]
		if currentRange.Start <= activeRange.End+1 {
			// Overlapping or contiguous ranges, merge them
			if currentRange.End > activeRange.End {
				activeRange.End = currentRange.End
			}
		} else {
			// Non-overlapping range, add to merged list
			freshCount += activeRange.End - activeRange.Start + 1
			slog.Debug("Add merged range",
				"index", index,
				"start", activeRange.Start,
				"end", activeRange.End,
				"fresh_count", freshCount,
			)
			mergedRanges = append(mergedRanges, activeRange)
			activeRange = currentRange
		}
	}
	// Don't forget to add the last active range
	freshCount += activeRange.End - activeRange.Start + 1
	slog.Debug("Add merged range",
		"start", activeRange.Start,
		"end", activeRange.End,
		"fresh_count", freshCount,
	)
	mergedRanges = append(mergedRanges, activeRange)
	slog.Debug("Merged ranges count", "count", len(mergedRanges))
	return strconv.Itoa(freshCount)
}

func parseRange(line string) Range {
	parts := strings.Split(line, "-")
	start, _ := strconv.Atoi(parts[0])
	end, _ := strconv.Atoi(parts[1])
	freshRange := Range{Start: start, End: end}
	slog.Log(context.TODO(), lib.TraceLogLevel, "Processing fresh ranges", "from", freshRange.Start, "to", freshRange.End)
	return freshRange
}
