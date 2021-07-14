test_that("expandurls", {
  expect_equal({
      res <- expandurls(url = "https://httpbin.org/")
      c(nrow(res), ncol(res))
    }, c(1, 4))
  expect_warning(
    expandurls(url = "https://httpbin.org/delay/10", timeout = 1, ignore_fails = TRUE),
    "1 job(s) did not finish before timeout. Think about increasing the timeout parameter. Enter ?expandurls for help.",
    fixed = TRUE
  )
})
