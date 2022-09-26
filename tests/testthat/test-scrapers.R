scrapers <- paste0(
  "paperboy:::pb_deliver_paper.",
  gsub(".", "_", pb_available(), fixed = TRUE)
)

for (scrp in scrapers) {
  expect_error(
    do.call(eval(parse(text = scrp)), list(x = "")),
    "Wrong object passed to internal deliver function: character"
  )
}

test_that("Test parsers", {
  skip_if_offline()
  for (url in readLines("test-urls")) {
    expect_false({
      message(url)
      df <- pb_deliver(url, verbose = FALSE, timeout = 90L)
      any(c(is.na(df$datetime), df$author == "", nchar(df$headline) < 10, nchar(df$text) < 10))
    })
  }
})



