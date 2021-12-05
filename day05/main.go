package main

import (
    "fmt"
    "io/ioutil"
    "strings"
    "strconv"
)

type Point struct {
    x, y int
}

type Line struct {
    x1, x2, y1, y2, xd, yd int
}

func readInput(n string) ([]string, error) {
	data, err := ioutil.ReadFile(n)
	return strings.Split(strings.TrimSpace(string(data)), "\n"), err
}

// Surprised the math stdlib doesn't include this.
func signum(x int) int {
    if x > 0 {
        return 1
    }
    if x < 0 {
        return -1
    }
    return 0
}

func parsePoint(line string) Line {
    segments := strings.Split(line, " -> ")
    seg1 := strings.Split(segments[0], ",")
    seg2 := strings.Split(segments[1], ",")

    x1, _ := strconv.Atoi(seg1[0])
    y1, _ := strconv.Atoi(seg1[1])
    x2, _ := strconv.Atoi(seg2[0])
    y2, _ := strconv.Atoi(seg2[1])

    xd := signum(x2 - x1)
    yd := signum(y2 - y1)

    return Line{x1, x2, y1, y2, xd, yd}
}

func part1(input []string) int {
    grid := make(map[Point]int)

    for _, line := range input {
        l := parsePoint(line)

        if l.xd != 0 && l.yd != 0 {
			continue
		}

        for xNew, yNew := l.x1, l.y1; yNew != l.y2 || xNew != l.x2; xNew, yNew = xNew + l.xd, yNew + l.yd {
			grid[Point{xNew, yNew}]++
		}

        grid[Point{l.x2, l.y2}] += 1
    }

    var count int
    for _, val := range grid {
        if val >= 2 {
            count += 1
        }
    }

    return count
}

func part2(input []string) int {
    grid := make(map[Point]int)

    for _, line := range input {
        l := parsePoint(line)

        for xNew, yNew := l.x1, l.y1; yNew != l.y2 || xNew != l.x2; xNew, yNew = xNew + l.xd, yNew + l.yd {
			grid[Point{xNew, yNew}]++
		}

        grid[Point{l.x2, l.y2}] += 1
    }

    var count int
    for _, val := range grid {
        if val >= 2 {
            count += 1
        }
    }

    return count
}

func main() {
	input, err := readInput("./input")
	if err != nil {
		panic(err)
	}

    pt1 := part1(input)
    pt2 := part2(input)

    fmt.Println("Part 1: ", pt1)
    fmt.Println("Part 2: ", pt2)
}
