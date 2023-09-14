#' Create new scraper
#'
#' @param np domain or a URL of the newspaper this scraper is for.
#' @param author who wrote it.
#' @param issue is there a GitHub issue?
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' paperboy:::pb_new(np = "https://www.buzzfeed.com/",
#'                   author = "[@JBGruber](https://github.com/JBGruber/)")
#'
#' paperboy:::pb_new_done()
#' }
pb_new <- function(np, author = "", issue = "") {

  np <- utils::head(urltools::domain(np), 1)
  np_ <- classify(np)

  template <- system.file("templates", "deliver_.R", package = "paperboy") %>%
    readLines() %>%
    gsub("{{newspaper}}", np_, x = ., fixed = TRUE)

  p <- ifelse(basename(getwd()) == "paperboy", "./R/", "")
  f <- paste0(p, "deliver_", np_, ".R")
  if (!file.exists(f)) {
    writeLines(template, f)
    cli::cli_alert_success("File {f} written")
  } else {
    cli::cli_alert_danger("File {f} alredy exists")
  }
  if (rlang::is_installed("rstudioapi")) {
    rstudioapi::documentOpen(f)
  } else {
    utils::file.edit(f)
  }
  if (file.exists("inst/status.csv")) {
    status <- read.csv("inst/status.csv") %>%
      rbind(list(domain = gsub("^www.", "", np),
                 status = "![](https://img.shields.io/badge/status-requested-lightgrey)",
                 author = author,
                 issues = issue)) %>%
      dplyr::arrange(domain)
    write.csv(status, "inst/status.csv", row.names = FALSE)
    cli::cli_alert_success("Status file updated")
  }

  cli::cli_alert_info("Edit {f} to be a valid parser")
  the$current <- np
  cli::cli_alert_info("Run {.code paperboy:::pb_new_done(\"{np}\")} to complete the process when ready")

}

#' @rdname pb_new
pb_new_done <- function(np) {
  if (missing(np)) np <- the$current
  if (is.null(np)) cli::cli_abort("You need to tell me which newspaper is done!")
  np <- utils::head(urltools::domain(np), 1)
  status <- read.csv("inst/status.csv")
  status[status$domain == gsub("^www.", "", np), "status"] <-
    "![](https://img.shields.io/badge/status-gold-%23ffd700.svg)"
  write.csv(status, "inst/status.csv", row.names = FALSE)
  cli::cli_alert_success("All done! {praise::praise()}")
}


#' Test a Parser
#'
#' Test a parser using a data frame from \link{pb_collect}.
#'
#' @param test_data A data frame of raw content.
#' @return A success or failure message.
test_parser <- function(test_data) {

  if (!"content_raw" %in% names(test_data))
    cli::cli_abort("Only works with output from {.fnc pb_collect}")

  cli::cli_alert_info("Trying to parse raw data")
  test_df_parsed <- pb_deliver(test_data)
  cli::cat_line()
  total <- nrow(test_df_parsed)
  cli::cli_alert_info("Checking results")
  fails <- check_fails(test_df_parsed, "datetime", total) +
    check_fails(test_df_parsed, "author", total) +
    check_fails(test_df_parsed, "headline", total) +
    check_fails(test_df_parsed, "text", total)

  if (fails == 0) {
    cli::cli_progress_done(
      praise::praise("${Exclamation}! Test passed ${adverb}! This parser is ${adjective}!")
    )
  } else {
    cli::cli_alert_danger(
      praise::praise("Some tests failed. But you will get there! Don't stop ${creating} now!")
    )
  }
  invisible(test_df_parsed)
}


pct <- function(x) {
  round(x * 100, 2) %>%
    format(nsmall = 2, big.mark = ",") %>%
    paste0("%")
}


check_fails <- function(df, what, total) {

  switch(what,
         "datetime" = fails <- sum(is.na(df[[what]])) / total,
         "author" = fails <- sum(df[[what]] == "NA") / total,
         "headline" = fails <- sum(df[[what]] == "") / total,
         "text" = fails <- sum(df[[what]] == "") / total
  )

  if (fails > 0.01 & fails < 0.05)
    cli::cli_alert_warning("More than {pct(fails)} of {what} values failed to parse")

  if (fails >= 0.05) {
    cli::cli_alert_danger("More than {pct(fails)} of {what} values failed to parse")
    return(TRUE)
  }
  return(FALSE)
}
