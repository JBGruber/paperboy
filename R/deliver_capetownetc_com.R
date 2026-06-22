#' @export
pb_deliver_paper.capetownetc_com <- function(x, verbose = NULL, pb, ...) {
  pb_tick(x, verbose, pb)

  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_element('[property="article:published_time"]') %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element('[property="og:title"]') %>%
    rvest::html_attr("content")

  # author
  author <- html %>%
    rvest::html_element("span.author.vcard") %>%
    rvest::html_text2() %>%
    toString()

  # text
  xml2::xml_remove(rvest::html_elements(html, "div.entry-content iframe"))
  paragraphs <- html %>%
    rvest::html_elements("div.entry-content > p") %>%
    rvest::html_text2() %>%
    trimws()
  boilerplate <- "^Be the first to know|^Also read:|^Picture:"
  text <- paragraphs[paragraphs != "" & !grepl(boilerplate, paragraphs, ignore.case = TRUE)] %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )
}
