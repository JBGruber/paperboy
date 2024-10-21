#' @export
pb_deliver_paper.rtl_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_elements(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text()
    if (isTRUE(is.na(json_txt)) || length(json_txt) == 0) {
        return(s_n_list())
    } else {
        json_df <- jsonlite::fromJSON(json_txt[2])
        if (json_df$`@type` != "VideoObject") { # NewsArticle
            datetime <- lubridate::as_datetime(json_df$datePublished)
            headline <- json_df$headline
            author <- toString(json_df$author$name)
            text <- html %>%
                rvest::html_elements(".article-body .LeadText_lead__rfwFU,.article-body .AnnotatedMarkup_paragraph__IUT9l") %>%
                rvest::html_text2() %>%
                paste(collapse = "\n")
        } else {
            datetime <- lubridate::as_datetime(json_df$uploadDate)
            headline <- json_df$name
            author <- ""
            text <- json_df$transcript # for video objects, use transcript as text
        }

        s_n_list(
            datetime,
            author,
            headline,
            text,
            json_df # dumping the whole json data of an article
        )
    }
}
