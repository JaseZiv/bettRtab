
test_that("get_sports_market() works", {
  df <- get_sports_market("Major League Baseball Futures")
  expect_type(df, "list")
  expect_true(ncol(df) != 0)
  expect_true(nrow(df) != 0)
})


test_that("get_race_meet_meta() works", {
  dates <- seq(from = as.Date("2022-08-01"), to=as.Date("2022-08-03"), by=1)
  df <- get_race_meet_meta(race_dates=dates)
  expect_type(df, "list")
  expect_true(ncol(df) != 0)
  expect_true(nrow(df) != 0)
})
