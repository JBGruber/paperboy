
pb_deliver_paper.www_cnet_com <- function(x, verbose = NULL, ...) {

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
      rvest::html_element("time") %>%
      rvest::html_attr("datetime") %>%
      lubridate::as_datetime()

    if (is.na(datetime)) {
      datetime <- html %>%
        rvest::html_element("time") %>%
        rvest::html_text2() %>%
        lubridate::mdy() %>%
        as.POSIXct()
    }

    # headline
    headline <- html %>%
      rvest::html_elements("[property=\"og:title\"]") %>%
      rvest::html_attr("content")

    # author
    author <- html %>%
      rvest::html_elements("[class*=\"c-globalAuthor_link\"]")  %>%
      rvest::html_text2() %>%
      toString()

    # text
    text <- html %>%
      rvest::html_elements("[class*=\"c-CmsContent\"]") %>%
      rvest::html_elements("p") %>%
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