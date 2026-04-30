# Inspect content collected with pb_collect

Opens a browser to display the content saved in a row of a data.frame
created with
[pb_collect](https://jbgruber.github.io/paperboy/reference/pb_collect.md).

## Usage

``` r
pb_inspect(x, i = 1L, host_ip = "127.0.0.1", port = httpuv::randomPort())
```

## Arguments

- x:

  a data.frame returned by
  [pb_collect](https://jbgruber.github.io/paperboy/reference/pb_collect.md).

- i:

  which entry to display.

- host_ip, port:

  host IP and port to create the temporary web server that shows the
  content.
