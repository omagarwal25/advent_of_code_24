import gleam/set

import gleam/dict.{type Dict}
import gleam/list
import gleam/string

type Coord {
  Coord(x: Int, y: Int)
}

type Tile {
  Anntenna(String)
  Empty
}

type Grid =
  Dict(Coord, Tile)

fn parse(input: String) -> Grid {
  let lines = string.split(input, on: "\n")

  use grid, line, line_index <- list.index_fold(lines, dict.new())
  use grid, char, col_index <- list.index_fold(string.to_graphemes(line), grid)

  let tile = case char {
    "." -> Empty
    x -> Anntenna(x)
  }

  dict.insert(grid, Coord(col_index, line_index), tile)
}

fn in_grid(grid: Grid, coord: Coord) -> Bool {
  case dict.get(grid, coord) {
    Ok(_) -> True
    Error(_) -> False
  }
}

fn sub(a, b) {
  let Coord(x1, y1) = a
  let Coord(x2, y2) = b

  Coord(x1 - x2, y1 - y2)
}

fn add(a, b) {
  let Coord(x1, y1) = a
  let Coord(x2, y2) = b

  Coord(x1 + x2, y1 + y2)
}

fn anti_node_part_one(pair: #(Coord, Coord)) -> List(Coord) {
  let #(a, b) = pair
  let diff = sub(a, b)

  [add(a, diff), sub(b, diff)]
}

pub fn part_one(input: String) -> Int {
  let grid = parse(input)

  grid
  |> dict.to_list
  |> list.filter(fn(loc) {
    case loc.1 {
      Empty -> False
      _ -> True
    }
  })
  |> list.group(by: fn(loc) { loc.1 })
  |> dict.values
  |> list.map(fn(locs) { locs |> list.map(fn(loc) { loc.0 }) })
  |> list.fold(set.new(), fn(acc, locs) {
    locs
    |> list.combination_pairs
    |> list.flat_map(anti_node_part_one)
    |> list.filter(fn(loc) { in_grid(grid, loc) })
    |> set.from_list
    |> set.union(acc)
  })
  |> set.size
}

fn ray_cast(grid: Grid, start: Coord, d: Coord, acc: List(Coord)) -> List(Coord) {
  let next = add(start, d)

  case dict.get(grid, next) {
    Ok(_) -> ray_cast(grid, next, d, [next, ..acc])
    Error(_) -> acc
  }
}

fn anti_node_part_two(grid, pair: #(Coord, Coord)) -> List(Coord) {
  let #(a, b) = pair

  list.append(
    ray_cast(grid, a, sub(b, a), [a]),
    ray_cast(grid, b, sub(a, b), [b]),
  )
}

pub fn part_two(input: String) -> Int {
  let grid = parse(input)

  grid
  |> dict.to_list
  |> list.filter(fn(loc) {
    case loc.1 {
      Empty -> False
      _ -> True
    }
  })
  |> list.group(by: fn(loc) { loc.1 })
  |> dict.values
  |> list.map(fn(locs) { locs |> list.map(fn(loc) { loc.0 }) })
  |> list.fold(set.new(), fn(acc, locs) {
    locs
    |> list.combination_pairs
    |> list.flat_map(anti_node_part_two(grid, _))
    |> set.from_list
    |> set.union(acc)
  })
  |> set.size
}
