test_that("multiplication works", {
  expect_warning(
    deliver("google.com"),
    "No method for www.google.com yet. Url ignored."
  )
  expect_equal(
    {
      out <- suppressWarnings(deliver("google.com"))
      c(class(out), ncol(out), nrow(out))
    }, c("tbl_df", "tbl", "data.frame", "0", "0")
  )
})
