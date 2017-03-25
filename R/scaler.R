
#   ____________________________________________________________________________
#   scaler                                                                  ####

#' @title Scale multiple columns at once
#' @description Center and/or scale multiple columns of a dataframe.
#'
#'  \strong{scaler} is designed to work with \link[magrittr]{\%>\%} pipelines.
#'
#'  \strong{scaler_fit} returns fit_object with information used to
#'  transform data.
#'
#'  \strong{scaler_transform} scales data based on the information
#'  in the fit_object.
#'
#'  \strong{scaler_invert} inverts scaling based on the information
#'  in the fit_object.
#'
#'  \strong{scaler_} and \strong{scaler_fit_} are standard evalution versions.
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
#' @param center Logical or logical vector with element for each included column.
#' @param scale Logical or logical vector with element for each included column.
#' @param fit_object Object from scaler_fit used to transform data
#' @return Tibble where selected columns have been scaled.
#' @details Scales each specified column and converts to tibble.
#' @aliases scaler_, scaler_fit, scaler_fit_, scaler_transform, scaler_invert
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
#' ## Fit / Transform / Invert
#'
#' # Fit scaler
#' fitted_scaler <- scaler_fit(df, 1:2)
#'
#' # Transform data
#' scaled_df <- scaler_transform(df, fitted_scaler)
#'
#' # Invert scaling
#' scaler_invert(scaled_df, fitted_scaler)
#'
#' ## Setting scale and center for each column
#'
#' scaler(df, center = c(TRUE, FALSE),
#'        scale = c(FALSE, TRUE))
#'
#' ## Standard evalutation versions
#'
#' scaler_(df, cols = c('b'))
#' scaler_fit_(df, cols = c('a'))
#'
#' @importFrom dplyr '%>%'
scaler <- function(data, ..., center = TRUE, scale = TRUE){

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

  scaler_(data = data,
                 cols = cols,
                 center = center,
                 scale = scale
                 )

}


#   ____________________________________________________________________________
#   scaler_                                                                 ####

#' @rdname scaler
#' @export
scaler_ <- function(data, cols=NULL, center = TRUE, scale = TRUE){

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

  # Fit scaler
  fitted <- scaler_fit_(data = data,
                       cols = cols,
                       center = center,
                       scale = scale)


  # Scale data with fit_object
  scaled <- scaler_transform(data = data,
                             fit_object = fitted)

  return(scaled)

}


#   ____________________________________________________________________________
#   scaler_fit                                                              ####

## Create fitted scaler object that holds the
## attributes mean, sd, center, scale
## Create transform function for transforming
## new data by the same attributes

#' @rdname scaler
#' @export
scaler_fit <- function(data, ..., center = TRUE, scale = TRUE){

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

  scaler_fit_(data = data,
          cols = cols,
          center = center,
          scale = scale)

}


#' @rdname scaler
#' @export
scaler_fit_ <- function(data, cols = NULL, center = TRUE, scale = TRUE){

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

  # Center and Scale should either be a scalar or a vector the length
  # of cols
  stopifnot(length(center) == 1 | length(center) == length(cols),
            length(scale) == 1 | length(center) == length(scale))

  summaries <- plyr::ldply(cols, function(col){

    data.frame(column = col, mean = mean(data[[col]]), sd = sd(data[[col]]))

  }) %>%

    dplyr::mutate(center = center,
           scale = scale) %>%

    tibble::as_tibble()

  return(summaries)


}


#   ____________________________________________________________________________
#   scaler_transform                                                        ####

#' @rdname scaler
#' @export
scaler_transform <- function(data, fit_object){

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

  transform.scaler(data, fit_object, FUN = scale_single)

}

#   ____________________________________________________________________________
#   scaler_invert                                                           ####

#' @rdname scaler
#' @export
scaler_invert <- function(data, fit_object){

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

  transform.scaler(data, fit_object, FUN = invert_scale_single)

}


#   ____________________________________________________________________________
#   helpers                                                                 ####


scale_single <- function(col, mean, sd, center, scale){

  # Perform centering if specified
  if(isTRUE(center)){

    col <- col - mean

  }

  # Perform scaling if specified
  if(isTRUE(scale)){

    col <- col / sd

  }

  # Return column
  return(col)

}


invert_scale_single <- function(col, mean, sd, center, scale){

  # Invert scaling if specified
  if(isTRUE(scale)){

    col <- col * sd

  }

  # Invert centering if specified
  if(isTRUE(center)){

    col <- col + mean

  }



  # Return column
  return(col)

}


get_dots_cols <- function(data, ...){

  #
  # Get column names from dots
  # If cols is missing, get all
  # column names in data
  #

  if (missing(...)){

    cols <- colnames(data)

  } else {

    cols <- data %>%
      dplyr::select(...)

    cols <- colnames(cols)

  }

  return(cols)

}


transform.scaler <- function(data, fit_object, FUN){

  #
  # Transforms data using FUN
  #

  transformed <- plyr::llply(colnames(data), function(col){

    FUN(data[[col]],
        fit_object[['mean']][fit_object[['column']] == col],
        fit_object[['sd']][fit_object[['column']] == col],
        fit_object[['center']][fit_object[['column']] == col],
        fit_object[['scale']][fit_object[['column']] == col])

  }) %>% as.data.frame()

  colnames(transformed) <- colnames(data)

  transformed %>%
    tibble::as_tibble() %>%
    return()

}


convert_and_name_vector <- function(data, vector_name){

  # First check if object had no name
  # This will mean that vector name is c(...)
  # So we check using regex
  if (grepl("c(", vector_name, fixed = T)){

    vector_name <- NULL

  }

  # Convert data to tibble with colname "x"
  data <- tibble::tibble(x = data)

  # If original vector had a name
  # Set colname to that
  if (!is.null(vector_name)){
    colnames(data) <- vector_name
  }

  return(data)

}
