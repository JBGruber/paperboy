
<!-- README.md is generated from README.Rmd. Please edit that file -->

# paperboy

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/JBGruber/paperboy/workflows/R-CMD-check/badge.svg)](https://github.com/JBGruber/paperboy/actions)
[![Codecov test
coverage](https://codecov.io/gh/JBGruber/paperboy/branch/main/graph/badge.svg)](https://codecov.io/gh/JBGruber/paperboy?branch=main)
<!-- badges: end -->

[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/JohannesBGruber.svg?style=social&label=Follow%20%40JohannesBGruber)](https://twitter.com/JohannesBGruber)

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
```

| url                            | expanded\_url                                                                     | domain              | status | datetime            | author                                                | headline                | text                     | misc |
|:-------------------------------|:----------------------------------------------------------------------------------|:--------------------|-------:|:--------------------|:------------------------------------------------------|:------------------------|:-------------------------|:-----|
| <https://tinyurl.com/386e98k5> | <https://www.theguardian.com/tv-and-radio/2021/jul/12/should-marge-divorce-homer> | www.theguardian.com |    200 | 2021-07-12 12:00:13 | <https://www.theguardian.com/profile/stuart-heritage> | ‘A woman trapped in an… | The Simpson couple have… | NULL |

The returned `data.frame` contains important meta information about the
news items and their full text. Notice, that the function had no problem
reading the link, even though it was shortened. `paperboy` is an
unfinished and even highly experimental package at the moment. You will
therefore often encounter this warning:

``` r
deliver(url = "google.com")
#> 1 links from 1 domains unshortened. Fetching...
#> Warning in deliver.default(u, verbose = verbose, ...): No method for
#> www.google.com yet. Url ignored.
```

If you enter a vector of multiple URLs, the unsupported ones will be
ignored with a `warning`. The other URLs will be processed normally
though. If you have a dead link in your `url` vector, the `status`
column will be different from `200` and contain `NA`s.

## For developers

Every webscraper should retrieve a `tibble` with the following format:

| url                                 | expanded\_url | domain     | status           | datetime             | headline     | author     | text          | misc                                                                      |
|:------------------------------------|:--------------|:-----------|:-----------------|:---------------------|:-------------|:-----------|:--------------|:--------------------------------------------------------------------------|
| character                           | character     | character  | integer          | as.POSIXct           | character    | character  | character     | list                                                                      |
| the original url fed to the scraper | the full url  | the domain | http status code | publication datetime | the headline | the author | the full text | all other information that can be consistently found on a specific outlet |

Since some outlets will give you additional information, the `misc`
column was included so these can be retained. If you have a scraper you
want to contribute, look in the list below if it already exists. If it
does not yet exist, you can become a co-author of this package by adding
it via a pull request.

## Available Scrapers

| domain               | status                                                        | author             | issues                                               |
|:---------------------|:--------------------------------------------------------------|:-------------------|:-----------------------------------------------------|
| theguardian.com      | ![](https://img.shields.io/badge/status-silver-%23C0C0C0.svg) | Johannes B. Gruber | [#1](https://github.com/JBGruber/paperboy/issues/1) |
| huffingtonpost.co.uk | ![](https://img.shields.io/badge/status-silver-%23C0C0C0.svg) | Johannes B. Gruber | [#1](https://github.com/JBGruber/paperboy/issues/1) |
| buzzfeed.com         | ![](https://img.shields.io/badge/status-broken-%23D8634C)     | Johannes B. Gruber | [#1](https://github.com/JBGruber/paperboy/issues/1) |
| forbes.com           | ![](https://img.shields.io/badge/status-broken-%23D8634C)     | Johannes B. Gruber | [#1](https://github.com/JBGruber/paperboy/issues/1) |

-   ![](https://img.shields.io/badge/status-gold-%23ffd700.svg): Runs
    without any issues
-   ![](https://img.shields.io/badge/status-silver-%23C0C0C0.svg): Runs
    with some issues
-   ![](https://img.shields.io/badge/status-broken-%23D8634C): Currently
    not working, fix has been requested
