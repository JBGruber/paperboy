pb_deliver_paper.lidovky_cz <- function(x, verbose = NULL, pb, ...) {

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
    rvest::html_element("[itemprop=\"name headline\"]") %>%
    rvest::html_text2()

  # author
  author <- html %>%
    rvest::html_element("[itemprop=\"author\"] span")  %>%
    rvest::html_text2() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements("[itemprop=\"articleBody\"] p,.opener") %>%
    rvest::html_text2() %>%
    trimws() %>%
    paste(collapse = "\n")

  paywall <- FALSE
  if (length(rvest::html_element(html, "#paywall"))) {
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
