
<!-- README.md is generated from README.Rmd. Please edit that file -->

# paperboy

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The philosophy of `paperboy` is that the package is a comprehensive
collection of webscraping scripts for news media sites. Many data
scientist and researchers write their own code when they have to
retrieve news media content from websites. At the end of research
projects, this code is often collecting digital dust on researchers hard
drives instead of being made public for others to use. `paperboy` offers
writers of webscraping scripts a clear path to publish their code and
earn co-authorship on the package. For users, the promise is simple:
`paperboy` delivers news media data from many websites in a consistent
format.

## Installation

`paperboy` is not on [CRAN](https://CRAN.R-project.org) yet. Install via
`remotes` (first install `remotes` via `install.packages("remotes")`:

``` r
remotes::install_github("JBGruber/paperboy")
```

## For users

Say you have a link to a news media article, for example, from
[mediacloud.org](https://mediacloud.org/). Simply supply one or multiple
links to a media article to the main function, `deliver`:

``` r
library(paperboy)
df <- deliver("https://tinyurl.com/386e98k5")
df
#> # A tibble: 1 x 8
#>   url   expanded_url domain datetime headline author text  misc            
#>   <lgl> <lgl>        <lgl>  <lgl>    <lgl>    <lgl>  <lgl> <list>          
#> 1 NA    NA           NA     NA       NA       NA     NA    <tibble [1 × 1]>
```

The returned `data.frame` contains important meta information about the
news items and their full text. Notice, that the function had no problem
reading the link, even though it was shortened. `paperboy` is an
unfinished and even highly experimental package at the moment. You will
therefore often encounter this warning:

``` r
deliver(url = "google.com")
#> Warning in deliver.default(u, ...): No method for www.google.com yet. Url
#> ignored.
#> # A tibble: 0 x 0
```

If you enter a vector of multiple URLs, the unsupported ones will be
ignored with a `warning`. The other URLs will be processed normally
though. If you have a dead link in your `url` vector, the `status`
column will be different from `200` and contain `NA`s.

## For developers

Every webscraper should retrieve a `tibble` with the following format:

    #> # A tibble: 2 x 9
    #>   url     expanded_url domain  status  datetime  headline author text  misc     
    #>   <chr>   <chr>        <chr>   <chr>   <chr>     <chr>    <chr>  <chr> <chr>    
    #> 1 charac… character    charac… integer as.POSIX… charact… chara… char… list     
    #> 2 the or… the full url the do… http s… publicat… the hea… the a… the … all othe…

Since some outlets will give you additional information, the `misc`
column was included so these can be retained. If you have a scaper you
want to contribute, look in the list below if it already exists. If it
does not yet exist, you can become a co-author of this package by adding
it via a pull request.

# Available Scrapers

    #> # A tibble: 4 x 3
    #>   domain               status author            
    #>   <chr>                <chr>  <chr>             
    #> 1 theguardian.com      Broken Johannes B. Gruber
    #> 2 huffingtonpost.co.uk Broken Johannes B. Gruber
    #> 3 buzzfeed.com         Broken Johannes B. Gruber
    #> 4 forbes.com           Broken Johannes B. Gruber

-   **Gold**: Runs without any issues
-   **Silver**: Runs with some issues
-   **Broken**: Currently not working
