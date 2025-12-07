package main

import (
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
	totalJoltage := 0
	batteryBanks := strings.Split(input, "\n")
	for _, batteryBank := range batteryBanks {
		slog.Debug("Processing battery bank", "value", batteryBank)
		joltageMostSignificant := batteryBank[0:1]
		joltageLeastSignificant := batteryBank[1:2]
		for i := 2; i < len(batteryBank); i++ {
			if batteryBank[i:i+1] > joltageMostSignificant && len(batteryBank)-1 != i {
				slog.Debug("Found better high battery", "index", i, "value", string(batteryBank[i]))
				joltageMostSignificant = batteryBank[i : i+1]
				joltageLeastSignificant = batteryBank[i+1 : i+2]
			} else if batteryBank[i:i+1] > joltageLeastSignificant {
				slog.Debug("Found better low battery", "index", i, "value", string(batteryBank[i]))
				joltageLeastSignificant = batteryBank[i : i+1]
			}
		}
		slog.Debug("Best batteries",
			"most_significant", string(joltageMostSignificant),
			"least_significant", string(joltageLeastSignificant),
		)
		val, _ := strconv.Atoi(joltageMostSignificant + joltageLeastSignificant)
		totalJoltage += val
	}
	return strconv.Itoa(totalJoltage)
}

func Part2(input string) string {
	slog.Info("Day 3 - Part 2 not implemented yet")
	return "Not implemented"
}
