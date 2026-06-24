#' @export
pb_deliver_paper.srf_ch <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_df <- html %>%
        rvest::html_element("span#config__js") %>%
        rvest::html_attr("data-analytics-webtrekk-survey-gizmo-value-object") %>%
        jsonlite::fromJSON()

    datetime <- lubridate::as_datetime(json_df$params$content_publication_datetime)

    headline <- html %>%
        rvest::html_elements("h1 .article-title__text") %>%
        rvest::html_text()

    author <- "SRF"

    text <- html %>%
        rvest::html_elements(xpath = "//section[contains(@class,'articlepage__article-content')]//p[not(ancestor::*[contains(@class,'expandable-box')]) and not(ancestor::*[contains(@class,'related-item')])]") %>%
        rvest::html_text2() %>%
        paste(collapse = "\n")

    s_n_list(
        datetime,
        author,
        headline,
        text
    )
}
