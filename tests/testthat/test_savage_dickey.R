library(LRO.utilities)
library(ggplot2)
context("savage_dickey")

test_that("savage_dickey() works correctly", {

  set.seed(1)
  prior <- rnorm(100, mean=0, sd=1)
  set.seed(1)
  posterior <- rnorm(100, mean=2, sd=2)

  expect_equal(savage_dickey(posterior, prior, Q = 0, print_plot = FALSE, plot = FALSE),
               list("BF10" = 0.151, "BF01" = 6.582), tolerance=1e-2)

  # Doesn't test the ggplot object!

})
