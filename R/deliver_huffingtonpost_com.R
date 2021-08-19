
pb_deliver_paper.www_huffpost_com <- function(x, verbose = NULL, ...) {

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
      rvest::html_text2() %>%
      paste(collapse = "\n")

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
    cbind(x) %>%
    normalise_df() %>%
    return()
}


pb_deliver_paper.www_huffingtonpost_co_uk <- pb_deliver_paper.www_huffpost_com

