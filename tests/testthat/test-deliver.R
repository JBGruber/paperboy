test_that("Test infrascture", {
  expect_warning(
    pb_deliver("google.com", verbose = TRUE),
    "No parser for domain"
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

test_scraper <- function(rss) {
  test_that(rss, {
    skip_if_offline()
    expect_equal({
      test <- pb_collect(rss, timeout = 90)$expanded_url[1]
      out <- pb_deliver(test, verbose = FALSE)
      c(sum(is.na(out)) < 4, ncol(out), nrow(out))
    }, c(1, 9, 1))
  })
}

lapply(c(
  "https://www.cbsnews.com/latest/rss/evening-news",
  "https://www.cnet.com/rss/news/",
  "http://rss.cnn.com/rss/edition.rss",
  "https://www.dailymail.co.uk/news/index.rss",
  "https://www.latimes.com/politics/rss2.0.xml",
  "https://feeds.a.dj.com/rss/RSSOpinion.xml"
), test_scraper)


