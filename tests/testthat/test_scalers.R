library(LRO.utilities)
library(tibble)
context("scalers")

test_that("scaler() works correctly", {

  df <- data.frame('a' = c(1,3,5),
                   'b' = c(2,3,4))

  # Scale and center both columns

  expect_equal(scaler(df), tibble(a = c(-1,0,1),
                                  b = c(-1,0,1)))

  # Scale and center 'b'
  expect_equal(scaler(df, b), tibble(a = c(1,3,5),
                                  b = c(-1,0,1)))

  # Scale but not center 'a'
  expect_equal(scaler(df, a, center = FALSE),
               tibble(a = c(0.5, 1.5, 2.5),
                      b = c(2,3,4)))

  # Scaling multiple columns
  expect_equal(scaler(df, a, b),
               tibble(a = c(-1,0,1),
                      b = c(-1,0,1)))

  expect_equal(scaler(df, 1:2),
               tibble(a = c(-1,0,1),
                      b = c(-1,0,1)))

  expect_equal(scaler(df, c(a,b)),
               tibble(a = c(-1,0,1),
                      b = c(-1,0,1)))

  # Scaling all but 'a'
  expect_equal(scaler(df, -a), tibble(a = c(1,3,5),
                                     b = c(-1,0,1)))

  ## Setting scale and center for each column
  expect_equal(scaler(df, center = c(FALSE, TRUE),
         scale = c(TRUE, FALSE)),
         tibble(a = c(0.5,1.5,2.5),
                b = c(-1,0,1)))


})


test_that("scaler_ fit/transform/invert works correctly", {

  df <- data.frame('a' = c(1,3,5),
                   'b' = c(2,3,4))

  expect_equal(scaler_fit(df, 1:2),
               tibble(column = factor(c("a","b")),
                      mean = c(3,3),
                      sd = c(2,1),
                      center = c(TRUE, TRUE),
                      scale = c(TRUE, TRUE)))

  expect_equal(scaler_fit_(df, c("a","b")),
               tibble(column = factor(c("a","b")),
                      mean = c(3,3),
                      sd = c(2,1),
                      center = c(TRUE, TRUE),
                      scale = c(TRUE, TRUE)))

  expect_equal(scaler_fit_(df),
               tibble(column = factor(c("a","b")),
                      mean = c(3,3),
                      sd = c(2,1),
                      center = c(TRUE, TRUE),
                      scale = c(TRUE, TRUE)))

  expect_equal(scaler_transform(df, scaler_fit(df)),
               tibble(a = c(-1,0,1),
                      b = c(-1,0,1)))

  scaled_df <- scaler(df)

  expect_equal(scaler_invert(scaled_df, scaler_fit(df)),
               tibble(a = c(1,3,5),
                      b = c(2,3,4)))


})


