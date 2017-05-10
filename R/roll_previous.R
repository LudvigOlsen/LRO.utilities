
#   __________________ #< 485fa24b370d3174d33c3b044de4fe91 ># __________________
#   roll_previous                                                           ####

#' @title Apply rolling functions to previous rows
#' @description Wrapper for zoo::rollapply for
#'  applying a function to rolling windows and getting
#'  the result of the previous window.
#'  Appends NAs at start only.
#' @param v Vector.
#' @param width Number of previous row to apply function to.
#' @param FUN Function to apply.
#'  Must be compatible with \link[zoo]{rollapply}.
#' @examples
#'
#' # Attach package
#' library(LRO.utilities)
#'
#' # Create dataframe
#' df <- data.frame('round' = c(1,2,3,4,5,6,7,8,9,10),
#'                  'score' = c(5,3,4,7,6,5,2,7,8,6))
#'
#' # For each row we find the mean score of the previous 2 rounds
#' df$mean_prev_score = roll_previous(df$score, width = 2, FUN = mean)
#' @export
roll_previous <- function(v, width = 2, FUN = mean){
  nas <- rep(NA, width)
  rolls <- zoo::rollapply(v, width = width, FUN = FUN)
  return(append(nas, rolls)[1:length(v)])
}
