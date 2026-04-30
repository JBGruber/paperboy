# internal function to deliver specific newspapers

internal function to deliver specific newspapers

## Usage

``` r
pb_deliver_paper(x, verbose, pb, ...)
```

## Arguments

- x:

  Either a vector of URLs or a data.frame returned by
  [pb_collect](https://jbgruber.github.io/paperboy/reference/pb_collect.md).

- verbose:

  `FALSE` turns deliver silent. `TRUE` prints status messages and a
  progress bar on the screen. `2L` turns on debug mode. If `NULL` will
  be determined from `getOption("paperboy_verbose")`.

- pb:

  a progress bar object.

- ...:

  Passed on to
  [pb_collect](https://jbgruber.github.io/paperboy/reference/pb_collect.md).
