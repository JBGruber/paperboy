#' Search raw html for attributes
#'
#' @param html raw html
#' @param selectors a vector of CSS selectors to include in search.
#' @param attributes attributes to extract. If NULL, returns text.
#' @param all if TRUE, all selectors are collected. Otherwise, only the first
#'   non-empty result is used.
#' @param n if multiple are found, how many to return
#'
#' @return a vector of max length n
#' @keywords internal
html_search <- function(html,
                        selectors,
                        attributes = NULL,
                        all = TRUE,
                        n = 1L) {

  if (all) {
    res <- rvest::html_elements(html, paste0(selectors, collapse = ","))
  } else {
    res <- NULL
    i <- 1L
    l <- length(selectors)
    while (length(res) < 1 & i < l) {
      res <- rvest::html_elements(html, selectors[i])
      i <- i + 1
    }
  }

  want_text <- "text" %in% attributes
  if (want_text) attributes <- setdiff(attributes, "text")

  out <- rvest::html_attrs(res) %>%
    unlist(recursive = FALSE) %>%
    subset(., names(.) %in%
             attributes) %>%
    unname()

  if (want_text) out <- c(out, rvest::html_text2(res))

  if (is.null(out)) {
    return(NA_character_)
  } else {
    return(utils::head(out, n))
  }
}
