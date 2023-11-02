test_that("Test infrascture", {
  expect_message(
    pb_deliver("google.com", verbose = TRUE),
    "No parser for domain"
  )
  # only warn first time
  expect_no_message(
    pb_deliver("google.com", verbose = TRUE)
  )
  # still warn with new site
  expect_message(
    pb_deliver("duckduckgo.com/", verbose = TRUE),
    "No parser for domain"
  )
  expect_equal(
    nrow(pb_deliver("duckduckgo.com/", try_default = FALSE)),
    0L
  )
  expect_error(
    pb_deliver(list("google.com"), verbose = FALSE),
    "No method for class list."
  )
  expect_error(
    pb_deliver(data.frame(test = "google.com"), verbose = FALSE),
    "must be a character vector of URLs"
  )
  expect_message(
    pb_deliver(pb_collect("https://httpbin.org/status/404", verbose = FALSE)),
    "1 URL removed due to bad status."
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
