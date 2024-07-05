test_that("rss is collected", {
  nyt <- pb_collect_rss("https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml")
  expect_s3_class(
    nyt,
    "data.frame"
  )
  expect_more_than(
    nrow(nyt),
    0
  )
  expect_equal({
    c(nrow(nyt) > 1, c("title", "link", "published") %in% colnames(nyt))
  }, rep(TRUE, 4))
})

test_that("rss is expanded", {
  expect_equal({
    res <- pb_collect(urls = "https://rss.nytimes.com/services/xml/rss/nyt/World.xml")
    c(nrow(res) > 1, ncol(res))
  }, c(1, 5))
})
