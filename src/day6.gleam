import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/regexp
import gleam/result
import gleam/string

type Tile {
  Empty(visited: Bool)
  Wall
}

type Grid =
  Dict(#(Int, Int), Tile)

type Direction {
  Up
  Down
  Left
  Right
}

fn next_direction(current: Direction) -> Direction {
  // always turn right
  case current {
    Up -> Right
    Right -> Down
    Down -> Left
    Left -> Up
  }
}

fn next_coords(current: #(Int, Int), dir: Direction) -> #(Int, Int) {
  let #(x, y) = current

  case dir {
    Up -> #(x, y - 1)
    Down -> #(x, y + 1)
    Left -> #(x - 1, y)
    Right -> #(x + 1, y)
  }
}

fn parse_grid(input: String) -> Grid {
  let lines = string.split(input, on: "\n")

  use grid, line, line_index <- list.index_fold(lines, dict.new())
  use grid, char, col_index <- list.index_fold(string.to_graphemes(line), grid)

  let tile = case char {
    "." -> Empty(False)
    "#" -> Wall
    "^" -> Empty(True)
    _ -> Empty(False)
  }

  dict.insert(grid, #(col_index, line_index), tile)
}

fn find_guard_at_start(grid: Grid) -> Option(#(Int, Int)) {
  use acc, k, v <- dict.fold(grid, None)

  case v {
    Empty(True) -> Some(k)
    _ -> acc
  }
}

fn walk(grid: Grid, curr: #(Int, Int), dir: Direction) {
  let new_tile = Empty(True)
  let grid = dict.insert(grid, curr, new_tile)

  let next = next_coords(curr, dir)
  let tile = dict.get(grid, next)

  case tile {
    Ok(Wall) ->
      walk(grid, next_coords(curr, next_direction(dir)), next_direction(dir))
    Ok(Empty(_)) -> walk(grid, next_coords(curr, dir), dir)
    Error(_) -> grid
  }
}

pub fn part_one(input: String) -> Int {
  let grid = parse_grid(input)
  let starting = find_guard_at_start(grid) |> option.unwrap(#(0, 0))

  let new_grid = walk(grid, starting, Up)

  dict.filter(new_grid, fn(_k, v) {
    case v {
      Empty(True) -> True
      _ -> False
    }
  })
  |> dict.size
}

pub fn part_two(input: String) -> Int {
  todo
}
