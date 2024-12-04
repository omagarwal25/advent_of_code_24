import dot_env/env
import gleam/hackney
import gleam/http/request
import gleam/result.{try}

pub fn get_input(day: String, year: String) -> Result(String, _) {
  let session_cookie = env.get_string_or("SESSION_COOKIE", "session_cookie")

  let assert Ok(request) =
    request.to(
      "https://adventofcode.com/" <> year <> "/day/" <> day <> "/input",
    )

  use response <- try(
    request
    |> request.set_cookie("session", session_cookie)
    |> hackney.send,
  )

  let assert 200 = response.status

  Ok(response.body)
}
