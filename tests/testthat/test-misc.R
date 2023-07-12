test_that("normalise_df works", {
  expect_equal(
    names(normalise_df(data.frame(test = TRUE))),
    c("url", "expanded_url", "domain", "status", "datetime", "author",
      "headline", "text", "misc")
  )
})

test_that("pb_available works", {
  expect_equal({
      out <- pb_available()
      c(class(out), length(out) > 10)
    },
    c("character", "TRUE")
  )
})

test_that("Test safe named list making", {
  expect_equal({
      text <- "hello world"
      author <- "Max Mustermann"
      headline <- "lorem ipsum"
      datetime <- character()

      paperboy:::s_n_list(
        text,
        author,
        headline,
        datetime
      )
    },
    tibble::tibble(text = "hello world",
                   author = "Max Mustermann",
                   headline = "lorem ipsum",
                   datetime = NA)
  )
  expect_equal({
      text <- "hello world"
      author <- c("Max Mustermann", "Erika Mustermann")
      headline <- "lorem ipsum"
      datetime <- character()

      paperboy:::s_n_list(
        text,
        author,
        headline,
        datetime
      )
    },
    tibble::tibble(text = "hello world",
                   author = list(c("Max Mustermann", "Erika Mustermann")),
                   headline = "lorem ipsum",
                   datetime = NA)
  )
})
