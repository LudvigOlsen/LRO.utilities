
#' @title Calculate Bayes Factor
#' @description Creates plot of prior and posterior distributions and calculates the
#'  Bayes factor at the point of interest (Q).
#' @details Bayes factors are calculated using the \link[polspline]{polspline} package.
#'
#'  BF10 <- dlogspline(Q, logspline(post)) /
#'  dlogspline(Q,logspline(prior))
#'
#'  BF01 <- dlogspline(Q, logspline(prior)) /
#'  dlogspline(Q,logspline(post))
#' @param post Samples from posterior distribution (Numeric)
#' @param prior Samples from prior distribution (Numeric)
#' @param xlab Label for x-axis
#' @param ylab Label for y-axis
#' @param print_plot (Logical)
#' @param return_plot (Logical)
#' @return List with ggplot2 object (optional), BF10 and BF01
#' @author Benjamin Hugh Zachariae
#' @author Ludvig Renbo Olsen
#' @export
#' @importFrom polspline dlogspline logspline
#' @importFrom dplyr '%>%'
savage_dickey <- function(post, prior, Q,
                          xlab = 'Parameter values',
                          ylab = 'Density',
                          print_plot = FALSE,
                          return_plot = TRUE){

  # Gather posterior and prior
  results <- data.frame("posterior" = post,
                        "prior" = prior )

  plot <- results %>%
    tidyr::gather("postprior", "gathered") %>%
    ggplot2::ggplot() +
    ggplot2::geom_density(ggplot2::aes(gathered, fill = postprior), alpha = .5) +
    ggplot2::labs(x=xlab, y=ylab)

  BF10 <-
    dlogspline(Q, logspline(post)) /
    dlogspline(Q,logspline(prior))
  BF01 <-
    dlogspline(Q, logspline(prior)) /
    dlogspline(Q,logspline(post))

  if(isTRUE(print_plot)){
    print(plot)
  }

  if (isTRUE(return_plot)){

    return(list("Postprior_plot"=plot, "BF10" = BF10, "BF01" = BF01))
  } else {

    return(list("BF10" = BF10, "BF01" = BF01))
  }


}
