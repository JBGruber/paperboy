# Create a new parser

Create a new parser for a given domain.

## Usage

``` r
use_new_parser(x, author = "", issue = "", rss = NULL, test_data = NULL)
```

## Arguments

- x:

  A character string of a URL to the newspaper to create a parser for.

- author:

  A Markdown formatted character string of the author of the parser.

- issue:

  A Markdown formatted link to the issue associated with the parser
  (please file an issue before starting to work on a new parser).

- rss:

  An optional character string of the RSS feed associated with the
  parser.

- test_data:

  An optional data frame of test data to use for testing the parser.

## Value

A message indicating the success or failure of the parser creation.

## Details

The function will process through the steps for creating a new parser,
which are:

1.  Creating a file from the parser template

2.  Trying to find an RSS feed link

3.  Add a new entry to the status.csv file, which contains information
    about all parsers.

4.  Edit the parsers to extract required and additional information from
    articles on the site.

5.  Check the parser for consistency (can it be loaded? are all entries
    present?).

6.  Check against test data (either provided in the function or
    downloaded from the RSS feed).

7.  Finalise CSV entry

As might be obvious, not all steps can be performed in a single action.
Rather the idea is to run the function multiple times, until all is
done.

## Examples

``` r
if (FALSE) { # \dontrun{
use_new_parser(x = "https://www.buzzfeed.com/",
               author = "[@JBGruber](https://github.com/JBGruber/)",
               issue = "[#1](https://github.com/JBGruber/paperboy/issues/1)",
               rss = "https://www.buzzfeed.com/rss")
} # }
```
