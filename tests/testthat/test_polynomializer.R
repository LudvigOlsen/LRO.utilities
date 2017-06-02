library(LRO.utilities)
context("polynomializer()")


test_that("polynomializer creates the right columns with vectors", {

  vect <- c(1,3,5,7,8)

  expect_equal(polynomializer(vect, degree = 3),
               data.frame(vect = c(1,3,5,7,8),
                          vect_2 = vect^2,
                          vect_3 = vect^3))

  expect_equal(polynomializer(vect, degree = 3, up_to=F),
               data.frame(vect = c(1,3,5,7,8),
                          vect_3 = vect^3))

  expect_error(polynomializer(vect, cols = c('bect','dect'), degree = 3),
               "data is vector, argument 'cols' must be NULL", fixed = T)


})


test_that("polynomializer creates the right columns with dataframes", {

  vect <- c(1,3,5,7,8)
  data <- data.frame(vect = c(1,3,5,7,8),
                     bect = vect*3,
                     dect = vect*5)


  expect_equal(polynomializer(data, cols = c('bect','dect'), degree = 3),
               data.frame(vect = c(1,3,5,7,8),
                          bect = c(3,9,15,21,24),
                          dect = c(5,15,25,35,40),
                          bect_2 = c(9,81,225,441,576),
                          bect_3 = c(27,729,3375,9261,13824),
                          dect_2 = c(25,225,625,1225,1600),
                          dect_3 = c(125,3375,15625,42875,64000)))

  expect_equal(polynomializer(data, cols = c('bect','dect'), degree = 3, up_to = F),
               data.frame(vect = c(1,3,5,7,8),
                          bect = c(3,9,15,21,24),
                          dect = c(5,15,25,35,40),
                          bect_3 = c(27,729,3375,9261,13824),
                          dect_3 = c(125,3375,15625,42875,64000)))

  expect_error(polynomializer(data, degree = 3),
               "data is dataframe, argument 'cols' must be specified", fixed = T)

  # Try with summarized_data that is saved to project
  # This had the error that merging of input data and generated data
  # went wrong. So changed it to cbind.
  expect_equal(nrow(polynomializer(summarized_data, col = "trial", degree = 2)), 240)



})
