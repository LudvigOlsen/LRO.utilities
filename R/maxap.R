
#' Finding maximum a posteriori (MAP) and HPDI from samples.
#'
#' Given a dataframe with samples for parameters,
#'  find the MAP and HPDI.
#'
#' @param data Dataframe with samples.
#'  A column for each parameter
#' @param pars Names of parameters (Character).
#' @param HPDI_prob Probability for highest posterior density interval
#' @export
#' @importFrom dplyr '%>%'
maxap <- function(data, pars = c(), HPDI_prob = 0.89){

  plyr::ldply(1:length(pars), function(p){

    # Get highest posterior density intervals (HPDI)
    # Ugly hack, should be rewritten
    HPDI_ <- rethinking::HPDI(data[[pars[p]]], prob = HPDI_prob) %>%
      broom::tidy() %>% .[2] %>% t() %>% tibble::as_tibble()
    HPDI_names <- c(paste0('[', HPDI_prob*100, '%'),
                    paste0(HPDI_prob*100, '%', ']'))
    colnames(HPDI_) <- HPDI_names
    rownames(HPDI_) <- NULL

    data.frame('Parameter' = pars[p],
               'MAP' = density(data[[pars[p]]])$x[which(
                 density(data[[pars[p]]])$y==max(
                   density(data[[pars[p]]])$y))]) %>%
      tibble::as_tibble() %>%
      dplyr::bind_cols(HPDI_)

  })

}


