import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string

type Point =
  #(Int, Int)

type Grid(a) =
  Dict(#(Int, Int), a)

fn parse(input: String) -> Grid(String) {
  let lines = string.split(input, on: "\n")

  use grid, line, line_index <- list.index_fold(lines, dict.new())
  use grid, char, col_index <- list.index_fold(string.to_graphemes(line), grid)

  dict.insert(grid, #(col_index, line_index), char)
}

fn lookup_word(grid: Grid(String), points: List(Point)) -> Result(String, Nil) {
  use string, point <- list.try_fold(points, "")
  use letter <- result.try(dict.get(grid, point))

  Ok(string <> letter)
}

fn count_xmas(grid: Grid(String), origin: Point) {
  let #(row, col) = origin

  let words = [
    [#(row, col), #(row, col + 1), #(row, col + 2), #(row, col + 3)],
    [#(row, col), #(row, col - 1), #(row, col - 2), #(row, col - 3)],
    [#(row, col), #(row + 1, col), #(row + 2, col), #(row + 3, col)],
    [#(row, col), #(row - 1, col), #(row - 2, col), #(row - 3, col)],
    [#(row, col), #(row + 1, col + 1), #(row + 2, col + 2), #(row + 3, col + 3)],
    [#(row, col), #(row - 1, col - 1), #(row - 2, col - 2), #(row - 3, col - 3)],
    [#(row, col), #(row + 1, col - 1), #(row + 2, col - 2), #(row + 3, col - 3)],
    [#(row, col), #(row - 1, col + 1), #(row - 2, col + 2), #(row - 3, col + 3)],
  ]

  use count, word <- list.fold(words, 0)
  case lookup_word(grid, word) {
    Ok("XMAS") -> count + 1
    _ -> count
  }
}

pub fn part_one(input: String) -> Int {
  let grid = input |> parse

  use count, point, _letter <- dict.fold(grid, 0)
  count + count_xmas(grid, point)
}

fn count_x_mas(grid: Grid(String), point: #(Int, Int)) {
  let #(row, col) = point

  let word_1 = [#(row - 1, col - 1), #(row, col), #(row + 1, col + 1)]
  let word_2 = [#(row - 1, col + 1), #(row, col), #(row + 1, col - 1)]

  case lookup_word(grid, word_1), lookup_word(grid, word_2) {
    Ok("MAS"), Ok("MAS")
    | Ok("SAM"), Ok("SAM")
    | Ok("MAS"), Ok("SAM")
    | Ok("SAM"), Ok("MAS")
    -> 1
    _, _ -> 0
  }
}

pub fn part_two(input: String) -> Int {
  let grid = input |> parse

  use count, point, _letter <- dict.fold(grid, 0)
  count + count_x_mas(grid, point)
}
