
pb_deliver_paper.nypost_com <- function(x, verbose = NULL, ...) {

  . <- NULL

  if (is.null(verbose)) verbose <- getOption("paperboy_verbose")

  class_test(x)

  if (verbose) message("\t...", nrow(x), " articles from ", x$domain[1])

  pb <- make_pb(x)

  purrr::map_df(x$content_raw, function(cont) {

    if (verbose) pb$tick()

    html <- rvest::read_html(cont)

    # datetime
    datetime <- html %>%
      rvest::html_elements("[property=\"article:published_time\"]") %>%
      rvest::html_attr("content") %>%
      lubridate::as_datetime()

    # headline
    headline <- html %>%
      rvest::html_elements("[property=\"og:title\"]") %>%
      rvest::html_attr("content")

    # author
    author <- html %>%
      rvest::html_elements(".byline")  %>%
      rvest::html_text2() %>%
      toString() %>%
      gsub("By ", "", ., fixed = TRUE)

    # text
    text <- html %>%
      rvest::html_elements("[class*=\"content\"]>p") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")

    s_n_list(
      datetime,
      author,
      headline,
      text
    )
  }) %>%
    cbind(x) %>%
    normalise_df() %>%
    return()
}
