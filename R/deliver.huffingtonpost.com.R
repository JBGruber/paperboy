#' @rdname deliver
#' @export
deliver.www_huffpost_com <- function(url, verbose = TRUE, ...) {

  . <- NULL

  if (!"tbl_df" %in% class(url))
    stop("Wrong object passed to internal deliver function: ", class(url))

  if (verbose) message("\t...", nrow(url), " articles from huffpost")

  pb <- make_pb(url)

  purrr::map_df(url$expanded_url, function(u) {

    if (verbose) pb$tick()

    html <- rvest::read_html(u)

    # datetime
    datetime <- html %>%
      rvest::html_elements("[property=\"article:published_time\"]") %>%
      rvest::html_attr("content") %>%
      lubridate::as_datetime()

    # headline
    headline <- html %>%
      rvest::html_elements(".headline__title,.headline__subtitle,.js-headline,.headline") %>%
      rvest::html_text() %>%
      paste0(collapse = ". ")

    # author
    author <- html %>%
      rvest::html_element(".author-card__name,.wire-byline") %>%
      rvest::html_text() %>%
      gsub("^By\\b\\s+", "", .)

    # text
    text <- html %>%
      rvest::html_elements("p,.entry-video__content__description") %>%
      rvest::html_text() %>%
      paste(collapse = "\n\n")

    type <- html %>%
      rvest::html_elements("article") %>%
      rvest::html_attrs() %>%
      .[[1]]

    content_type <- dplyr::case_when(
      "article" %in% type ~ "article",
      "entry-video" %in% type ~ "video",
      TRUE ~ "unknown"
    )

    tibble::tibble(
      datetime,
      author,
      headline,
      text,
      content_type
    )
  }) %>%
    cbind(url) %>%
    normalise_df() %>%
    return()
}

#' @export
#' @rdname deliver
deliver.www_huffingtonpost_co_uk <- deliver.www_huffpost_com

