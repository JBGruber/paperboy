
pb_deliver_paper.www_telegraph_co_uk <- function(x, verbose = NULL, ...) {

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
      rvest::html_element("[itemprop=\"datePublished\"]") %>%
      {
        out <- rvest::html_attr(., "content")
        if (is.na(out)) {
          out <- rvest::html_attr(., "datetime")
        }
        out
      } %>%
      as.POSIXct(format = "%Y-%m-%dT%H:%M%z")

    # headline
    headline <- html %>%
      rvest::html_elements("[property=\"og:title\"]") %>%
      rvest::html_attr("content")

    # author
    author <- html %>%
      rvest::html_elements("[class*=\"byline__author\"]") %>%
      rvest::html_attr("content") %>%
      toString() %>%
      gsub("^By\\s", "", .)

    # text
    text <- html %>%
      rvest::html_elements("[class*=\"article-body-text\"]") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")

    # type
    content_type <- html %>%
      rvest::html_element("[property=\"og:type\"]") %>%
      rvest::html_attr("content")

    tibble::tibble(
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
