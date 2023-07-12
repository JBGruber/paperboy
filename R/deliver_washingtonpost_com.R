pb_deliver_paper.www_washingtonpost_com <- function(x, verbose, pb, ...) {

  pb_tick(x, verbose, pb)

  # sometimes redirects to home page
  if (basename(x$expanded_url) == x$domain) {

    return(tibble::tibble(
      datetime  = NA,
      author    = NA,
      headline  = NA,
      text      = NA
    ))

  } else {
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    # datetime
    suppressWarnings(
      datetime <- html %>%
        html_search(selectors = c(
          "[property=\"article:published_time\"]",
          "[itemprop*=\"datePublished\"]",
          "[name=\"ga-publishDate\"]"
        ), attributes = "content") %>%
        lubridate::as_datetime()
    )

    if (length(datetime) < 1) {
      datetime <- html %>%
        rvest::html_elements("[class*=\"date\"]") %>%
        rvest::html_text() %>%
        strptime(format = "%B %d, %Y | %I:%M %p")
    }

    if (!isFALSE(is.na(datetime))) {
      datetime <- html %>%
        rvest::html_elements("[slot=\"data\"],script") %>%
        rvest::html_text() %>%
        extract("\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z") %>%
        unique() %>%
        lubridate::as_datetime() %>%
        utils::head(1L)
    }

    # headline
    headline <- html %>%
      rvest::html_elements("[property=\"og:title\"]") %>%
      rvest::html_attr("content")

    # author
    author <- html %>%
      rvest::html_elements("[data-qa=\"author-name\"],[class*=\"author-name \"],.video-info")  %>%
      rvest::html_text2() %>%
      toString()

    # text
    text <- html %>%
      rvest::html_elements(".article-body>p,p") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")

    # the helper function safely creates a named list from objects
    return(s_n_list(
      datetime,
      author,
      headline,
      text
    ))
  }
}
