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
