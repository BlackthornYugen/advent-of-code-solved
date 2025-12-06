package main

import (
	"fmt"
	"os"
	"strings"
	"testing"
)

func TestPart1(t *testing.T) {
	tests := []struct {
		file     string
		expected string
	}{
		{"sample.txt", "3"},
		{"input.txt", "1064"},
	}

	for _, tt := range tests {
		t.Run(tt.file, func(t *testing.T) {
			input, err := os.ReadFile(tt.file)
			if err != nil {
				t.Fatal(err)
			}
			inputStr := strings.TrimSpace(string(input))
			if got := Part1(inputStr); got != tt.expected {
				t.Errorf("Part1() = %q, want %q", got, tt.expected)
			}
		})
	}
}

func TestPart2(t *testing.T) {
	tests := []struct {
		file     string
		expected string
	}{
		{"sample.txt", "6"},
		{"input.txt", "6122"},
	}

	for _, tt := range tests {
		t.Run(tt.file, func(t *testing.T) {
			input, err := os.ReadFile(tt.file)
			if err != nil {
				t.Fatal(err)
			}
			inputStr := strings.TrimSpace(string(input))
			if got := Part2(inputStr); got != tt.expected {
				t.Errorf("Part2() = %q, want %q", got, tt.expected)
			}
		})
	}
}

func TestUpdateLock(t *testing.T) {
	tests := []struct {
		name              string
		currentPos        int
		direction         Direction
		amount            int
		expectedRotations int
	}{
		{"Left 1 from 0", 0, Left, 1, 0},
		{"Right 1 from 0", 0, Right, 1, 0},
		{"Left 2 from 1", 1, Left, 2, 1},
		{"Right 2 from 99", 99, Right, 2, 1},
		{"Two rotations left from zero", 0, Left, 299, 2},
		{"Two rotations right from zero", 0, Right, 299, 2},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			_, _, rotations := UpdateLock(tt.currentPos, tt.direction, tt.amount)
			if rotations != tt.expectedRotations {
				t.Errorf("UpdateLock() rotations = %v, want %v", rotations, tt.expectedRotations)
			}
		})
	}
}

func TestFloorDiv(t *testing.T) {
	tests := []struct {
		numerator   int
		denominator int
		expected    int
	}{
		{numerator: 150, denominator: 100, expected: 1},
		{numerator: -150, denominator: 100, expected: -2},
		{numerator: 50, denominator: 100, expected: 0},
		{numerator: -50, denominator: 100, expected: -1},
		{numerator: 200, denominator: 100, expected: 2},
		{numerator: -200, denominator: 100, expected: -2},
		{numerator: 0, denominator: 100, expected: 0},
		{numerator: 10, denominator: 3, expected: 3},
		{numerator: -10, denominator: 3, expected: -4},
	}

	for _, tt := range tests {
		t.Run(fmt.Sprintf("%d/%d", tt.numerator, tt.denominator), func(t *testing.T) {
			if got := floorDiv(tt.numerator, tt.denominator); got != tt.expected {
				t.Errorf("floorDiv(%d, %d) = %d, want %d", tt.numerator, tt.denominator, got, tt.expected)
			}
		})
	}
}
