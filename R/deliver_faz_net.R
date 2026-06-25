#' @export
pb_deliver_paper.faz_net <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  if (basename(x$expanded_url) == x$domain) {

    return(list(
      datetime  = NA,
      author    = NA,
      headline  = NA,
      text      = NA
    ))

  }

  # datetime
  datetime <- html %>%
    html_search(c("time", ".atc-MetaTime", ".tsr-Base_ContentMetaTime", "Datum", ".entry-date"),
                c("datetime", "text")) %>%
    lubridate::as_datetime()

  if (length(datetime) < 1) {

    # should be moved somewhere else
    monate <- c("Januar", "Februar", "M\U00E4rz", "April", "Mai",
                "Juni", "Juli", "August", "September", "Oktober",
                "November", "Dezember")
    replacement <- paste0(seq_along(monate), ".")

    datetime <- html %>%
      rvest::html_elements(".Datum,.entry-date") %>%
      rvest::html_text() %>%
      gsub("[[:space:]]", "", .) %>%
      replace_all(monate, replacement) %>%
      strptime(format = "%d.%m.%Y") %>%
      utils::head(1L)
  }

  # headline
  headline <- html %>%
    rvest::html_element('[property="og:title"]') %>%
    rvest::html_attr("content")

  # author
  author <- tryCatch({
    jsons <- html %>%
      rvest::html_elements('script[type="application/ld+json"]') %>%
      rvest::html_text() %>%
      lapply(jsonlite::fromJSON)
    art <- Filter(function(x) identical(x[["@type"]], "NewsArticle"), jsons)[[1]]
    paste(art$author$name, collapse = ", ")
  }, error = function(e) NA_character_) %>%
    toString()

  # text
  text <- tryCatch({
    jsons <- html %>%
      rvest::html_elements('script[type="application/ld+json"]') %>%
      rvest::html_text() %>%
      lapply(jsonlite::fromJSON)
    art <- Filter(function(x) identical(x[["@type"]], "NewsArticle"), jsons)[[1]]
    body <- art$articleBody
    if (is.null(body) || !nzchar(body)) stop("no articleBody")
    gsub("&nbsp;", " ", body, fixed = TRUE)
  }, error = function(e) {
    html %>%
      rvest::html_elements("p") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")
  })

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}

pb_deliver_paper.blogs_faz_net <- pb_deliver_paper.faz_net
