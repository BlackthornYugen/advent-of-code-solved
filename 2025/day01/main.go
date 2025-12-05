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
	fmt.Printf("Part 1: %s\n", Part1(inputStr))
}

const (
	Left  Direction = 'L'
	Right Direction = 'R'
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

		if rotations < 0 {
			rotations = -rotations
		}
		zero_count += rotations
		lock_position = normalized_position
	}
	return fmt.Sprintf("%d", zero_count)
}

func UpdateLock(currentPos int, direction Direction, amount int) (int, int, int) {
	if direction == Left {
		currentPos -= amount
	} else {
		currentPos += amount
	}

	normalized := currentPos % 100
	if normalized < 0 {
		normalized += 100
	}

	var rotations int
	if currentPos >= 0 {
		rotations = currentPos / 100
	} else {
		rotations = (currentPos - 99) / 100
	}

	return currentPos, normalized, rotations
}
