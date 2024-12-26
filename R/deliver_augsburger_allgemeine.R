#' @export
pb_deliver_paper.augsburger_allgemeine_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)


    datetime <- html %>%
        rvest::html_element("time") %>%
        rvest::html_attr("datetime") %>%
        lubridate::as_datetime()
    headline <- html %>%
        rvest::html_element("h2.typo-teaserheadline-SoleXL, h2.typo-articleheadline-Recife") %>%
        rvest::html_text()
    author <- html %>%
        rvest::html_elements("a.typo-author-link") %>%
        rvest::html_text2() %>%
        toString()
    text <- html %>%
        rvest::html_elements(".typo-article-teaser-Recife, .typo-article-teaser, .article-body-paid-content, .typo-subhead, p.text-xs") %>%
        rvest::html_text2() %>%
        unique() %>% # teaser might be duplicated
        paste(collapse = "\n")

    s_n_list(
        datetime,
        author,
        headline,
        text
    )
}
