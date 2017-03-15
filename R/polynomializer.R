

#   __________________ #< 23b44618389c33a21e97dd5516d4bdc6 ># __________________
#   Polynomializer                                                          ####

#' @title Create exponentiated vectors.
#' @description Exponentiate vectors to make polynomials of
#'  degree 2 to \code{degree}.
#'
#'  E.g. create columns \code{v^2, v^3, v^4...}
#' @author Ludvig Renbo Olsen, \email{r-pkgs@ludvigolsen.dk}
#' @export
#' @param data Dataframe or Vector.
#' @param cols Names of columns to "polynomialize". (Character Vector)
#'
#'  Only specify if data is dataframe.
#' @param degree Degree of the polynomial. Up to and including.
#' @param suffix String to go after original name of column. Always followed by
#'  the exponent used. (Character)
#' @param up_to Create polynomials up to \code{degree}. (Logical)
#' @return Dataframe with added exponentiated columns.
#' @export
#' @importFrom dplyr '%>%'
polynomializer <- function(data, cols=NULL, degree = 3,
                           suffix='_', up_to = TRUE){

##  ............................................................................
##  Description                                                             ####

  #
  # Add polynomials from 2nd degree up to 'degree'
  # That is v^2, v^3, v^4, etc.
  # Takes a vector or dataframe.
  # .. If dataframe, specify which columns to make polynomials for in 'cols'
  # Returns dataframe with added columns
  #
  # If up_to is FALSE
  # .. only the vector^degree is created for each column in cols.
  #

##  .................. #< 16047993a8ebcce4d66475b74ccc9583 ># ..................
##  Check input                                                             ####

  if(is.vector(data) && is.null(cols)){

    # Usually we wouldn't want more degrees than elements in data
    if (length(data) < degree){

      warning("degree is larger than length of data")
    }

    # Get name of passed vector object
    v_name <- deparse(substitute(data))

    # Make v a one-column dataframe
    data <- as.data.frame(data)

    # Replace the name 'v' with the original vectors name
    data <- rename_col(data, 'data', v_name)

    # Add column to cols
    cols <- c(v_name)

  } else if (is.vector(data) && !is.null(cols)){

    stop("data is vector, argument 'cols' must be NULL")

  } else if (is.data.frame(data) && !is.null(cols)) {

    # Usually we wouldn't want more degrees than elements in data
    if (nrow(data) < degree){

      message("degree is larger than number of rows in data")

    }

  } else if (is.data.frame(data) && is.null(cols)) {

    stop("data is dataframe, argument 'cols' must be specified")

  } else {

    stop("data must be of class vector or dataframe")
  }

##  .................. #< 38c7463dd0af49f4cceeb76d7b36a598 ># ..................
##  Create polynomial columns                                               ####

  # For every column, get polynomials and combine in 1 dataframe
  data_polynomialized <- plyr::llply(cols, function(col){

    # Create polynomials
    polys <- create_polynomials(data[[col]], degree=degree, up_to = up_to)

    if (isTRUE(up_to)){

      # Change column names
      colnames(polys) <- paste(col, suffix, 2:degree, sep="")

    } else {

      # Change column name
      colnames(polys) <- paste(col, suffix, degree, sep="")

    }

    # Combine original data with polynomials
    polys <- cbind(data[[col]], polys)

    # Rename first column
    colnames(polys)[1] <- col

    return(list(polys))

  })

##  .................. #< 7cc004e6e0fcb6ecb9b70f7615dd5db8 ># ..................
##  Merge and sort                                                          ####

  # Get column names for data
  data_col_names <- colnames(data)

  # Create temporary sorting index as merge sometimes
  # change the order of rows
  data[['polyn_temp_index']] <- c(1:nrow(data))

  # Merge data
  merged_data <- merge(data, data_polynomialized)

  # Get column names of merged data
  merged_col_names <- colnames(merged_data)

  # Find the created columns
  not_poly_names <- merged_col_names[merged_col_names %ni% data_col_names]

  # Set a list of column names in the wanted order
  column_order <- c(data_col_names, not_poly_names)

  # Sort data and return
  merged_data %>%
    dplyr::arrange(polyn_temp_index) %>%
    dplyr::select_(.dots = column_order) %>%
    dplyr::select(-c(polyn_temp_index)) %>%
    return()


}


#   __________________ #< 1e4f8bcb8a743037e2f6155f3b7f2900 ># __________________
#   helper: create_polynomials                                              ####

#' @importFrom dplyr '%>%'
create_polynomials <- function(v, degree=3, up_to = TRUE){

##  ............................................................................
##  Description                                                             ####

  #
  # Creates polynomials for a given vector
  # Returns dataframe with all polynomials / exponentiations from 2nd degree
  # polynomial up to and including the specified degree.
  # That is v^2, v^3, v^4, etc.
  #
  # If up_to is FALSE, v^degree is returned as column in dataframe.
  #

##  .................. #< e2d40459bdcdd4a0f2e1c9dd5094cfd1 ># ..................
##  Create polynomials                                                      ####

  if (isTRUE(up_to)){

    polys <- plyr::llply((2:degree), function(i){

      return(v^i)

    }) %>% as.data.frame()

    colnames(polys) <- paste("X", 2:degree, sep="")

  } else {

    polys <- v^degree %>%
      as.data.frame()

    colnames(polys) <- paste("X", degree, sep="")

  }


##  .................. #< 5eb6b2d556dc2e1d95d193c37dca81f1 ># ..................
##  Return polynomials                                                      ####

  return(polys)
}

