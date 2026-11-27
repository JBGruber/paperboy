#' @export
pb_deliver_paper.irishtimes_com <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  data <- html %>%
    rvest::html_elements("[type=\"application/ld+json\"]") %>%
    rvest::html_text2() %>%
    lapply(jsonlite::fromJSON)
  
  # date and time URL was accessed
  accessed <- Sys.time()

  # usually there are more than one,
  if (length(data) > 1L) {
    tp <- purrr::map_chr(data, function(x) {
      graph <- purrr::pluck(x, "@graph", .default = NULL)
      
      if (is.null(graph)) return(NA_character_)
      
      # graph ist ein data.frame, also mit [ filtern
      types <- graph[["@type"]]
      paste(types, collapse = ", ")  # z.B. "WebSite, Organization"
    })
    
    idx <- grep("NewsArticle", tp)
    
    if (length(idx) != 0) {
      
      data <- purrr::pluck(data, idx[[1]], "@graph", .default = NA)
    }
  }

  if (!isTRUE(is.na(data))) {

    # datetime
    datetime <- data$datePublished[1] %>%
      lubridate::as_datetime()

    # headline
    headline <- data$headline[1]

    # author
    author <- data$author[[1]]$name %>%
      toString()

    # text
    text <- html %>%
      rvest::html_elements("article p") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")

    cover_image_url <- purrr::pluck(data$image, 1, .default = NA)[1]

    type <- data$`@type`[1]

    s_n_list(
      datetime,
      author,
      headline,
      text,
      type,
      cover_image_url,
      accessed
    )
  } else {
    s_n_list(accessed)
  }

}
