package main

import (
	"fmt"
	"log/slog"
	"math"
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

const (
	Left     Direction = 'L'
	Right    Direction = 'R'
	DialSize           = 100
)

type Direction byte

func Part1(input string) string {
	var lock_position int = 50
	lines := strings.Split(input, "\n")
	var zero_count int = 0
	for _, line := range lines {
		if line == "" {
			continue
		}

		amount, _ := strconv.Atoi(line[1:])
		var normalized_position int
		lock_position, normalized_position, _ = UpdateLock(lock_position, Direction(line[0]), amount)

		slog.Debug("Processing line", "line", line, "lock_position", lock_position, "normalized_position", normalized_position)

		if normalized_position == 0 {
			zero_count++
			slog.Debug("++")
		}
	}
	return fmt.Sprintf("%d", zero_count)
}

func Part2(input string) string {
	var lock_position int = 50
	lines := strings.Split(input, "\n")
	var zero_count int = 0
	for _, line := range lines {
		if line == "" {
			continue
		}

		amount, _ := strconv.Atoi(line[1:])
		var normalized_position, rotations int
		lock_position, normalized_position, rotations = UpdateLock(lock_position, Direction(line[0]), amount)

		slog.Debug("Processing line", "line", line, "lock_position", lock_position, "normalized_position", normalized_position, "rotations", rotations)

		zero_count += rotations
		lock_position = normalized_position
	}
	return fmt.Sprintf("%d", zero_count)
}

func UpdateLock(currentPos int, direction Direction, amount int) (int, int, int) {
	if amount < 0 {
		panic("amount must be positive")
	}
	start := currentPos
	var end int
	if direction == Left {
		end = start - amount
	} else {
		end = start + amount
	}

	var rotations int
	if end > start {
		rotations = floorDiv(end, DialSize) - floorDiv(start, DialSize)
	} else if end < start {
		rotations = floorDiv(start-1, DialSize) - floorDiv(end-1, DialSize)
	} else {
		rotations = 0
	}

	normalized := end % DialSize
	if normalized < 0 {
		normalized += DialSize
	}

	return end, normalized, rotations
}

func floorDiv(numerator, denominator int) int {
	return int(math.Floor(float64(numerator) / float64(denominator)))
}
