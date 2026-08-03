#' @export
pb_deliver_paper.mopo_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    # datetime
    datetime <- html %>%
        html_search(c("[property=\"article:published_time\"]", "time[datetime]"),
                    c("content", "datetime"), all = FALSE) %>%
        lubridate::as_datetime()

    # author
    author <- html %>%
        html_search(c("[property=\"article:author\"]", "span.lab-hidden-byline-name"),
                    c("content", "text"), all = FALSE) %>%
        toString()

    # headline
    headline <- html %>%
        html_search(c("h1.mainTitle", "h1.headline", "[property=\"og:title\"]"),
                    c("text", "content"), all = FALSE)

    # text
    text <- html %>%
        rvest::html_elements("div.bodytext p, div.bodytext h2, div.entry-content p, div.entry-content h2") %>%
        rvest::html_text2() %>%
        paste(collapse = "\n")

    s_n_list(
        datetime,
        author,
        headline,
        text
    )
}
# rss feed includes non-article pages (puzzles, marketplace, shop) that cannot be parsed
# rss feed also includes "Liveticker" entries whose URLs render a generic live-blog
# homepage instead of the specific article, so their fields cannot be reliably extracted
