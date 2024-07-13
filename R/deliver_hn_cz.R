#' @export
pb_deliver_paper.hn_cz <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(charToRaw(enc2utf8(x$content_raw)))

  # datetime
  datetime <- html %>%
    rvest::html_element("[property=\"article:published_time\"]") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element("title") %>%
    rvest::html_text2()

  # author
  author <- html %>%
    rvest::html_elements("[name=\"author\"]")  %>%
    rvest::html_attr("content") %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".article-content p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  paywall <- FALSE
  if (length(rvest::html_element(html, ".paywall"))) {
    text <- paste("[Paywall-Truncated]", text)
    paywall <- TRUE
  }

  cover_image_html <- html %>%
    rvest::html_element(".article-image-wrapper img") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element(".article-image-wrapper img") %>%
    rvest::html_attr("src")

  s_n_list(
    datetime,
    author,
    headline,
    text,
    paywall,
    cover_image_url,
    cover_image_html
  )

}
