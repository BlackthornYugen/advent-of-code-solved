package main

import (
	"context"
	"fmt"
	"log/slog"
	"os"
	"regexp"
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
	return processRanges(input, func(idToBeChecked string) bool {
		for i := 0; i <= len(idToBeChecked)/2; i++ {
			if strings.Contains(idToBeChecked[0:i], idToBeChecked[i:]) {
				return true
			}
		}
		return false
	})
}

func Part2(input string) string {
	regexCache := make(map[string]*regexp.Regexp)
	return processRanges(input, func(idToBeChecked string) bool {
		for i := 0; i < len(idToBeChecked)/2; i++ {
			// dynamic regex that checks for any repeating sequence
			var pattern string = fmt.Sprintf("^(%s){%d}$", idToBeChecked[0:i+1], len(idToBeChecked)/(i+1))
			re, ok := regexCache[pattern]
			if !ok {
				re = regexp.MustCompile(pattern)
				regexCache[pattern] = re
			}
			if re.MatchString(idToBeChecked) {
				return true
			}
		}
		return false
	})
}

func processRanges(input string, isInvalid func(string) bool) string {
	productIdRanges := strings.Split(input, ",")
	sumOfIds := 0

	for _, rangeStr := range productIdRanges {
		rangeParts := strings.Split(rangeStr, "-")
		if len(rangeParts) != 2 {
			slog.Error("Invalid range", "range", rangeStr)
			continue
		}

		start, _ := strconv.Atoi(rangeParts[0])
		end, _ := strconv.Atoi(rangeParts[1])
		slog.LogAttrs(context.TODO(), slog.LevelDebug-1, "Processing range",
			slog.String("range", rangeStr),
			slog.Int("start", start),
			slog.Int("end", end),
		)
		if start > end {
			slog.Error("Invalid range: start is greater than end", "range", rangeStr)
			continue
		}

		for numericId := start; numericId <= end; numericId++ {
			idToBeChecked := strconv.Itoa(numericId)
			if isInvalid(idToBeChecked) {
				slog.Debug("Invalid ID", "id", numericId)
				sumOfIds += numericId
				slog.Log(context.TODO(), slog.LevelDebug-1, "Valid product ID", "id", numericId)
			}
		}
	}
	return strconv.Itoa(sumOfIds)
}
