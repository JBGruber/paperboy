test_that("status", {
  expect_message(
    pb_collect("https://httpbin.org/status/404"),
    "1 link had issues."
  )
  expect_error(
    pb_collect("test"),
    "Connection error. Set"
  )
  expect_equal(
    dim(pb_collect("test", ignore_fails = TRUE)),
    c(1, 5)
  )
})

test_that("expandurls", {
  expect_equal(
    dim(pb_collect(urls = "https://httpbin.org/")),
    c(1, 5)
  )
  expect_warning(
    pb_collect(urls = "https://httpbin.org/delay/10", timeout = 1, ignore_fails = TRUE),
    "download did not finish before timeout."
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

test_that("rss", {
  expect_equal({
    res <- pb_collect(urls = "https://rss.nytimes.com/services/xml/rss/nyt/World.xml")
    c(nrow(res) > 1, ncol(res))
  }, c(1, 5))
})
