import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string

fn format(input: String) -> List(List(Int)) {
  input
  |> string.split("\n")
  |> list.filter(fn(line) { line != "" })
  |> list.map(fn(line) {
    line
    |> string.split(on: " ")
    |> list.map(int.parse)
    |> result.values
  })
  |> list.map(fn(line) {
    let assert [last, ..] = line |> list.reverse
    let assert [first, ..] = line

    case first > last {
      True -> line |> list.reverse
      False -> line
    }
  })
}

fn diffs(input: List(List(Int))) -> List(List(Int)) {
  list.map(input, fn(t) {
    list.fold(t, #([], None), fn(acc, num) {
      let #(list, prev) = acc

      case prev {
        None -> #(list, Some(num))
        Some(p) -> #([num - p, ..list], Some(num))
      }
    }).0
  })
}

fn valid(input: List(Int)) -> Bool {
  list.all(input, fn(num) { num > 0 && num < 4 })
}

pub fn part_one(input: String) -> Int {
  let formatted = format(input)

  formatted |> diffs |> list.count(valid)
}

pub fn part_two(input: String) -> Int {
  let values = format(input)

  use line <- list.count(values)

  list.combinations(line, list.length(line) - 1) |> diffs |> list.any(valid)
}
