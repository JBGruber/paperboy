
pb_deliver_paper.www_cbsnews_com <- function(x, verbose = NULL, ...) {

  . <- NULL

  if (is.null(verbose)) verbose <- getOption("paperboy_verbose")

  if (!"tbl_df" %in% class(x))
    stop("Wrong object passed to internal deliver function: ", class(x))

  if (verbose) message("\t...", nrow(x), " articles from ", x$domain[1])

  pb <- make_pb(x)

  purrr::map_df(seq_along(x$expanded_url), function(i) {

    content_type <- x$expanded_url[i] %>%
      gsub(".*cbsnews.com/", "", .) %>%
      gsub("/.*", "", .)

    cont <- x$content_raw[i]

    if (verbose) pb$tick()

    html <- rvest::read_html(cont)

    # datetime
    datetime <- html %>%
      rvest::html_elements("time") %>%
      rvest::html_attr("datetime") %>%
      lubridate::as_datetime()

    # headline
    headline <- html %>%
      rvest::html_elements("[property=\"og:title\"]") %>%
      rvest::html_attr("content")

    # author
    author <- html %>%
      rvest::html_element("[class*=\"content__meta--byline\"]") %>%
      rvest::html_text() %>%
      gsub("By\\b\\s+|\n", "", .) %>%
      trimws()

    # text
    text <- html %>%
      rvest::html_elements(".content__body") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")

    s_n_list(
      datetime,
      author,
      headline,
      text,
      content_type
    )
  }) %>%
    cbind(x) %>%
    normalise_df() %>%
    return()
}
