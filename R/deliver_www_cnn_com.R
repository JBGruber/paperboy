pb_deliver_paper.www_cnn_com <- function(x, verbose = NULL, pb,...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  # datetime
  datetime <- html %>%
    rvest::html_elements("[name=\"pubdate\"],[name=\"parsely-pub-date\"],[property=\"article:published_time\"]") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime() %>%
    utils::head(1L)

  # headline
  headline <- html %>%
    rvest::html_elements(".pg-headline,.headline>h1,[id*=\"video-headline\"],.headline__text,.PageHead__title,.Article__title") %>%
    rvest::html_text2()

  # author
  author <- html %>%
    html_search(c(".Authors__writer", "[name=\"author\"]", ".byline__names"),
                c("text", "content")) %>%
    toString() %>%
    gsub("^By\\s", "", .)

  # text
  text <- html %>%
    rvest::html_elements(".zn-body-text,article,.article__main,BasicArticle__paragraph,[class^=\"Paragraph\"]") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

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

}

pb_deliver_paper.us_cnn_com <-
  pb_deliver_paper.edition_cnn_com <-
  pb_deliver_paper.www_cnn_com
