test_parse_rss <- function(rss) {

  test_that(desc = paste("test:", rss), {
    expect_no_error({
      test_df <- pb_collect(rss, collect_rss = TRUE, verbose = FALSE, timeout = 90)
      if (all(!test_df$status < 400L)) {
        stop("No data could be retrieved from the RSS feed")
      }
      test_parser(test_df)
    })
  })

}

if (as.logical(Sys.getenv("PB_TEST_PARSER", unset = "FALSE"))) {
  status <- utils::read.csv(system.file("status.csv", package = "paperboy"))
  rss_feeds <- setdiff(
    na.omit(status$rss),
    c(
      "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
    )
  )
  lapply(rss_feeds, test_parse_rss)
}
