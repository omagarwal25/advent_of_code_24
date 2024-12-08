import day1
import day2
import day3
import day4
import day5
import day6
import day7
import day8
import gleam/int
import pocket_watch

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
    "6" -> #(day6.part_one, day6.part_two)
    "7" -> #(day7.part_one, day7.part_two)
    "8" -> #(day8.part_one, day8.part_two)
    _ -> #(fn(_) { 0 }, fn(_) { 0 })
  }

  let print_time = fn(label, elapsed) { io.println(label <> elapsed) }

  {
    use <- pocket_watch.callback("Part 1 time: ", print_time)

    io.println("Part 1: " <> part1(input) |> int.to_string)
  }

  {
    use <- pocket_watch.callback("Part 2 time: ", print_time)

    io.println("Part 2: " <> part2(input) |> int.to_string)
  }
  Ok(Nil)
}
