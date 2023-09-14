#' Inspect content collected with pb_collect
#'
#' Opens a browser to display the content saved in a row of a data.frame created
#' with \link{pb_collect}.
#'
#' @param x a data.frame returned by \link{pb_collect}.
#' @param i which entry to display.
#' @param host_ip,port host IP and port to create the temporary web server that
#'   shows the content.
#'
#' @export
pb_inspect <- function(x,
                       i = 1L,
                       host_ip = "127.0.0.1",
                       port = httpuv::randomPort()) {

  content_raw <- NULL
  rlang::check_installed("httpuv")

  if (!"content_raw" %in% names(x))
    stop("Only works with output from pb_collect()")

  if (!is.null(paperboy.env$server)) paperboy.env$server$stop()

  if (grepl("<|>", x$content_raw[i])) {
    paperboy.env$server <- httpuv::startServer(
      host = host_ip,
      port = port,
      app = list(
        call = function(req) {
          list(
            status = 200L,
            headers = list("Content-Type" = "text/html"),
            body = x$content_raw[i]
          )
        }
      )
    )
    utils::browseURL(paste0("http://", host_ip, ":", port))
  } else {
    utils::browseURL(x$content_raw[i])
  }


}
