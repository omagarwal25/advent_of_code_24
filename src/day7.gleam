import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/regexp
import gleam/result
import gleam/string

type Equation {
  Equation(ans: Int, values: List(Int))
}

fn digit_mul(v: Int, acc: Int) -> Int {
  case v < 10 {
    True -> acc
    False -> digit_mul(v / 10, acc * 10)
  }
}

fn concat(a: Int, b: Int) -> Int {
  a * digit_mul(b, 10) + b
}

fn parse_input(input: String) -> List(Equation) {
  input
  |> string.split("\n")
  |> list.filter(fn(line) { line != "" })
  |> list.map(fn(line) {
    let assert [ans, values] = string.split(line, on: ": ")

    Equation(
      ans: int.parse(ans)
        |> result.unwrap(1_000_000_000_000_000_000_000_000_000_000_000),
      values: values
        |> string.split(on: " ")
        |> list.map(int.parse)
        |> list.map(result.unwrap(
          _,
          10_000_000_000_000_000_000_000_000_000_000_000,
        )),
    )
  })
}

fn part_one_generate_and_check(ans: Int, values: List(Int), acc: Int) -> Bool {
  case values {
    [value, ..rest] ->
      acc < ans
      && part_one_generate_and_check(ans, rest, acc + value)
      || part_one_generate_and_check(ans, rest, acc * value)
    [] -> acc == ans
  }
}

fn part_one_check(equation: Equation) -> Bool {
  part_one_generate_and_check(equation.ans, equation.values, 0)
}

fn add_equation(acc: Int, equation: Equation) -> Int {
  acc + equation.ans
}

fn part_two_generate_and_check(ans: Int, values: List(Int), acc: Int) -> Bool {
  case values {
    [value, ..rest] ->
      acc < ans
      && part_two_generate_and_check(ans, rest, acc + value)
      || part_two_generate_and_check(ans, rest, acc * value)
      || part_two_generate_and_check(ans, rest, concat(acc, value))
    [] -> acc == ans
  }
}

fn part_two_check(equation: Equation) -> Bool {
  part_two_generate_and_check(equation.ans, equation.values, 0)
}

pub fn part_one(input: String) -> Int {
  input
  |> parse_input
  |> list.filter(part_one_check)
  |> list.fold(0, add_equation)
}

pub fn part_two(input: String) -> Int {
  input
  |> parse_input
  |> list.filter(part_two_check)
  |> list.fold(0, add_equation)
}
