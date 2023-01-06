pb_deliver_paper.www_washingtonpost_com <- function(x, verbose, pb, ...) {

  if (verbose) pb$tick(tokens = list(what = x$domain[1]))

  # sometimes redirects to home page
  if (basename(x$expanded_url[i]) != x$domain[i]) {

    if (verbose) pb$tick()

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
    datetime <- html %>%
      html_search(selectors = c(
        "[property=\"article:published_time\"]",
        "[itemprop*=\"datePublished\"]",
        "[name=\"ga-publishDate\"]"
      ), attributes = "content",) %>%
      lubridate::as_datetime()

    if (length(datetime) < 1) {
      datetime <- html %>%
        rvest::html_elements("[class*=\"date\"]") %>%
        rvest::html_text() %>%
        strptime(format = "%B %d, %Y | %I:%M %p")
    }

    # author
    author <- html %>%
      rvest::html_elements(".authors,[itemprop=\"author\"],.gnt_ar_by_a,.gnt_ar_by")  %>%
      rvest::html_text2() %>%
      unique() %>%
      toString()

    if (!isFALSE(is.na(datetime))) {
      datetime <- html %>%
        rvest::html_elements("[slot=\"data\"],script") %>%
        rvest::html_text() %>%
        extract("\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z") %>%
        unique() %>%
        lubridate::as_datetime() |>
        head(1L)
    }

    # headline
    headline <- html %>%
      rvest::html_elements("[property=\"og:title\"]") %>%
      rvest::html_attr("content")

    # author
    author <- html %>%
      rvest::html_elements("[data-qa=\"author-name\"],[class*=\"author-name \"]")  %>%
      rvest::html_text2() %>%
      toString()

    # text
    text_temp <- html %>%
      rvest::html_elements("[class=\"article-body\"]")

    if (length(text_temp) > 0) {
      text <- text_temp %>%
        rvest::html_elements("p") %>%
        rvest::html_text2() %>%
        paste(collapse = "\n")
    } else {
      text <- html %>%
        rvest::html_elements("p") %>%
        rvest::html_text2() %>%
        paste(collapse = "\n")
    }

    # the helper function safely creates a named list from objects
    return(s_n_list(
      datetime,
      author,
      headline,
      text
    ))
  }
}
