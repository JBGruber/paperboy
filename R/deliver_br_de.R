#' @export
pb_deliver_paper.br_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    datetime <- html %>%
        rvest::html_element("time") %>%
        rvest::html_attr("datetime") %>%
        lubridate::as_datetime()

    headline <- html %>%
        rvest::html_element(".heading1") %>%
        rvest::html_text2()

    author <- html %>%
        rvest::html_element(".ArticleModuleTeaser_authorName__Q7ctt") %>%
        rvest::html_text2() %>%
        toString()
    text <- html %>%
        rvest::html_element(".RichText_richText__wS9Rz.body3") %>%
        rvest::html_elements("p, h2") %>%
        rvest::html_text2() %>%
        paste(collapse = "\n")
    s_n_list(
        datetime,
        author,
        headline,
        text
    )
}
