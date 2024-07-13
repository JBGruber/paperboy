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
    html_search(c(".atc-MetaTime", ".tsr-Base_ContentMetaTime", "Datum", ".entry-date"),
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
    rvest::html_elements("title") %>%
    rvest::html_text("content")

  # author
  author <- html %>%
    rvest::html_elements(".atc-MetaAuthorLink,.entry-author")  %>%
    rvest::html_text() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".atc-IntroText,.atc-TextParagraph,.single-entry-content") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}

pb_deliver_paper.blogs_faz_net <- pb_deliver_paper.faz_net
