package main

import (
	"context"
	"fmt"
	"log/slog"
	"os"
	"strings"

	"github.com/BlackthornYugen/advent-of-code-solved/2025/lib"
)

func main() {
	inputFilename := lib.Setup()

	input, err := os.ReadFile(inputFilename)
	if err != nil {
		panic(err)
	}
	inputStr := string(input)

	fmt.Printf("Part 1: %s\n", Part1(inputStr))
	fmt.Printf("Part 2: %s\n", Part2(inputStr))
}

func Part1(input string) string {
	tachyonBeamCount := 0
	input = strings.TrimSpace(input)
	lines := strings.Split(input, "\n")
	for activeLineNum, line := range lines {
		for activeColumnNum, character := range line {
			if (activeLineNum < len(lines)-1) && (string(character) == "S" || string(character) == "|") {
				slog.Log(context.Background(), lib.TraceLogLevel, "Found beam source or beam",
					"line", activeLineNum,
					"column", activeColumnNum,
					"char", string(character),
					"tachyonBeamCount", tachyonBeamCount,
				)
				// if char on next line at same column is '.', replace it with '|', if '^', replace adjacent '.'s with '|'
				switch lines[activeLineNum+1][activeColumnNum] {
				case '.':
					slog.Log(context.Background(), lib.TraceLogLevel, "Replacing . with | below S")
					lines[activeLineNum+1] = lines[activeLineNum+1][:activeColumnNum] + "|" + lines[activeLineNum+1][activeColumnNum+1:]
				case '^':
					tachyonBeamCount++
					slog.Log(context.Background(), lib.TraceLogLevel, "Replacing .s with |s adjacent to ^ below S")
					// Replace left adjacent '.'
					if activeColumnNum > 0 && lines[activeLineNum+1][activeColumnNum-1] == '.' {
						lines[activeLineNum+1] = lines[activeLineNum+1][:activeColumnNum-1] + "|" + lines[activeLineNum+1][activeColumnNum:]
					}
					// Replace right adjacent '.'
					if activeColumnNum < len(lines[activeLineNum+1])-1 && lines[activeLineNum+1][activeColumnNum+1] == '.' {
						lines[activeLineNum+1] = lines[activeLineNum+1][:activeColumnNum+1] + "|" + lines[activeLineNum+1][activeColumnNum+2:]
					}
				}
			}
		}
	}
	return fmt.Sprintf("%d", tachyonBeamCount)
}

func Part2(input string) string {
	return "Not implemented"
}
