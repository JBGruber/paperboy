
pb_deliver_paper.edition_cnn_com <- function(x, verbose = NULL, ...) {

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
      rvest::html_elements("[name=\"pubdate\"],[name=\"parsely-pub-date\"],[property=\"article:published_time\"]") %>%
      rvest::html_attr("content") %>%
      lubridate::as_datetime()

    # headline
    headline <- html %>%
      rvest::html_elements(".pg-headline,.headline>h1,[id*=\"video-headline\"],.headline__text") %>%
      rvest::html_text2()

    # author
    author <- html %>%
      rvest::html_elements("[name=\"author\"]") %>%
      rvest::html_attr("content") %>%
      toString() %>%
      gsub("^By\\s", "", .)

    # text
    script <- html %>%
      rvest::html_elements("script")
    xml2::xml_remove(script)

    text <- html %>%
      rvest::html_elements("[class*=\"zn-body-text\"]") %>%
      #rvest::html_elements("") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")
    writeLines(as.character(text), "test2.html")

    if (nchar(text) == 0) {
      text <- html %>%
        rvest::html_elements("article,.article__main") %>%
        rvest::html_elements("p") %>%
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

pb_deliver_paper.us_cnn_com <- pb_deliver_paper.edition_cnn_com
