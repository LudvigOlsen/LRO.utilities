#' @title Rename single column by name
#' @description Change name of a single column in a dataframe by old name instead of position.
#' @param data Dataframe.
#' @param old_name Name of column to rename (Character).
#' @param new_name Desired name of column (Character).
#' @return Dataframe with modified name of specified column.
#' @export
rename_col <- function(data, old_name, new_name){

  #
  # Replaces name of column in dataframe
  #
  colnames(data)[names(data) == old_name] <- new_name
  return(data)

}


