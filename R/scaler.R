
#' @title Scale multiple columns at once
#' @description Center and/or scale multiple columns of a dataframe.
#'  Can be used in \link[magrittr]{\%>\%} pipelines.
#' @param data Dataframe, tibble, etc.
#' @param ... Variables to include/exclude.
#'  You can use same specifications as in dplyr's \link[dplyr]{select}.
#'  If missing, defaults to all non-grouping variables.
#' @param center Logical.
#' @param scale Logical.
#' @return Tibble where selected columns have been scaled.
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
#' @importFrom dplyr '%>%'
scaler <- function(data, ..., center = TRUE, scale = TRUE){

  data %>%
    tibble::as_tibble() %>%
    dplyr::mutate_each(dplyr::funs(scale(., center = center,
                                         scale = scale)), ...) %>%
    dplyr::mutate_each(dplyr::funs(as.vector), ...)

}

