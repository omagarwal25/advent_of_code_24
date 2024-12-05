import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/order.{Gt, Lt}
import gleam/result
import gleam/string

fn parse_rules(rules: List(String)) -> Dict(String, List(String)) {
  let parsed = rules |> list.map(string.split(_, on: "|"))
  use acc, rule <- list.fold(parsed, dict.new())

  let assert [value, key] = rule

  use curr_val <- dict.upsert(acc, key)

  case curr_val {
    Some(i) -> [value, ..i]
    None -> [value]
  }
}

fn is_line_valid(rules: Dict(String, List(String)), line: List(String)) -> Bool {
  let rules =
    rules
    |> dict.filter(fn(k, _v) { list.any(line, fn(l) { l == k }) })
    |> dict.map_values(fn(_k, v) {
      list.filter(v, fn(r) { list.any(line, fn(l) { l == r }) })
    })

  list.fold(line, #(True, []), fn(acc, l) {
    let #(valid, past) = acc

    case valid, dict.get(rules, l) {
      False, _ -> acc
      True, Error(_) -> #(True, [l, ..past])
      True, Ok(x) -> {
        case list.all(x, fn(r) { list.any(past, fn(p) { p == r }) }) {
          True -> #(True, [l, ..past])
          False -> #(False, past)
        }
      }
    }
  }).0
}

fn rule_exists(rules: Dict(String, List(String)), later, first) {
  case dict.get(rules, first) {
    Ok(x) -> list.any(x, fn(r) { r == later })
    Error(_) -> False
  }
}

fn get_middle(list: List(String)) {
  list
  |> list.drop(list.length(list) / 2)
  |> list.first
  |> result.try(int.parse)
  |> result.unwrap(0)
}

pub fn part_one(input: String) -> Int {
  let assert [rules, checks] = string.split(input, on: "\n\n")

  let rules = rules |> string.split(on: "\n") |> parse_rules

  checks
  |> string.split(on: "\n")
  |> list.map(string.split(_, on: ","))
  |> list.filter(is_line_valid(rules, _))
  |> list.map(get_middle)
  |> int.sum
}

fn is_line_not_valid(rules, line) {
  !is_line_valid(rules, line)
}

pub fn part_two(input: String) -> Int {
  let assert [rules, checks] = string.split(input, on: "\n\n")

  let rules = rules |> string.split(on: "\n") |> parse_rules

  checks
  |> string.split(on: "\n")
  |> list.map(string.split(_, on: ","))
  |> list.filter(is_line_not_valid(rules, _))
  |> list.map(fn(l) {
    list.sort(l, fn(a, b) {
      case rule_exists(rules, a, b) {
        True -> Gt
        False -> Lt
      }
    })
  })
  |> list.map(get_middle)
  |> int.sum
}
