#!/usr/bin/env ruby
# frozen_string_literal: true

require "benchmark"

def input
  @input ||= DATA.read.split(",").map(&:to_i)
end

# First (lazy) approach:
#
# class LanternFish
#   def initialize(days:)
#     @days = days
#   end

#   def to_s
#     @days
#   end

#   def spawn
#     reset
#     LanternFish.new(days: 9)
#   end

#   def can_spawn?
#     @days.zero?
#   end

#   def decrease_timer
#     @days -= 1
#   end

#   def reset
#     @days = 6
#   end
# end

# def part1
#   lantern_fish = input.map do |days|
#     LanternFish.new(days: days)
#   end

#   18.times do
#     lantern_fish.each do |fish|
#       if fish.can_spawn?
#         lantern_fish << fish.spawn
#       else
#         fish.decrease_timer
#       end
#     end
#   end

#   lantern_fish.count
# end

# Take 2 (PERF!!) -- 10k for 256 is ~4.5s
#
# def solve(days)
#   ocean = Hash.new(0)

#   input.tally.each do |k, v|
#     ocean[k] = v
#   end

#   days.times do
#     pond = Hash.new(0)

#     ocean.each do |fish, count|
#       if fish == 0
#         pond[6] += count
#         pond[8] += count
#       else
#         pond[fish - 1] += count
#       end
#     end

#     # Migrate fish from pond to ocean..
#     ocean = pond
#   end

#   ocean.values.sum
# end

# Take 3, even faster... -- 10k for 256 is ~0.35s
def solve(days)
  ocean = Array.new(9) { 0 }

  input
    .tally
    .each do |fish, count|
    ocean[fish] = count
  end

  days.times do
    new_fish = ocean.shift
    ocean << new_fish
    ocean[6] += new_fish
  end

  ocean.sum
end

def part1
  solve(80)
end

def part2
  solve(256)
end

puts Benchmark.measure {
  10_000.times do
    part2
  end
}
puts "Part 1: #{part1}"
puts "Part 2: #{part2}"

__END__
4,1,4,1,3,3,1,4,3,3,2,1,1,3,5,1,3,5,2,5,1,5,5,1,3,2,5,3,1,3,4,2,3,2,3,3,2,1,5,4,1,1,1,2,1,4,4,4,2,1,2,1,5,1,5,1,2,1,4,4,5,3,3,4,1,4,4,2,1,4,4,3,5,2,5,4,1,5,1,1,1,4,5,3,4,3,4,2,2,2,2,4,5,3,5,2,4,2,3,4,1,4,4,1,4,5,3,4,2,2,2,4,3,3,3,3,4,2,1,2,5,5,3,2,3,5,5,5,4,4,5,5,4,3,4,1,5,1,3,4,4,1,3,1,3,1,1,2,4,5,3,1,2,4,3,3,5,4,4,5,4,1,3,1,1,4,4,4,4,3,4,3,1,4,5,1,2,4,3,5,1,1,2,1,1,5,4,2,1,5,4,5,2,4,4,1,5,2,2,5,3,3,2,3,1,5,5,5,4,3,1,1,5,1,4,5,2,1,3,1,2,4,4,1,1,2,5,3,1,5,2,4,5,1,2,3,1,2,2,1,2,2,1,4,1,3,4,2,1,1,5,4,1,5,4,4,3,1,3,3,1,1,3,3,4,2,3,4,2,3,1,4,1,5,3,1,1,5,3,2,3,5,1,3,1,1,3,5,1,5,1,1,3,1,1,1,1,3,3,1
