#' Search raw html for attributes
#'
#' @param html raw html
#' @param selectors a vector of CSS selectors to include in search.
#' @param attributes attributes to extract. If NULL, returns text.
#' @param n if multiple are found, how many to return
#'
#' @return a vector of max length n
#' @keywords internal
html_search <- function(html, selectors, attributes = NULL, n = 1L) {

  . <- NULL

  res <- rvest::html_elements(html, paste0(selectors, collapse = ","))

  want_text <- "text" %in% attributes
  if (want_text) attributes <- setdiff(attributes, "text")

  out <- rvest::html_attrs(res) %>%
    unlist(recursive = FALSE) %>%
    subset(., names(.) %in%
             attributes) %>%
    unname()

  if (want_text) out <- c(out, rvest::html_text2(res))

  utils::head(out, n)
}
