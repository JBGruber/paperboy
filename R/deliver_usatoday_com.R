pb_deliver_paper.usatoday_com <- function(x, verbose, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

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
    rvest::html_elements(".authors,[itemprop=\"author\"],.gnt_ar_by_a,.gnt_ar_by,.topper__byline")  %>%
    rvest::html_text2() %>%
    unique() %>%
    toString()

  if (!isFALSE(is.na(datetime))) {
    datetime <- html %>%
      rvest::html_elements("[slot=\"data\"],script") %>%
      rvest::html_text() %>%
      extract("\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z") %>%
      unique() %>%
      lubridate::as_datetime() |>
      utils::head(1L)
  }

  # headline
  headline <- html %>%
    rvest::html_elements("[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  # text
  text <- html %>%
    rvest::html_elements("article>p,.articleBody>p,.gnt_ar_b>p,.exclude-from-newsgate,.detail-text") %>%
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
pb_deliver_paper.mmajunkie_usatoday_com <-
  pb_deliver_paper.golfweek_usatoday_com <-
  pb_deliver_paper.www_democratandchronicle_com <-
  pb_deliver_paper.www_usatoday_com <-
  pb_deliver_paper.eu_democratandchronicle_com <-
  pb_deliver_paper.eu_courier_journal_com <-
  pb_deliver_paper.eu_usatoday_com <-
  pb_deliver_paper.ftw_usatoday_com <-
  pb_deliver_paper.eu_tennessean_com <-
  pb_deliver_paper.usatoday_com
