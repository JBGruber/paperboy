
pb_deliver_paper.www_foxbusiness_com <- function(x, verbose = NULL, ...) {

  . <- NULL

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
      rvest::html_elements("[name=\"dcterms.created\"]") %>%
      rvest::html_attr("content") %>%
      lubridate::as_datetime()

    # headline
    headline <- html %>%
      rvest::html_elements("[property=\"og:title\"]") %>%
      rvest::html_attr("content")

    # author
    author <- html %>%
      rvest::html_elements(".author") %>%
      rvest::html_text() %>%
      trimws() %>%
      toString()

    # text
    text <- html %>%
      rvest::html_elements(".article-content") %>%
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


pb_deliver_paper.www_foxnews_com <- pb_deliver_paper.www_foxbusiness_com
