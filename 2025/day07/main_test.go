package main

import (
	"os"
	"strings"
	"testing"
)

func TestPart1(t *testing.T) {
	tests := []struct {
		file     string
		expected string
	}{
		{"sample.txt", "21"},
		{"input.txt", "1590"},
	}

	for _, tt := range tests {
		t.Run(tt.file, func(t *testing.T) {
			if tt.expected == "?" {
				t.Skip("Not implemented")
			}
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
		{"sample.txt", "40"},
		{"input.txt", "42"},
	}

	for _, tt := range tests {
		if tt.expected == "?" {
			t.Skip("Not implemented")
		}
		t.Run(tt.file, func(t *testing.T) {
			input, err := os.ReadFile(tt.file)
			if err != nil {
				t.Fatal(err)
			}
			inputStr := string(input)
			if got := Part2(inputStr); got != tt.expected {
				t.Errorf("Part2() = %q, want %q", got, tt.expected)
			}
		})
	}
}
