import gleam/int
import gleam/list
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
}

pub fn part_one(input: String) -> Int {
  let formatted = format(input)

  let heads =
    list.map(formatted, fn(list) { list.first(list) })
    |> result.values
    |> list.sort(by: int.compare)

  let tails =
    list.map(formatted, fn(list) { list.last(list) })
    |> result.values
    |> list.sort(by: int.compare)

  let zipped =
    list.zip(heads, tails)
    |> list.map(fn(args) {
      let #(head, tail) = args

      int.absolute_value(head - tail)
    })

  zipped |> int.sum()
}

pub fn part_two(input: String) -> Int {
  let formatted = format(input)

  let right =
    list.map(formatted, fn(list) { list.last(list) })
    |> result.values
    |> list.sort(by: int.compare)

  let left =
    list.map(formatted, fn(list) { list.first(list) })
    |> result.values
    |> list.sort(by: int.compare)

  left
  |> list.map(fn(num) { list.count(right, fn(n) { n == num }) * num })
  |> int.sum()
}
