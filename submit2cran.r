library(tidyverse)
## Update roxygen and check
roxygen2::roxygenise(clean = TRUE)
devtools::check()

## Check code quality
lintr::lint_package()
goodpractice::gp()

## Check spelling
spelling::spell_check_package()
spelling::update_wordlist()
spelling::spell_check_files("README.Rmd", ignore = readLines("./inst/WORDLIST"), lang = "en-GB")

## build manual
devtools::build_manual()

# build readme
parser_df <- rio::import("inst/status.csv") %>%
  arrange(domain)
## check if all parsers are listed
parser_available <- pb_available() %>%
  str_remove("www.") %>%
  tibble(parser = .)

parser_available %>%
  anti_join(parser_df, by = c("parser" = "domain"))

rio::export(parser_df, "inst/status.csv")
devtools::build_readme()
lines <- readLines("README.md")
writeLines(gsub("[\\#", "[#", lines, fixed = TRUE), "README.md")



## build vignette
devtools::build_vignettes()

## test covr
devtools::test_coverage()


# For release on CRAN
## test on winbuilder
devtools::check_win_devel()
devtools::check_win_oldrelease()
devtools::check_win_release()

## check r_hub
ch <- rhub::check_for_cran(show_status = FALSE)
ch$livelog() # check status

## release
revdepcheck::revdep_check()
devtools::release()
