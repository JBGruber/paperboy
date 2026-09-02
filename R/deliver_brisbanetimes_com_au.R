#' @export
pb_deliver_paper.brisbanetimes_com_au <- function(x, verbose = NULL, pb, ...) {
  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html_search(
    html,
    c("[property=\"article:published_time\"]", "time[datetime]"),
    c("content", "datetime")
  ) %>%
    lubridate::as_datetime()

  # headline
  headline <- html_search(
    html,
    c(
      "[property=\"og:title\"]",
      "[data-testid=\"headline\"]",
      "[name=\"title\"]"
    ),
    c("content", "text"),
    all = FALSE
  )

  # author
  author <- html_search(
    html,
    c(
      "[name=\"author\"]",
      "[property=\"article:author\"]",
      # fallback
      "[property='og:site_name']"
    ),
    "content"
  ) %>%
    toString()

  # text
  paras <- html %>%
    rvest::html_elements("div.article p, article p")
  keep <- vapply(
    paras,
    function(p) {
      txt <- rvest::html_text2(p)
      if (nchar(trimws(txt)) == 0) {
        return(FALSE)
      }
      if (length(rvest::html_elements(p, "time")) > 0) {
        return(FALSE)
      }
      if (length(rvest::html_elements(p, "a[href*=newsletter]")) > 0) {
        return(FALSE)
      }
      a <- xml2::xml_parent(p)
      while (
        !is.null(a) && !is.na(xml2::xml_name(a)) && xml2::xml_name(a) != "html"
      ) {
        tag <- xml2::xml_name(a)
        cls <- rvest::html_attr(a, "class")
        testid <- rvest::html_attr(a, "data-testid")
        role <- rvest::html_attr(a, "role")
        if (tag %in% c("header", "aside", "section", "footer")) {
          return(FALSE)
        }
        if (!is.na(cls) && grepl("(^| )(noPrint|container)( |$)", cls)) {
          return(FALSE)
        }
        if (!is.na(testid) && testid == "article-footer") {
          return(FALSE)
        }
        if (!is.na(role) && role == "tooltip") {
          return(FALSE)
        }
        a <- xml2::xml_parent(a)
      }
      TRUE
    },
    logical(1)
  )
  text <- paras[keep] %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")
  if (!nzchar(text)) {
    text <- html %>%
      rvest::html_element("[property='og:description']") %>%
      rvest::html_attr("content")
  }

  s_n_list(
    datetime,
    author,
    headline,
    text
  )
}
