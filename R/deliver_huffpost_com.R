pb_deliver_paper.www_huffpost_com <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

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
    rvest::html_element(".author-card__name,.wire-byline,.entry-wirepartner__byline") %>%
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


  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text,
    content_type
  )

}


# define aliases for pages using the same layout
pb_deliver_paper.huffingtonpost_com <-
  pb_deliver_paper.www_huffpost_com
