#' @export
pb_deliver_paper.theguardian_com <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_elements("[property=\"article:published_time\"]") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_elements("[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  # author
  author <- html %>%
    rvest::html_elements("script[type='application/ld+json']") %>%
    rvest::html_text() %>%
    jsonlite::fromJSON() %>%
    purrr::pluck("author", 1, "name")
  
  is_letters <- html %>%
    rvest::html_element("meta[property='og:description']") %>%
    rvest::html_attr("content") %>%
    grepl("^Letter", .)
  
  if (author == "Guardian staff reporter" & isFALSE(is_letters)) {
    author <- html %>%
      rvest::html_element("meta[property='article:author']") %>%
      rvest::html_attr("content")
  } else if (author == "Guardian staff reporter" & isTRUE(is_letters)) {
    author <- html %>%
      rvest::html_element("div[data-gu-name='standfirst'] strong") %>%
      rvest::html_text2()
  }
  
  author <- trimws(author) %>% 
    paste(collapse = ", ")

  # text
  text <- html %>%
    rvest::html_elements("#maincontent p,.content__standfirst p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_html <- html %>%
    rvest::html_element("#img-1 img")

  cover_image_url <- cover_image_html %>%
    rvest::html_attr("src")

  if (length(cover_image_html) == 0L) {
    cover_image_html <- html %>%
      rvest::html_element("[name=\"thumbnail\"]")

    cover_image_url <- cover_image_html %>%
      rvest::html_attr("content")
  }

  cover_image_html <- as.character(cover_image_html)

  # not very elegant, but type does not appear anywhere else, but the URL
  type <- adaR::ada_get_pathname(x$expanded_url) %>%
    strsplit("/") %>%
    purrr::pluck(1, 3, .default = NA_character_)
  type <- ifelse(grepl("^\\d+$", type), "news", type)
  
  # date and time URL was accessed
  accessed <- Sys.time()

  s_n_list(
    datetime,
    author,
    headline,
    text,
    type,
    cover_image_url,
    cover_image_html,
    accessed
  )
}

pb_deliver_paper.theguardian_com <- pb_deliver_paper.theguardian_com
