
pb_deliver_paper.www_forbes_com <- function(x, verbose = NULL, ...) {

  if (is.null(verbose)) verbose <- getOption("paperboy_verbose")

  if (!"tbl_df" %in% class(x))
    stop("Wrong object passed to internal deliver function: ", class(x))

  if (verbose) message("\t...", nrow(x), " articles from ", x$domain[1])

  pb <- make_pb(x)

  purrr::map_df(x$content_raw, function(cont) {

    if (verbose) pb$tick()

    html <- rvest::read_html(cont)

    # datetime
    datetime <- html %>%
      rvest::html_elements("[property=\"article:published\"]") %>%
      rvest::html_attr("content") %>%
      lubridate::as_datetime()

    # headline
    headline <- html %>%
      rvest::html_elements("[property=\"og:title\"]") %>%
      rvest::html_attr("content")

    # author
    author <- html %>%
      rvest::html_elements("[property=\"article:author\"]") %>%
      rvest::html_attr("content")

    if (length(author) > 1) author <- toString(author)

    # text
    text <- html %>%
      rvest::html_elements("p") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")

    list(
      datetime = len_check(datetime),
      author   = len_check(author),
      headline = len_check(headline),
      text     = len_check(text)
    )
  }) %>%
    cbind(x) %>%
    normalise_df() %>%
    return()
}
