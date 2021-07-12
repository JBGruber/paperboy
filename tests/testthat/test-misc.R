test_that("normalise_df works", {
  expect_equal(
    names(normalise_df(data.frame(test = TRUE))),
    c("url", "expanded_url", "domain", "status", "datetime", "headline",
      "author", "text", "misc")
  )
})
