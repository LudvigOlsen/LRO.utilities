# Not in

#' @title Values Not In
#' @description Negated \code{\%in\%}.
#' @param x Vector with values to be matched.
#' @param table Vector with values to be matched against.
#' @export
#' @return A logical vector, indicating if no match
#'  was located for each element of x.
#'  Values are TRUE or FALSE and never NA.
`%ni%` <- function(x, table) {

  return(!(x %in% table))

  }
