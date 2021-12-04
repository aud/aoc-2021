package main

import (
	"fmt"
	"strings"
	"io/ioutil"
	"strconv"
)

type Entry struct {
	value  int
	hit bool
}

type GameBoard struct {
	board [5][5]Entry
	solved  bool
}

func readInput(n string) ([]string, error) {
	data, err := ioutil.ReadFile(n)
	return strings.Split(string(data), "\n"), err
}

func solved(gb GameBoard) bool {
	for i := 0; i < 5; i++ {
		rows := 0
		cols := 0

		for j := 0; j < 5; j++ {
			if gb.board[j][i].hit {
				cols++
			}

			if gb.board[i][j].hit {
				rows++
			}
		}

		if rows == 5 || cols == 5 {
			return true
		}
	}

	return false
}

func generateGameBoards(input []string) []GameBoard {
	gbs := []GameBoard{}

	for i := 0; i < (len(input)) / 6; i++ {
		gb := GameBoard{}

		for j := 0; j <= 5; j++ {
			row := []string{}

			// The offsets here are tricky
			for _, v := range strings.Split(input[2 + j + (i * 6)], " ") {
				if len(v) > 0 {
					row = append(row, v)
				}
			}

			for k := range row {
				i, _ := strconv.Atoi(row[k])
				gb.board[j][k] = Entry{i, false}
			}
		}

		gbs = append(gbs, gb)
	}

	return gbs
}

func generateDrawn(input []string) []int {
	drawn := []int{}

	for _, v := range strings.Split(input[0], ",") {
		i, _ := strconv.Atoi(v)
		drawn = append(drawn, i)
	}

	return drawn
}

func solveAllBoards(gbs []GameBoard, drawn []int) []int {
	var sums []int

	for _, v := range drawn {
		for idx, gb := range gbs {
			for i := 0; i < 5; i++ {
				for j := 0; j < 5; j++ {
					if gb.board[i][j].value == v {
						gbs[idx].board[i][j].hit = true
					}
				}
			}
		}

		for idx := 0; idx < len(gbs); idx++ {
			gb := gbs[idx]

			if solved(gb) {
				if gb.solved == true {
					continue
				}

				sum := 0

				for i := 0; i < 5; i++ {
					for j := 0; j < 5; j++ {
						if gbs[idx].board[i][j].hit == false {
							sum += gbs[idx].board[i][j].value
						}
					}
				}

				sums = append(sums, sum * v)
				gbs[idx].solved = true
			}
		}
	}

	return sums
}

func main() {
	input, err := readInput("./input")
	if err != nil {
		panic(err)
	}

	gbs := generateGameBoards(input)
	drawn := generateDrawn(input)

	results := solveAllBoards(gbs, drawn)

	fmt.Println("Part 1: ", results[0])
	fmt.Println("Part 2: ", results[len(results) - 1])
}
