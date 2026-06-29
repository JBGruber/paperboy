#' @export
pb_deliver_paper.br_de <- function(x, verbose = NULL, pb, ...) {
  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  
  datetime <- html %>%
    rvest::html_element("time") %>%
    rvest::html_attr("datetime") %>%
    lubridate::as_datetime()
  
  headline <- html %>%
    rvest::html_element(".heading1") %>%
    rvest::html_text2()
  
  author <- html %>%
    rvest::html_element("span[class*='authorName']") %>%
    rvest::html_text2() %>%
    toString()
  
  text <- html %>%
    rvest::html_elements("div[class*='richText'] p") %>%
    rvest::html_text2() %>%
    .[!grepl("^\"Hier ist Bayern\"|^Das ist die Europ", .)] %>%
    paste(collapse = "\n")
  
  accessed <- Sys.time()
  
  domain <- x$domain
  
  if(domain == "ardsounds.de"){
    content_type <- "podcast"
    s_n_list(
      datetime,
      author,
      headline,
      text,
      accessed,
      content_type
    )
  } else {
    s_n_list(
      datetime,
      author,
      headline,
      text,
      accessed
      )
  }
  
}
