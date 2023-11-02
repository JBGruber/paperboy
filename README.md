
# paperboy <img src="man/figures/logo.svg" align="right" height="139" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/JBGruber/paperboy/workflows/R-CMD-check/badge.svg)](https://github.com/JBGruber/paperboy/actions)
[![Codecov test
coverage](https://codecov.io/gh/JBGruber/paperboy/branch/main/graph/badge.svg)](https://codecov.io/gh/JBGruber/paperboy?branch=main)
<!-- badges: end -->

The philosophy of `paperboy` is that the package is a comprehensive
collection of webscraping scripts for news media sites. Many data
scientists and researchers write their own code when they have to
retrieve news media content from websites. At the end of research
projects, this code is often collecting digital dust on researchers hard
drives instead of being made public for others to employ. `paperboy`
offers writers of webscraping scripts a clear path to publish their code
and earn co-authorship on the package (see [For
developers](#for-developers) Section). For users, the promise is simple:
`paperboy` delivers news media data from many websites in a consistent
format. Check which domains are already supported in [the table
below](#available-scrapers) or with the command `pb_available()`.

## Installation

`paperboy` is not on [CRAN](https://CRAN.R-project.org) yet. Install via
`remotes` (first install `remotes` via `install.packages("remotes")`:

``` r
remotes::install_github("JBGruber/paperboy")
```

## For Users

Say you have a link to a news media article, for example, from
[mediacloud.org](https://mediacloud.org/). Simply supply one or multiple
links to a media article to the main function, `pb_deliver`:

``` r
library(paperboy)
df <- pb_deliver("https://tinyurl.com/386e98k5")
df
```

| url                            | expanded_url                                                                      | domain          | status | datetime            | author                                                | headline                | text                           | misc |
|:-------------------------------|:----------------------------------------------------------------------------------|:----------------|-------:|:--------------------|:------------------------------------------------------|:------------------------|:-------------------------------|:-----|
| <https://tinyurl.com/386e98k5> | <https://www.theguardian.com/tv-and-radio/2021/jul/12/should-marge-divorce-homer> | theguardian.com |    200 | 2021-07-12 12:00:13 | <https://www.theguardian.com/profile/stuart-heritage> | ’A woman trapped in an… | In the Guide’s weekly Solved!… | NULL |

The returned `data.frame` contains important meta information about the
news items and their full text. Notice, that the function had no problem
reading the link, even though it was shortened. ***`paperboy` is an
unfinished and highly experimental package at the moment.*** You will
therefore often encounter this warning:

``` r
pb_deliver("google.com")
#> ! No parser for domain google.com yet, attempting generic approach.
```

| url        | expanded_url             | domain     | status | datetime | author | headline | text                                                | misc |
|:-----------|:-------------------------|:-----------|-------:|:---------|:-------|:---------|:----------------------------------------------------|:-----|
| google.com | <http://www.google.com/> | google.com |    200 | NA       | NA     | Google   | © 2023 - Datenschutzerklärung - Nutzungsbedingungen | NULL |

The function still returns a data.frame, but important information is
missing — in this case because it isn’t there. The other URLs will be
processed normally though. If you have a dead link in your `url` vector,
the `status` column will be different from `200` and contain `NA`s.

If you are unhappy with results from the generic approach, you can still
use the second function from the package to download raw html code and
later parse it yourself:

``` r
pb_collect("google.com")
```

| url        | expanded_url             | domain     | status | content_raw                        |
|:-----------|:-------------------------|:-----------|-------:|:-----------------------------------|
| google.com | <http://www.google.com/> | google.com |    200 | \<!doctype html\>\<html itemscope… |

`pb_collect` uses concurrent requests to download many pages at the same
time, making the function very quick to collect large amounts of data.
You can then experiment with `rvest` or another package to extract the
information you want from `df$content_raw`.

## For developers

If there is no scraper for a news site and you want to contribute one to
this project, you can become a co-author of this package by adding it
via a pull request. First check [available
scrapers](#available-scrapers) and open
[issues](https://github.com/JBGruber/paperboy/issues) and [pull
requests](https://github.com/JBGruber/paperboy/pulls). Open a new issue
or comment on an existing one to communicate that you are working on a
scraper (so that work isn’t done twice). Then start by pulling a few
articles with `pb_collect` and start to parse the html code in the
`content_raw` column (preferably with `rvest`).

Every webscraper should retrieve a `tibble` with the following format:

| url                                 | expanded_url | domain     | status           | datetime             | headline     | author     | text          | misc                                                                      |
|:------------------------------------|:-------------|:-----------|:-----------------|:---------------------|:-------------|:-----------|:--------------|:--------------------------------------------------------------------------|
| character                           | character    | character  | integer          | as.POSIXct           | character    | character  | character     | list                                                                      |
| the original url fed to the scraper | the full url | the domain | http status code | publication datetime | the headline | the author | the full text | all other information that can be consistently found on a specific outlet |

Since some outlets will give you additional information, the `misc`
column was included so these can be retained.

## Available Scrapers

| domain                         | status                                                        | author                                    | issues                                                 |
|:-------------------------------|:--------------------------------------------------------------|:------------------------------------------|:-------------------------------------------------------|
| ac24.cz                        | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| ad.nl                          | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| aktualne.cz                    | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| anotherangryvoice.blogspot.com | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| bbc.co.uk                      | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| blesk.cz                       | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| boston.com                     | ![](https://img.shields.io/badge/status-requested-lightgrey)  |                                           | [\#1](https://github.com/JBGruber/paperboy/issues/1)   |
| bostonglobe.com                | ![](https://img.shields.io/badge/status-requested-lightgrey)  |                                           | [\#1](https://github.com/JBGruber/paperboy/issues/1)   |
| breitbart.com                  | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| buzzfeed.com                   | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| cbslnk.cbsileads.com           | ![](https://img.shields.io/badge/status-requested-lightgrey)  |                                           | [\#1](https://github.com/JBGruber/paperboy/issues/1)   |
| cbsnews.com                    | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| ceskatelevize.cz               | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| cnet.com                       | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| dailymail.co.uk                | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| decider.com                    | ![](https://img.shields.io/badge/status-requested-lightgrey)  |                                           | [\#1](https://github.com/JBGruber/paperboy/issues/1)   |
| denikn.cz                      | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| edition.cnn.com                | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| eu.usatoday.com                | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| evolvepolitics.com             | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| faz.net                        | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| forbes.com                     | ![](https://img.shields.io/badge/status-silver-%23C0C0C0.svg) | [@JBGruber](https://github.com/JBGruber/) | [\#2](https://github.com/JBGruber/paperboy/issues/2)   |
| fortune.com                    | ![](https://img.shields.io/badge/status-requested-lightgrey)  |                                           | [\#1](https://github.com/JBGruber/paperboy/issues/1)   |
| foxbusiness.com                | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| foxnews.com                    | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| ftw.usatoday.com               | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| geenstijl.nl                   | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| hn.cz                          | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| huffingtonpost.co.uk           | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| idnes.cz                       | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| independent.co.uk              | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| irozhlas.cz                    | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| latimes.com                    | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| lidovky.cz                     | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| lnk.techrepublic.com           | ![](https://img.shields.io/badge/status-requested-lightgrey)  |                                           | [\#1](https://github.com/JBGruber/paperboy/issues/1)   |
| marketwatch.com                | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| mediacourant.nl                | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| metronieuws.nl                 | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| msnbc.com                      | ![](https://img.shields.io/badge/status-requested-lightgrey)  |                                           | [\#1](https://github.com/JBGruber/paperboy/issues/1)   |
| newsweek.com                   | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| nos.nl                         | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| novinky.cz                     | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| nrc.nl                         | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| nu.nl                          | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| nypost.com                     | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| nytimes.com                    | ![](https://img.shields.io/badge/status-silver-%23C0C0C0.svg) | [@JBGruber](https://github.com/JBGruber/) | [\#17](https://github.com/JBGruber/paperboy/issues/17) |
| pagesix.com                    | ![](https://img.shields.io/badge/status-requested-lightgrey)  |                                           | [\#1](https://github.com/JBGruber/paperboy/issues/1)   |
| parlamentnilisty.cz            | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| seznamzpravy.cz                | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| sfgate.com                     | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| skwawkbox.org                  | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| telegraaf.nl                   | ![](https://img.shields.io/badge/status-silver-%23C0C0C0.svg) | [@JBGruber](https://github.com/JBGruber/) | [\#17](https://github.com/JBGruber/paperboy/issues/17) |
| telegraph.co.uk                | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| thecanary.co                   | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| theguardian.com                | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| thelily.com                    | ![](https://img.shields.io/badge/status-requested-lightgrey)  |                                           | [\#1](https://github.com/JBGruber/paperboy/issues/1)   |
| thismorningwithgordondeal.com  | ![](https://img.shields.io/badge/status-requested-lightgrey)  |                                           | [\#1](https://github.com/JBGruber/paperboy/issues/1)   |
| time.com                       | ![](https://img.shields.io/badge/status-requested-lightgrey)  |                                           | [\#1](https://github.com/JBGruber/paperboy/issues/1)   |
| tribpub.com                    | ![](https://img.shields.io/badge/status-requested-lightgrey)  |                                           | [\#1](https://github.com/JBGruber/paperboy/issues/1)   |
| us.cnn.com                     | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| usatoday.com                   | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| volkskrant.nl                  | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| washingtonpost.com             | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |
| wsj.com                        | ![](https://img.shields.io/badge/status-gold-%23ffd700.svg)   | [@JBGruber](https://github.com/JBGruber/) |                                                        |

- ![](https://img.shields.io/badge/status-gold-%23ffd700.svg): Runs
  without known issues
- ![](https://img.shields.io/badge/status-silver-%23C0C0C0.svg): Runs
  with some issues
- ![](https://img.shields.io/badge/status-broken-%23D8634C)![](https://img.shields.io/badge/status-requested-lightgrey):
  Currently not working, fix has been requested
