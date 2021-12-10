#!/usr/bin/env python3

from itertools import permutations

#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....

#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg


def part1(data: str):
    count = 0

    for i in range(len(data)):
        d = data[i].strip().split(" | ")
        out = d[1].split()

        for j in range(len(out)):
            if len(out[j]) in [2, 3, 4, 7]:
                count += 1

    return count

# This took far longer than it should have..
def part2(data: str):
    count = 0

    convert = lambda outs, s : ["".join(sorted(s[i] for i in out)) for out in outs]

    digits = {
        "abcefg": 0,
        "cf": 1,
        "acdeg": 2,
        "acdfg": 3,
        "bcdf": 4,
        "abdfg": 5,
        "abdefg": 6,
        "acf": 7,
        "abcdefg": 8,
        "abcdfg": 9,
    }

    for i in range(len(data)):
        d = data[i].strip().split(" | ")

        signals = d[0].split()
        outputs = d[1].split()

        possible = "abcdefg"

        for perm in permutations(possible):
            s = { signals: outputs for signals, outputs in zip(perm, possible) }

            if all(ss in digits for ss in convert(signals, s)):
                count += int("".join(str(digits[i]) for i in convert(outputs, s)))

    return count

def main():
    file = open("./input")
    data = file.readlines()
    file.close()

    pt1 = part1(data)
    print(f"Part 1: {pt1}")

    pt2 = part2(data)
    print(f"Part 2: {pt2}")

if __name__ == "__main__":
    main()
