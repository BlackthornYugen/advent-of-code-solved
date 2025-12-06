package main

import (
	"fmt"
	"log/slog"
	"os"
	"regexp"
	"strconv"
	"strings"

	"github.com/BlackthornYugen/advent-of-code-solved/2025/lib"
)

var (
	numberPattern   = regexp.MustCompile(`^\s*-?\d`)
	operatorPattern = regexp.MustCompile(`^[+\-*/]`)
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
	// loop through input on the x and y, x being delimited by spaces, y by newlines
	// use a regex to decide if the line starts with a mathmatical operator or a number
	// if it's a number, we will build up a multidementional array so that we can perform
	// math operations later. The first line that has an operator, we will assume there are
	// as many operators as there were numbers on the x axis. We will use the operator for
	// the nth x for each y. Then sum all the outputs.
	var numbers [][]int

	inputLines := strings.Split(input, "\n")
	sumOfFinalOutputs := 0

	for _, line := range inputLines {
		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}

		if numberPattern.MatchString(line) {
			parts := strings.Fields(line)
			var row []int
			for _, part := range parts {
				number, _ := strconv.Atoi(part)
				row = append(row, number)
			}
			numbers = append(numbers, row)
		} else if operatorPattern.MatchString(line) {
			operators := strings.Fields(line)

			if len(numbers) > 0 {
				columns := len(numbers[0])
				for column := range columns {
					if column >= len(operators) {
						break
					}

					operator := operators[column]
					value := numbers[0][column]

					for row := 1; row < len(numbers); row++ {
						operand := numbers[row][column]
						switch operator {
						case "+":
							value += operand
						case "-":
							value -= operand
						case "*":
							value *= operand
						case "/":
							value /= operand
						}
					}
					sumOfFinalOutputs += value
				}
			}
			break
		}
	}
	return fmt.Sprintf("%d", sumOfFinalOutputs)
}

func Part2(input string) string {
	// Loop through all the lines until we find the operator line,
	// the operator line will be used to find the substring to for
	// the numeric lines that preceed it. So "*    + /" would inform
	// us that the first multiplication operands can be found between
	// 0-4, the second operands for addition are found at 5-6, and the
	// division operants are found at 7-EOL.
	// The operands are then parsed along the y axis from the most
	// significant digit at the first line and least at the bottom.

	inputLines := strings.Split(input, "\n")
	slog.Debug("Processing input", "lines", len(inputLines))
	var operatorLine string
	var operands [][]int
	var operatorIndecies []int

	for _, line := range inputLines {
		if operatorPattern.MatchString(line) {
			operatorLine = line
			// store index of all non-whitespace chars
			for i, char := range line {
				if !strings.ContainsRune(" ", char) {
					operatorIndecies = append(operatorIndecies, i)
				}
			}
			// outer index is the line length
			operands = make([][]int, len(inputLines[0]))
			// inner index is the number of lines before the operator line
			for i := 0; i < len(operands); i++ {
				operands[i] = make([]int, (len(operatorIndecies) - 1))
			}
			break
		}
	}

	for lineIndex, line := range inputLines {
		if operatorPattern.MatchString(line) {
			break
		}
		if numberPattern.MatchString(line) {
			for operatorIndex, startIndex := range operatorIndecies {
				var endIndex int
				if operatorIndex == len(operatorIndecies) {
					break
				} else if operatorIndex+1 == len(operatorIndecies) {
					endIndex = -1
				} else {
					endIndex = operatorIndecies[operatorIndex+1] - 1
				}

				var operandDigits string
				if endIndex > 0 {
					operandDigits = line[startIndex:endIndex]
				} else {
					operandDigits = line[startIndex:]
				}
				for operandIndex, operandDigit := range operandDigits {
					var column = startIndex + operandIndex
					var digit int = int(operandDigit - '0')
					if column < (len(operands)-1) && lineIndex < (len(operands[column])) {
						if digit >= 0 && digit <= 9 {
							operands[column][lineIndex] = digit
						} else {
							operands[column][lineIndex] = -1
						}
					}
				}

				slog.Debug("Extracting operand",
					"line", line,
					"startIndex", startIndex,
					"endIndex", endIndex,
					"operandDigits", operandDigits,
				)
			}
		}
	}

	for _, thing := range operands {

		slog.Debug("A", "0", thing[0], "1", thing[1], "2", thing[2])
	}

	slog.Debug("Processing complete",
		slog.String("Operator Line", operatorLine),
		slog.Int("operands", len(operands)),
		slog.String("operatorIndecies", strings.Join(strings.Fields(fmt.Sprint(operatorIndecies)), ",")),
	)

	return fmt.Sprintf("%d", 0)
}
