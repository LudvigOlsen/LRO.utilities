
#' Finding maximum a posteriori (MAP) and HPDI from samples.
#'
#' Given a dataframe with samples for parameters,
#'  find the MAP and HPDI.
#'
#' @param data Dataframe with samples.
#'  A column for each parameter
#' @param pars Names of parameters (Character).
#' @param HPDI_prob Probability for highest posterior density interval (0-1).
#' @param digits How many digits to round to (Whole number).
#' @export
#' @importFrom dplyr '%>%'
maxap <- function(data, pars = c(), HPDI_prob = 0.89, digits = NULL){

  plyr::ldply(1:length(pars), function(p){

    # Get highest posterior density intervals (HPDI)
    # Ugly hack, should be rewritten
    HPDI_ <- rethinking::HPDI(data[[pars[p]]], prob = HPDI_prob) %>%
      broom::tidy() %>% .[2] %>% t() %>% tibble::as_tibble()
    HPDI_names <- c(paste0('[', HPDI_prob*100, '%'),
                    paste0(HPDI_prob*100, '%', ']'))
    colnames(HPDI_) <- HPDI_names
    rownames(HPDI_) <- NULL

    df <- data.frame('Parameter' = pars[p],
               'MAP' = density(data[[pars[p]]])$x[which(
                 density(data[[pars[p]]])$y==max(
                   density(data[[pars[p]]])$y))]) %>%
      tibble::as_tibble() %>%
      dplyr::bind_cols(HPDI_)

    if (is.null(digits)) {
      return(df)
    } else {
      stopifnot(is.numeric(digits))
      df[,-1] <-round(df[,-1], digits = digits)
      return(df)
    }

  })

}


