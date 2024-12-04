import gleam/int
import gleam/list
import gleam/regexp
import gleam/result

pub fn part_one(input: String) -> Int {
  let assert Ok(re) =
    regexp.from_string("mul\\([0-9][0-9]?[0-9]?,[0-9][0-9]?[0-9]?\\)")

  let matches =
    regexp.scan(with: re, content: input) |> list.map(fn(m) { m.content })

  int.sum(
    matches
    |> list.map(fn(match) {
      let assert Ok(re) = regexp.from_string("[0-9][0-9]?[0-9]?")

      let numbers =
        regexp.scan(with: re, content: match)
        |> list.map(fn(m) { m.content })
        |> list.map(int.parse)
        |> result.values

      int.product(numbers)
    }),
  )
}

type Op {
  Mul(Int)
  Do
  Dont
}

pub fn part_two(input: String) -> Int {
  let assert Ok(re) =
    regexp.from_string(
      "(mul\\([0-9][0-9]?[0-9]?,[0-9][0-9]?[0-9]?\\))|(do\\(\\))|(don't\\(\\))",
    )

  let matches =
    regexp.scan(with: re, content: input)
    |> list.map(fn(m) { m.content })
    |> list.map(fn(match) {
      case match {
        "do()" -> Do
        "don't()" -> Dont
        _ -> {
          let assert Ok(re) = regexp.from_string("[0-9][0-9]?[0-9]?")

          let numbers =
            regexp.scan(with: re, content: match)
            |> list.map(fn(m) { m.content })
            |> list.map(int.parse)
            |> result.values

          Mul(int.product(numbers))
        }
      }
    })

  list.fold(matches, from: #(True, 0), with: fn(acc, op) {
    case acc, op {
      #(True, x), Mul(y) -> #(True, x + y)
      #(_, x), Do -> #(True, x)
      #(_, x), Dont -> #(False, x)
      #(False, x), _ -> #(False, x)
    }
  }).1
}
