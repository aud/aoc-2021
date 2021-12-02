use std::fs;
use std::time::Instant;
use std::time::Duration;

pub enum Command {
    Forward(i32),
    Down(i32),
    Up(i32),
}

fn read_input() -> String {
    String::from(fs::read_to_string("./input.txt").expect("Unable to read file"))
}

fn parse_command(command: &str) -> Option<Command> {
    let chunks: Vec<&str> = command.split(" ").collect();
    let times: i32 = chunks[1].parse().unwrap();

    match chunks[0] {
        "forward" => Some(Command::Forward(times)),
        "down" => Some(Command::Down(times)),
        "up" => Some(Command::Up(times)),
        _ => None,
    }
}

fn part1(input: &[Command]) -> i32 {
    let mut hoz_pos = 0;
    let mut depth = 0;

    for command in input {
        match command {
            Command::Forward(i) => hoz_pos += i,
            Command::Down(i) => depth += i,
            Command::Up(i) => depth -= i,
        }
    }

    hoz_pos * depth
}

fn part2(input: &[Command]) -> i32 {
    let mut hoz_pos = 0;
    let mut depth = 0;
    let mut aim = 0;

    for command in input {
        match command {
            Command::Forward(i) => {
                hoz_pos += i;
                depth += aim * i;
            },
            Command::Down(i) => aim += i,
            Command::Up(i) => aim -= i,
        }
    }

    hoz_pos * depth
}

fn main() {
    let input = read_input();
    let data: Vec<Command> = input.trim()
        .split("\n")
        .into_iter()
        .map(|c| parse_command(c).unwrap())
        .collect();

    // Hacky benchmarking
    // 10k iterations
    let mut total_time = Duration::default();

    for _ in 0..10_000 {
        let now = Instant::now();
        part1(&data);
        let elapsed = now.elapsed();
        total_time += elapsed;
    }
    println!("Part 1: {:?}, 10_000 iters {:?}", part1(&data), total_time);

    for _ in 0..10_000 {
        let now = Instant::now();
        part2(&data);
        let elapsed = now.elapsed();
        total_time += elapsed;
    }
    println!("Part 2: {:?}, 10_000 iters {:?}", part2(&data), total_time)
}
