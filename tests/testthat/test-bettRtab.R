
httr::set_config(httr::use_proxy(url = Sys.getenv("PROXY_URL"),
                                 port = as.numeric(Sys.getenv("PROXY_PORT")),
                                 username =Sys.getenv("PROXY_USERNAME"),
                                 password= Sys.getenv("PROXY_PASSWORD")))


test_that("get_sports_market() works", {
  df <- get_sports_market("Major League Baseball Futures")
  expect_type(df, "list")
  expect_true(ncol(df) != 0)
  expect_true(nrow(df) != 0)
})


test_that("get_race_meet_meta() works", {
  dates <- seq(from = as.Date("2022-08-02"), to=as.Date("2022-08-03"), by=1)
  df <- get_race_meet_meta(race_dates=dates)
  expect_type(df, "list")
  expect_true(ncol(df) != 0)
  expect_true(nrow(df) != 0)
})




# Test race results data --------------------------------------------------

test_that("get_past_race_content() works", {

  out <- get_past_race_content(url = "https://api.beta.tab.com.au/v1/historical-results-service/VIC/racing/2022-01-01/M/R/races/1")
  expect_type(out, "list")
  expect_true(length(out) != 0)
  expect_true(nrow(out[[1]]$runners) > 0)
})



test_that("get_past_races() works", {
  out <- get_past_races(meet_date = c('2022-09-03', '2022-09-10'), venue_mnem = 'M', race_type = 'R')
  expect_type(out, "list")
  expect_true(length(out) != 0)
  expect_true(nrow(out[[1]]$runners) > 0)
})


out <- get_past_race_content(url = "https://api.beta.tab.com.au/v1/historical-results-service/VIC/racing/2022-01-01/M/R/races/1")


test_that("parse_runners() works", {
  df <- parse_runners(race_list=out)
  expect_type(df, "list")
  expect_true(nrow(df) != 0)
})


test_that("parse_pools() works", {
  df <- parse_pools(race_list=out)
  expect_type(df, "list")
  expect_true(nrow(df) != 0)
})


test_that("parse_dividends() works", {
  df <- parse_dividends(race_list=out)
  expect_type(df, "list")
  expect_true(nrow(df) != 0)
})



test_that("get_live_sports() works", {
  df <- get_live_sports()
  expect_type(df, "list")
  expect_true(nrow(df) != 0)
})

