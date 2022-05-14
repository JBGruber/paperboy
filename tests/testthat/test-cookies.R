test_that("sending cookies works", {
  expect_equal(
    {
      cookies <- pb_read_cookies(system.file("extdata", "example_cookies.txt", package = "paperboy"))
      df <- pb_collect("https://httpbin.org/cookies", cookies = cookies)
      df$content_raw
    },
    "{\n  \"cookies\": {\n    \"test\": \"succesful%21\"\n  }\n}\n"
  )
})
