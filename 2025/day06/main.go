package main

import (
	"fmt"
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
	// loop through input on the x and y, x being delimited by spaces, y by newlines
	// use a regex to decide if the line starts with a mathmatical operator or a number
	// if it's a number, we will build up a multidementional array so that we can perform
	// math operations later. The first line that has an operator, we will assume there are
	// as many operators as there were numbers on the x axis. We will use the operator for
	// the nth x for each y. Then sum all the outputs.
	var numbers [][]int

	numberPattern := regexp.MustCompile(`^-?\d`)
	operatorPattern := regexp.MustCompile(`^[+\-*/]`)

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

	return fmt.Sprintf("%d", 0)
}
