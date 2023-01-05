.onLoad <- function(libname, pkgname) {
  verbose <- getOption("paperboy_verbose")
  if (is.null(verbose)) options(paperboy_verbose = TRUE)
}
paperboy.env <- new.env()
