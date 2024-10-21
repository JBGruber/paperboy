#' @export
pb_deliver_paper.zdf_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_elements(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text()
    if (isTRUE(is.na(json_txt)) || length(json_txt) == 0) {
        return(s_n_list())
    } else {
        if (length(json_txt) != 1) {
            json_txt <- json_txt[2]
        }
        json_df <- jsonlite::fromJSON(gsub("\r\n", " ", json_txt))
        if (json_df$`@type` != "VideoObject" && json_df$`@type` != "BreadcrumbList" && json_df$`@type` != "WebSite") {
            datetime <- lubridate::as_datetime(json_df$datePublished)
            headline <- json_df$headline
            author <- toString(json_df$author$name)
            text <- html %>%
                rvest::html_nodes(".r1nj4qn5") %>%
                rvest::html_text2() %>%
                paste(collapse = "\n")
        } else if (json_df$`@type` == "VideoObject") {
            datetime <- lubridate::as_datetime(json_df$uploadDate)
            headline <- json_df$name
            author <- toString(json_df$publisher$name)
            text <- json_df$description
        } else {
            datetime <- html %>%
                rvest::html_node("time") %>%
                rvest::html_attr("datetime") %>%
                lubridate::as_datetime()
            headline <- html %>%
                rvest::html_node("main h2") %>%
                rvest::html_text2()
            author <- ""
            text <- ""
        }
        s_n_list(
            datetime,
            author,
            headline,
            text
        )
    }
}
