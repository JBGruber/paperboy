
pb_deliver_paper.www_newsweek_com <- function(x, verbose = NULL, ...) {

  . <- NULL

  if (is.null(verbose)) verbose <- getOption("paperboy_verbose")

  if (!"tbl_df" %in% class(x))
    stop("Wrong object passed to internal deliver function: ", class(x))

  if (verbose) message("\t...", nrow(x), " articles from huffpost")

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
      rvest::html_elements("[property =\"og:title\"]") %>%
      rvest::html_attr("content")

    # author
    author <- html %>%
      rvest::html_elements("[class=\"author\"]") %>%
      rvest::html_text2()

    # text
    text <- html %>%
      rvest::html_elements(".article-body") %>%
      rvest::html_elements("p") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")

    tibble::tibble(
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