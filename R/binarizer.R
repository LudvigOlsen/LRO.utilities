# Binarizer

#

#' @title Binarize multiple columns at once
#' @description Binarize multiple columns of a dataframe based on a given threshold.
#'
#'  \strong{binarizer} is designed to work with \link[magrittr]{\%>\%} pipelines.
#'
#'  \strong{binarizer_} is a standard evalution version.
#' @param data Dataframe, tbl, vector
#' @param ...,cols Variables to include/exclude.
#'
#'  ... :
#'  You can use same specifications as in dplyr's \link[dplyr]{select}.
#'
#'  cols :
#'  character vector
#'
#'  If missing, defaults to all non-grouping variables.
#' @param thresh Threshold (Numeric).
#' @return Tibble where selected columns have been binarized.
#'
#' Above thresh is 1; below or equal to thresh is 0.
#' @details Binarizes each specified column and converts to tibble.
#' @aliases binarizer_
#' @export
#' @examples
#' # Attach package
#' library(LRO.utilities)
#'
#' # Create dataframe
#' df <- data.frame('a' = c(1,2,3,4,5,6,7),
#'                  'b' = c(2,3,4,5,6,7,8))
#'
#' # First center both columns
#' centered_df <- scaler(df, scale = F)
#'
#' # Binarizing multiple columns
#' binarizer(centered_df)
#' binarizer(centered_df, a, b)
#' binarizer(centered_df, 1:2)
#' binarizer(centered_df, c(a,b))
#'
#' # Binarize 'a'
#' binarizer(centered_df, a)
#'
#' # Binarize all but 'a'
#' binarizer(centered_df, -a)
#'
#' ## Standard evalutation versions
#'
#' binarizer_(centered_df, cols = c('b'))
#'
#' @importFrom dplyr '%>%'
binarizer <- function(data, ..., thresh = 0){

  # If data is a vector
  # Convert to tibble
  # with name of passed object
  # or "x" is object has no name
  if (is.vector(data)){

    # Get name of passed object
    # If it is c(...) it will be set to "x"
    # in the convert_and_... function
    vector_name <- deparse(substitute(data))

    data <- convert_and_name_vector(data, vector_name)
  }

  # Get columns from dots
  cols <- get_dots_cols(data, ...)

  binarizer_(data = data,
             cols = cols,
             thresh = thresh)

}


#' @rdname binarizer
#' @export
binarizer_ <- function(data, cols = NULL, thresh = 0){

  # If data is a vector
  # Convert to tibble
  # with name of passed object
  # or "x" is object has no name
  if (is.vector(data)){

    # Get name of passed object
    # If it is c(...) it will be set to "x"
    # in the convert_and_... function
    vector_name <- deparse(substitute(data))

    data <- convert_and_name_vector(data, vector_name)
  }

  if (is.null(cols)){

    cols <- colnames(data)

  }

  # If data is a vector with no name
  # convert to tibble and set colname
  # and cols to "x"
  if (is.null(cols) && is.vector(data)){

    data <- tibble::tibble(x = data)
    cols <- "x"

  }

  data %>%
    tibble::as_tibble() %>%
    dplyr::mutate_each_(
      dplyr::funs(binarize_single(., thresh = thresh)),
                 vars = cols)


}


binarize_single <- function(col, thresh = 0){

  ifelse(col > thresh,1,0)

}

