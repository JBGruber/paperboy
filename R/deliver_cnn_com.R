
pb_deliver_paper.edition_cnn_com <- function(x, verbose = NULL, ...) {

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
      rvest::html_elements("[name=\"pubdate\"]") %>%
      rvest::html_attr("content") %>%
      lubridate::as_datetime()

    # headline
    headline <- html %>%
      rvest::html_elements(".pg-headline,.headline>h1,[id*=\"video-headline\"]") %>%
      rvest::html_text2()

    # author
    author <- html %>%
      rvest::html_elements("[name=\"author\"]") %>%
      rvest::html_attr("content") %>%
      toString()

    # text
    text <- html %>%
      rvest::html_elements("[class=\"zn-body__read-all\"]") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")

    if (nchar(text) == 0) {
      text <- html %>%
        rvest::html_elements("article") %>%
        rvest::html_text2() %>%
        paste(collapse = "\n")
    }

    # type
    content_type <- html %>%
      rvest::html_element("[property=\"og:title\"]") %>%
      rvest::html_attr("content") %>%
      toString() %>% {
        x <- .
        dplyr::case_when(
          grepl("Live", x, ignore.case = TRUE) ~ "live",
          grepl("Video", x, ignore.case = TRUE) ~ "video",
          TRUE ~ "article"
        )
      }


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
