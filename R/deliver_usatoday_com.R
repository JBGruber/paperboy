#' internal function to deliver specific newspapers
#' @param x A data.frame returned by  \link{pb_collect} with an additional class
#'   indicating the domain of all links.
#' @inheritParams pb_deliver
#' @keywords internal
pb_deliver_paper.usatoday_com <- function(x, verbose = NULL, ...) {

  # If verbose is not explicitly defined, use package default stored in options.
  if (is.null(verbose)) verbose <- getOption("paperboy_verbose")

  class_test(x)

  if (verbose) message("\t...", nrow(x), " articles from ", x$domain[1])

  # helper function to make progress bar
  pb <- make_pb(x)

  # iterate over all URLs and normalise data.frame
  purrr::map_df(x$content_raw, parse_usatoday_com, verbose, pb) %>%
    cbind(x) %>%
    normalise_df() %>%
    return()

}

# define parsing function to iterate over the URLs
parse_usatoday_com <- function(html, verbose, pb) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(html)
  if (verbose) pb$tick()

  # datetime
  datetime <- html %>%
    html_search(selectors = c(
      "lit-timestamp",
      "story-timestamp",
      "[property=\"article:published_time\"]"
    ), attributes = c("content", "publishdate")) %>%
    lubridate::as_datetime()

  # author
  author <- html %>%
    rvest::html_elements(".authors,[itemprop=\"author\"]")  %>%
    rvest::html_text2() %>%
    unique() %>%
    toString()

  if (is.na(datetime)) {
    datetime <- html %>%
      rvest::html_elements("[slot=\"data\"]") %>%
      rvest::html_text() %>%
      extract("\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z") %>%
      lubridate::as_datetime()
  }

  # headline
  headline <- html %>%
    rvest::html_elements("[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  # text
  text <- html %>%
    rvest::html_elements("article>p,.articleBody>p,.exclude-from-newsgate,.detail-text") %>%
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

# define aliases for pages using the same layout
pb_deliver_paper.eu_usatoday_com <- pb_deliver_paper.usatoday_com
pb_deliver_paper.eu_courier_journal_com <- pb_deliver_paper.usatoday_com
pb_deliver_paper.eu_democratandchronicle_com <- pb_deliver_paper.usatoday_com
pb_deliver_paper.golfweek_usatoday_com <- pb_deliver_paper.usatoday_com
pb_deliver_paper.mmajunkie_usatoday_com <- pb_deliver_paper.usatoday_com
