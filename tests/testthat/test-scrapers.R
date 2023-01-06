scrapers <- paste0(
  "paperboy:::pb_deliver_paper.",
  gsub(".", "_", pb_available(), fixed = TRUE)
)

test_that("Test parsers", {
  skip_if_offline()
  skip_on_cran()
  # skip_on_ci()

  expect_message({
    df <- pb_deliver(readLines("test-urls"), verbose = FALSE, timeout = 90L)
    # flag if any of the conditions is TRUE
    misbehaving <- with(
      df,
      is.na(datetime) |
        author == "" |
        nchar(headline) < 10 |
        nchar(text) < 10
    )
    message("Problems with: ", toString(urltools::domain(df$expanded_url[misbehaving])),
            appendLF = FALSE)
  }, "^Problems with: $")
})
