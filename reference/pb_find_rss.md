# Find RSS feed on a newspapers website

Find RSS feed on a newspapers website

## Usage

``` r
pb_find_rss(x, use = c("main", "suffixes", "feedly"))
```

## Arguments

- x:

  main domain of the newspaper site to check for RSS feeds.

- use:

  which steps to include in the search (see Details). Default is to
  include all.

## Value

A URL to the RSS feed(s) or NULL if nothing is found

## Details

Uses a three step heuristic to find RSS feeds:

1.  Scrapes the main page (without any paths) to see if the RSS feed is
    advertised

2.  Checks a number of common paths where sites put their RSS feeds

3.  Queries the [feedly.com](https://feedly.com/) API to for feeds
    associated with a page

## References

Approach inspired by <https://github.com/mediacloud/feed_seeker>

## Examples

``` r
pb_find_rss("https://www.buzzfeed.com/")
#> ℹ Looking through links on the main page
#> ✔ Looking through links on the main page [151ms]
#> 
#> ℹ Looking through common paths on the site
#> ✔ Looking through common paths on the site [330ms]
#> 
#> ℹ Querying feedly API
#> ✔ Querying feedly API [188ms]
#> 
#> ℹ Discovered 7 URLsCheck manually to see which ones fit
#> # A tibble: 7 × 2
#>   source           url                                      
#>   <chr>            <chr>                                    
#> 1 landing page     https://www.buzzfeed.com/rss             
#> 2 common locations https://buzzfeed.com/index.xml           
#> 3 feedly API       https://www.buzzfeed.com/index           
#> 4 feedly API       https://www.buzzfeed.com/food            
#> 5 feedly API       https://www.buzzfeed.com/badge/wtf       
#> 6 feedly API       https://www.buzzfeed.com/celebrity       
#> 7 feedly API       https://www.buzzfeed.com/badge/collection
```
