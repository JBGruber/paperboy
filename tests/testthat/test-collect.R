test_that("status", {
  expect_message(
    pb_collect("https://httpbin.org/status/404"),
    "1 link had issues."
  )
  expect_error(
    pb_collect("test"),
    "Connection error. Set"
  )
  expect_equal(
    dim(pb_collect("test", ignore_fails = TRUE)),
    c(1, 5)
  )
})

test_that("expandurls", {
  expect_equal(
    dim(pb_collect(urls = "https://httpbin.org/")),
    c(1, 5)
  )
  expect_warning(
    pb_collect(urls = "https://httpbin.org/delay/10", timeout = 1, ignore_fails = TRUE),
    "download did not finish before timeout."
  )
})

test_that("send cookies", {
  jar <- options(cookie_dir = tempdir())
  withr::defer(options(jar))
  withr::defer(unlink(file.path(tempdir(), paste0("cookies.rds"))))
  expect_equal({
    cookiemonster::add_cookies(cookiestring = "test=true; success=yes", domain = "https://hb.cran.dev", confirm = TRUE)
    pb_collect("https://hb.cran.dev/cookies", use_cookies = TRUE, verbose = FALSE)$content_raw
  }, "{\n  \"cookies\": {\n    \"success\": \"yes\", \n    \"test\": \"true\"\n  }\n}\n")
})

test_that("rss", {
  expect_equal({
    res <- pb_collect(urls = "https://rss.nytimes.com/services/xml/rss/nyt/World.xml")
    c(nrow(res) > 1, ncol(res))
  }, c(1, 5))
})

test_that("store local", {
  tmp <- tempdir()
  expect_true({
    pb_collect(urls = "https://httpbin.org/status/200",
               save_dir = tmp)
    file.exists(file.path(tmp, "d84c33c485e54845b489f53feada52f0.html"))
  })
})

test_that("verbosity", {
  expect_no_condition(pb_collect(urls = "https://httpbin.org/status/200", verbose = FALSE))
  expect_message(pb_collect(urls = "https://httpbin.org/status/200", verbose = TRUE),
                 "unique URLs provided")
  expect_message(pb_collect(urls = "https://httpbin.org/status/200", verbose = TRUE),
                 "Fetching pages...")
})
