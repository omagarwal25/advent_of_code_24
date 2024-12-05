import day1
import day2
import day3
import day4
import day5

import argv
import dot_env as dot
import gleam/io
import gleam/result
import input

pub fn main() -> Result(Nil, _) {
  dot.load_default()

  case argv.load().arguments {
    ["run", day] -> run_day(day)
    _ -> {
      let message = "Usage: advent run <day>"
      io.println(message)
      Ok(Nil)
    }
  }
}

fn run_day(day: String) -> Result(Nil, _) {
  use input <- result.try(input.get_input(day, "2024"))

  let #(part1, part2) = case day {
    "1" -> #(day1.part_one, day1.part_two)
    "2" -> #(day2.part_one, day2.part_two)
    "3" -> #(day3.part_one, day3.part_two)
    "4" -> #(day4.part_one, day4.part_two)
    "5" -> #(day5.part_one, day5.part_two)
    _ -> #(fn(_) { 0 }, fn(_) { 0 })
  }

  io.debug(part1(input))
  io.debug(part2(input))

  Ok(Nil)
}
