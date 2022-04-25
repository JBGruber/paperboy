test_that("expandurls", {
  expect_equal({
      res <- pb_collect(urls = "https://httpbin.org/")
      c(nrow(res), ncol(res))
    }, c(1, 5))
  expect_warning(
    pb_collect(urls = "https://httpbin.org/delay/10", timeout = 1, ignore_fails = TRUE),
    "1 job(s) did not finish before timeout. Think about increasing the timeout parameter. Enter ?pb_collect for help.",
    fixed = TRUE
  )
})

test_that("send cookies", {
  expect_equal({
    pb_collect("https://httpbin.org/cookies", cookies = list(a = 1, b = 2), verbose = FALSE)$content_raw
  }, "{\n  \"cookies\": {\n    \"a\": \"1\", \n    \"b\": \"2\"\n  }\n}\n")
  expect_error(
    pb_collect("https://httpbin.org/cookies", cookies = 1, verbose = FALSE),
    "cookies must be provided in name = value pairs. For example, cookies = list(a = 1, b = 2)",
    fixed = TRUE
  )
})
