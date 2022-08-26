
#' @keywords internal
pb_deliver_paper.www_faz_net <- function(x, verbose = NULL, ...) {

  . <- NULL

  if (is.null(verbose)) verbose <- getOption("paperboy_verbose")

  class_test(x)

  if (verbose) message("\t...", nrow(x), " articles from ", x$domain[1])

  pb <- make_pb(x)

  purrr::map_df(seq_along(x$url), function(i) {
    if (basename(x$expanded_url[i]) == x$domain[i]) {

      if (verbose) pb$tick()

      tibble::tibble(
        datetime  = NA,
        author    = NA,
        headline  = NA,
        text      = NA
      )

    } else {

      cont <- x$content_raw[i]
      if (verbose) pb$tick()

      html <- rvest::read_html(cont)

      # datetime
      datetime <- html %>%
        rvest::html_elements(".atc-MetaTime") %>%
        rvest::html_attr("datetime") %>%
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
          strptime(format = "%d.%m.%Y")
      }

      if (length(datetime) > 1) {
        datetime <- datetime[1]
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
        rvest::html_elements("[class=\"atc-IntroText\"],[class=\"atc-TextParagraph\"]") %>%
        rvest::html_text2() %>%
        paste(collapse = "\n")

      s_n_list(
        datetime,
        author,
        headline,
        text
      )
    }
  }) %>%
    cbind(x) %>%
    normalise_df() %>%
    return()
}

pb_deliver_paper.blogs_faz_net <- pb_deliver_paper.www_faz_net

