
#' @title Scale multiple columns at once
#' @description Center and/or scale multiple columns of a dataframe.
#'  Can be used in \link[magrittr]{\%>\%} pipelines.
#'
#'  scaler_ is the standard evalution version.
#' @param data Dataframe, tibble, etc.
#' @param ...,cols Variables to include/exclude.
#'
#'  ... :
#'  You can use same specifications as in dplyr's \link[dplyr]{select}.
#'
#'  cols :
#'  character vector
#'
#'  If missing, defaults to all non-grouping variables.
#' @param center Logical.
#' @param scale Logical.
#' @return Tibble where selected columns have been scaled.
#' @details Scales each column and converts to vector, thereby removing
#'  attributes.
#' @aliases scaler_
#' @export
#' @examples
#' # Attach package
#' library(LRO.utilities)
#'
#' # Create dataframe
#' df <- data.frame('a' = c(1,2,3,4,5,6,7),
#'                  'b' = c(2,3,4,5,6,7,8))
#'
#' # Scale and center both columns
#' scaler(df)
#'
#' # Scale and center 'b'
#' scaler(df, b)
#'
#' # Scale but not center 'a'
#' scaler(df, a, center = FALSE)
#'
#' # Scaling multiple columns
#' scaler(df, a, b)
#' scaler(df, 1:2)
#' scaler(df, c(a,b))
#'
#' # Scaling all but 'a'
#' scaler(df, -a)
#'
#' # Standard evalutation version
#' # scaler_()
#' scaler_(df, cols = c('a','b'))
#'
#' @importFrom dplyr '%>%'
scaler <- function(data, ..., center = TRUE, scale = TRUE){

  # Work with data
  data %>%

    # Convert to tibble
    tibble::as_tibble() %>%

    # Scale each column specified in ...
    # All columns by default
    dplyr::mutate_each(
      dplyr::funs(scale(., center = center,
                        scale = scale)), ...) %>%

    # Convert each column to vector
    # as scale() adds attributes
    dplyr::mutate_each(dplyr::funs(as.vector), ...)

}

#' @rdname scaler
#' @export
scaler_ <- function(data, cols=NULL, center = TRUE, scale = TRUE){

  # Work with data
  data %>%

    # Convert to tibble
    tibble::as_tibble() %>%

    # Scale each column specified in ...
    # All columns by default
    dplyr::mutate_each_(
      dplyr::funs(scale(., center = center,
                        scale = scale)), vars = cols) %>%

    # Convert each column to vector
    # as scale() adds attributes
    dplyr::mutate_each_(dplyr::funs(as.vector), vars = cols)

}
