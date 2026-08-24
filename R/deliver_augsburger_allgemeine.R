#' @export
pb_deliver_paper.augsburger_allgemeine_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_ld <- html %>%
      rvest::html_element('script[type="application/ld+json"]') %>%
      rvest::html_text() %>%
      jsonlite::fromJSON()

    # datetime
    datetime <- purrr::pluck(json_ld, "datePublished", .default = NA_character_) %>%
      lubridate::as_datetime()

    # headline
    headline <- purrr::pluck(json_ld, "headline", .default = NA_character_)

    # author
    author_raw <- purrr::pluck(json_ld, "author", .default = NULL)
    author <- if (is.data.frame(author_raw[[1]])) {
      paste(author_raw[[1]]$name, collapse = ", ")
    } else {
      purrr::pluck(author_raw, "name", .default = NA_character_)
    }

    # text
    text <- html %>%
      rvest::html_elements(".typo-article-teaser-Recife, .typo-article-teaser, .article-body-paid-content, .typo-subhead, p.text-xs, #article-body-paid-content p") %>%
      rvest::html_text2() %>%
      trimws() %>%
      unique() %>%
      paste(collapse = "\n")

    # date and time URL was accessed
    accessed <- Sys.time()

    s_n_list(
        datetime,
        author,
        headline,
        text,
        accessed
    )
}
