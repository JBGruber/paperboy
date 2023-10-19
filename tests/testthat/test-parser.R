test_parse_rss <- function(rss, mock = FALSE) {

  mock_fun <- if (mock) mock_record else NULL

  test_that(desc = paste("test:", rss), {
    expect_no_error({
      test_df <- pb_collect(rss,
                            collect_rss = TRUE,
                            verbose = FALSE,
                            mock = mock_fun,
                            timeout = 90)
      if (all(!test_df$status < 400L)) {
        stop("No data could be retrieved from the RSS feed")
      }
      test_parser(test_df)
    })
  })

}

mock_record <- function(urls) {
  db <- readRDS("test_db.rds")
  out <- db[db$url %in% urls, c("url", "expanded_url", "status", "content_raw")]
  if (nrow(out) < length(urls)) {
    new <- pb_collect(urls[!db$url %in% urls], verbose = FALSE)
    db <- rbind(
      out,
      new
    )
  }
  saveRDS(rbind(db, new), "test_db.rds")
  out
}


status <- utils::read.csv(system.file("status.csv", package = "paperboy"))
rss_feeds <- setdiff(
  na.omit(status$rss),
  c(
    "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
  )
)
if (as.logical(Sys.getenv("PB_TEST_PARSER", unset = "FALSE"))) {
  lapply(rss_feeds, test_parse_rss)
} else {
  lapply(rss_feeds, function(rss) test_parse_rss(rss, mock = TRUE))
}
