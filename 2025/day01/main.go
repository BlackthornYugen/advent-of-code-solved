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
}

func Part1(input string) string {
	var lock_position int = 50
	lines := strings.Split(input, "\n")
	var zero_count int = 0
	for _, line := range lines {
		if line == "" {
			continue
		}
		lock_direction := line[0]
		lock_amount := line[1:]
		lock_amount_int, _ := strconv.Atoi(lock_amount)
		if lock_direction == 'L' {
			lock_position -= lock_amount_int
		} else {
			lock_position += lock_amount_int
		}
		normalized_position := lock_position % 100
		if normalized_position < 0 {
			normalized_position += 100
		}
		slog.Debug("Processing line", "line", line, "lock_position", lock_position, "normalized_position", normalized_position)

		if normalized_position == 0 {
			zero_count++
			slog.Debug("++")
		}
	}
	return fmt.Sprintf("%d", zero_count)
}

func Part2(input string) string {
	panic("Part 2 not implemented")
}
