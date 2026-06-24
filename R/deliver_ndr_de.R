#' @export
pb_deliver_paper.ndr_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_elements(html, 'script[type="application/ld+json"]') %>% rvest::html_text()

    article_df <- NULL
    video_df   <- NULL
    for (j in json_txt) {
        parsed <- tryCatch(jsonlite::fromJSON(j), error = function(e) NULL)
        if (is.null(parsed)) next
        type <- parsed[["@type"]]
        if (any(grepl("Article", type)) && is.null(article_df)) article_df <- parsed
        if (any(grepl("VideoObject|AudioObject", type)) && is.null(video_df)) video_df <- parsed
    }

    if (!is.null(article_df)) {
        # datetime
        datetime <- lubridate::as_datetime(article_df$datePublished) %>%
            lubridate::with_tz("Europe/Berlin")

        # headline
        headline <- article_df$headline

        # author
        author <- html %>%
            rvest::html_element('[name="author"]') %>%
            rvest::html_attr("content")
        if (is.na(author)) author <- toString(article_df$author$name)

        # text
        text <- article_df$articleBody
        if (is.null(text) || !nzchar(text)) {
            text <- html %>%
                rvest::html_elements("article.articlepage p") %>%
                rvest::html_text2() %>%
                paste(collapse = "\n")
        }
    } else if (!is.null(video_df)) {
        # datetime
        datetime <- lubridate::as_datetime(video_df$uploadDate)

        # headline
        headline <- video_df$name

        # author
        author <- toString(video_df$author$name)

        # text
        text <- html %>%
            rvest::html_elements("article.videopage p, article.audiopage p") %>%
            rvest::html_text2() %>%
            paste(collapse = "\n")
    } else {
        # datetime
        datetime <- html %>%
            rvest::html_element('[property="article:published_time"]') %>%
            rvest::html_attr("content") %>%
            lubridate::as_datetime()

        # headline
        headline <- html %>%
            rvest::html_element('[property="og:title"]') %>%
            rvest::html_attr("content")

        # author
        author <- html %>%
            rvest::html_element('[name="author"]') %>%
            rvest::html_attr("content") %>%
            toString()

        # text
        text <- html %>%
            rvest::html_elements("article.articlepage p") %>%
            rvest::html_text2() %>%
            paste(collapse = "\n")
    }

    s_n_list(
        datetime,
        author,
        headline,
        text
    )
}
