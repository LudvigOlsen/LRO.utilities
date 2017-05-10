library(LRO.utilities)
context("roll_previous")

test_that("roll_previous() works correctly", {

  df <- data.frame('round' = c(1,2,3,4,5,6,7,8,9,10),
                   'score' = c(5,3,4,7,6,5,2,7,8,6))

  expect_equal(roll_previous(df$score, width = 2, FUN = mean),
               c(NA,NA,4, 3.5, 5.5, 6.5, 5.5, 3.5, 4.5, 7.5))

  })
