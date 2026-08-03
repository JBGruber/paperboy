#' @export
pb_deliver_paper.lidovky_cz <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(iconv(x$content_raw, from = "windows-1250", to = "UTF-8"))

  # datetime
  datetime <- html %>%
    rvest::html_element("[property=\"article:published_time\"]") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element("[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  # author
  author <- html %>%
    rvest::html_element("[property=\"article:author\"]") %>%
    rvest::html_attr("content") %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements("[itemprop=\"articleBody\"] p,.opener") %>%
    rvest::html_text2() %>%
    trimws() %>%
    paste(collapse = "\n")

  paywall <- FALSE
  if (!nzchar(text)) {
    text <- html %>%
      rvest::html_element("[property=\"og:description\"]") %>%
      rvest::html_attr("content")
    text <- paste("[Paywall-Truncated]", text)
    headline <- paste("[Paywall-Truncated]", headline)
    paywall <- TRUE
  } else if (length(rvest::html_element(html, "#paywall"))) {
    text <- paste("[Paywall-Truncated]", text)
    paywall <- TRUE
  }

  cover_image_html <- html %>%
    rvest::html_element(".opener-foto img,.opener-flv-player img") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element(".opener-foto img,.opener-flv-player img") %>%
    rvest::html_attr("src") %>%
    paste0("https:", .)

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
