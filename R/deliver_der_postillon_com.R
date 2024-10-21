#' @export
pb_deliver_paper.der_postillon_com <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_elements(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text()
    if (isTRUE(is.na(json_txt)) || length(json_txt) == 0) {
        return(s_n_list())
    } else {
        json_df <- jsonlite::fromJSON(json_txt[1])

        datetime <- lubridate::as_datetime(json_df$datePublished)
        headline <- json_df$headline
        author <- toString(json_df$author$name)
        text <- html %>%
            rvest::html_nodes(".post-body p") %>%
            rvest::html_text2() %>%
            paste(collapse = "\n")

        # author abbr can be found at the end of the article
        if (author == "Der Postillon") {
            author_tmp <- html %>%
                rvest::html_node("div[id='post-body'] span[style='font-size: x-small;']") %>%
                rvest::html_text() %>%
                sub("; Erstver.*$", "", .)
            if (author_tmp != "") {
                author <- author_tmp
            }
        }
        s_n_list(
            datetime,
            author,
            headline,
            text
        )
    }
}
