test_that("Test infrascture", {
  expect_warning(
    deliver("google.com"),
    "No method for www.google.com yet. Url ignored."
  )
  expect_equal({
      out <- suppressWarnings(deliver("google.com"))
      c(class(out), ncol(out), nrow(out))
    }, c("tbl_df", "tbl", "data.frame", "0", "0"))
})

test_that("Test theguardian scraper", {
  skip_if_offline()
  expect_equal({
      out <- deliver("https://tinyurl.com/386e98k5", verbose = FALSE)
      c(class(out), ncol(out), nrow(out))
    }, c("tbl_df", "tbl", "data.frame", "9", "1"))
})

test_that("Test huffpost scraper", {
  skip_if_offline()
  expect_equal({
    out <- deliver("https://tinyurl.com/4shbwkxs", verbose = FALSE)
    c(class(out), ncol(out), nrow(out))
  }, c("tbl_df", "tbl", "data.frame", "9", "1"))
})
