test_that("Test infrascture", {
  expect_warning(
    pb_deliver("google.com", verbose = TRUE),
    "...No method for domain www.google.com yet, attempting generic approach"
  )
  expect_error(
    pb_deliver(list("google.com"), verbose = FALSE),
    "No method for class list."
  )
  expect_error(
    pb_deliver(data.frame(test = "google.com"), verbose = FALSE),
    "x must be a character vector of URLs or a data.frame returned by pb_collect."
  )
  expect_message(
    pb_deliver(pb_collect("https://httpbin.org/status/404", verbose = FALSE)),
    "1 URLs removed due to bad status."
  )
  expect_message(
    pb_deliver(pb_collect("https://httpbin.org/status/200", verbose = FALSE)),
    "Parsing..."
  )
})

test_that("Test theguardian scraper", {
  skip_if_offline()
  expect_equal({
      out <- pb_deliver("https://tinyurl.com/386e98k5", verbose = FALSE)
      c(class(out), ncol(out), nrow(out))
    }, c("tbl_df", "tbl", "data.frame", "9", "1"))
})

test_that("Test huffpost scraper", {
  skip_if_offline()
  expect_equal({
    out <- pb_deliver("https://tinyurl.com/4shbwkxs", verbose = FALSE)
    c(class(out), ncol(out), nrow(out))
  }, c("tbl_df", "tbl", "data.frame", "9", "1"))
})
