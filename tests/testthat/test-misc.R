test_that("normalise_df works", {
  expect_equal(
    names(normalise_df(data.frame(test = TRUE))),
    c("url", "expanded_url", "domain", "status", "datetime", "author",
      "headline", "text", "misc")
  )
})

test_that("pb_available works", {
  expect_equal(
    {
      out <- pb_available()
      c(class(out), length(out) > 10)
    },
    c("character", "TRUE")
  )
})
