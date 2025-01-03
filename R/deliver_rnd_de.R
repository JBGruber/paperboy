#' @export
pb_deliver_paper.rnd_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_elements(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text()
    if (isTRUE(is.na(json_txt)) || length(json_txt) == 0) {
        return(s_n_list())
    } else {
        if (length(json_txt) <= 2) {
            return(s_n_list())
        }
        json_df <- jsonlite::fromJSON(json_txt[3])

        datetime <- lubridate::as_datetime(json_df$datePublished)
        headline <- json_df$headline
        author <- toString(json_df$author$name)
        text <- html %>%
            rvest::html_elements(".Textstyled__Text-sc-1cqv9mi-0, .Headlinestyled__Headline-sc-mamptc-0") %>%
            rvest::html_text2()

        more_items <- html %>% # delete content in lists of related items
            rvest::html_elements("div[data-is-element-rendered='true']") %>%
            rvest::html_elements(".Textstyled__Text-sc-1cqv9mi-0, .Headlinestyled__Headline-sc-mamptc-0") %>%
            rvest::html_text2()
        text <- text[!text %in% more_items] %>% paste(collapse = "\n")
        s_n_list(
            datetime,
            author,
            headline,
            text
        )
    }
}
