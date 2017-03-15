rename_col <- function(data, old_name, new_name){

  #
  # Replaces name of column in dataframe
  #
  colnames(data)[names(data) == old_name] <- new_name
  return(data)

}
