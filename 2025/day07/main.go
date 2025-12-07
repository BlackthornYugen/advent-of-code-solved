package main

import (
	"context"
	"fmt"
	"hash/fnv"
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
	// hashmap to track timelines
	timelineChart := make(map[uint32]bool)
	canonicalTimelines := make(map[uint32]bool)
	canonicalTimelinesCount := 0
	timelinesDiscovered := -1
	input = strings.TrimSpace(input)
	for len(timelineChart) != timelinesDiscovered {
		var lastTimeline uint32 = 0
		timelinesDiscovered = len(timelineChart)
		activeTimeline := strings.Split(input, "\n")

		for activeLineNum, line := range activeTimeline {
			for activeColumnNum, character := range line {
				if (activeLineNum < len(activeTimeline)-1) && (string(character) == "S" || string(character) == "|") {
					slog.Log(context.Background(), lib.TraceLogLevel, "Found beam source or beam",
						"line", activeLineNum,
						"column", activeColumnNum,
						"char", string(character),
						"alternateTimelines", len(timelineChart),
					)
					// if char on next line at same column is '.', replace it with '|', if '^', replace adjacent '.'s with '|'
					switch activeTimeline[activeLineNum+1][activeColumnNum] {
					case '.':
						slog.Log(context.Background(), lib.TraceLogLevel, "Replacing . with | below S")
						activeTimeline[activeLineNum+1] = activeTimeline[activeLineNum+1][:activeColumnNum] + "|" + activeTimeline[activeLineNum+1][activeColumnNum+1:]
					case '^':
						slog.Log(context.Background(), lib.TraceLogLevel, "Replacing .s with |s adjacent to ^")
						leftTimeline := hashStrings(activeTimeline[0:activeLineNum+1]) + uint32(activeColumnNum-1)
						rightTimeline := hashStrings(activeTimeline[0:activeLineNum+1]) + uint32(activeColumnNum+1)
						if !timelineChart[leftTimeline] && activeColumnNum > 0 && activeTimeline[activeLineNum+1][activeColumnNum-1] == '.' {
							// Replace left adjacent '.'
							timelineChart[leftTimeline] = true
							if lastTimeline > 0 {
								slog.Log(context.Background(), lib.TraceLogLevel, "Switching timelines",
									"from", lastTimeline,
									"to", rightTimeline,
								)
								delete(timelineChart, lastTimeline)
							}
							lastTimeline = leftTimeline
							activeTimeline[activeLineNum+1] = activeTimeline[activeLineNum+1][:activeColumnNum-1] + "|" + activeTimeline[activeLineNum+1][activeColumnNum:]
						} else if !timelineChart[rightTimeline] && activeColumnNum < len(activeTimeline[activeLineNum+1])-1 && activeTimeline[activeLineNum+1][activeColumnNum+1] == '.' {
							// Replace right adjacent '.'
							timelineChart[rightTimeline] = true
							if lastTimeline > 0 {
								slog.Log(context.Background(), lib.TraceLogLevel, "Switching timelines",
									"from", lastTimeline,
									"to", rightTimeline,
								)
								delete(timelineChart, lastTimeline)
							}
							lastTimeline = rightTimeline
							activeTimeline[activeLineNum+1] = activeTimeline[activeLineNum+1][:activeColumnNum+1] + "|" + activeTimeline[activeLineNum+1][activeColumnNum+2:]
						}
					}
				}
			}
		}
		if strings.Contains(activeTimeline[len(activeTimeline)-1], "|") {
			// Lets say all complete timelines are canon
			hash := hashStrings(activeTimeline)
			if canonicalTimelines[hash] {
				slog.Warn("Found duplicate canonical timeline",
					"timelineHash", hash,
					"timeline", activeTimeline,
					"canonicalTimelinesCount", canonicalTimelinesCount,
				)
			}
			canonicalTimelines[hash] = true
			canonicalTimelinesCount = len(canonicalTimelines)
		}
		for _, timelineFragment := range activeTimeline {
			slog.Log(context.Background(), lib.TraceLogLevel, "After iteration",
				"timelinesDiscovered", len(timelineChart),
				"timelineCount", timelinesDiscovered,
				"canonicalTimelineCount", canonicalTimelinesCount,
				"activeTimeline", timelineFragment,
			)
		}
	}
	return fmt.Sprintf("%d", canonicalTimelinesCount)
}

// helper to calculate the hash a list of strings
// https://stackoverflow.com/a/13582881
func hashStrings(input []string) uint32 {
	hash := fnv.New32a()
	for _, str := range input {
		hash.Write([]byte(str))
	}
	return hash.Sum32()
}
