pb_deliver_paper.ad_nl <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  title <- html %>%
    rvest::html_element("title") %>%
    rvest::html_text2()

  if (title != "DPG Media Privacy Gate") {
    # datetime
    datetime <- html %>%
      rvest::html_element("[itemprop=\"datePublished\"]") %>%
      rvest::html_attr("content") %>%
      lubridate::as_datetime()

    # headline
    headline <- html %>%
      rvest::html_element(".article__title") %>%
      rvest::html_text2()

    # author
    author <- html %>%
      rvest::html_element("[name=\"author\"]")  %>%
      rvest::html_attr("content") %>%
      toString()

    # text
    text <- html %>%
      rvest::html_elements(".article__wrapper .article__paragraph,.article__intro") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")

    cover_image_html <- html %>%
      rvest::html_element(".article__image img") %>%
      as.character()

    cover_image_url <- html %>%
      rvest::html_element(".article__image img") %>%
      rvest::html_attr("src")

    # the helper function safely creates a named list from objects
    s_n_list(
      datetime,
      author,
      headline,
      text,
      cover_image_url,
      cover_image_html
    )

  } else {
    warn_once(x$domain)
    if (is.null(inform_now_env$block)) {
      cli::cli_alert_warning("Some articles are not present as they were blocked by a privacy gate")
    }
    inform_now_env$block <- TRUE
    headline <- "Blocked by Privacy Gate"
    # the helper function safely creates a named list from objects
    s_n_list(
      headline
    )
  }



}
