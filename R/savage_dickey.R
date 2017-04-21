
#   __________________ #< 89d7a9f84fe8faae45b2ec8cd64cbcb0 ># __________________
#   Savage Dickey Bayes Factor                                              ####

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
#' @param Q Point on x-axis for calculating Bayes factor.
#' @param xlab Label for x-axis
#' @param ylab Label for y-axis
#' @param plot Create density plot (Logical)
#' @param print_plot (Logical)
#' @return List with ggplot2 object (optional), BF10 and BF01
#' @author Benjamin Hugh Zachariae
#' @author Ludvig Renbo Olsen
#' @export
#' @examples
#' # Sampling from two different gaussian distributions
#' prior <- rnorm(1000, mean=0, sd=1)
#' posterior <- rnorm(1000, mean=2, sd=2)
#'
#' # Calculating BF and generating plot of the given distributions
#' s_d <- savage_dickey(posterior, prior, Q = 0, plot = TRUE)
#' @importFrom polspline dlogspline logspline
#' @importFrom dplyr '%>%'
savage_dickey <- function(post, prior, Q,
                          xlab = 'Parameter values',
                          ylab = 'Density',
                          plot = TRUE,
                          print_plot = FALSE){


##  .................. #< e3616350b525535a2bfdf402f2e6b31e ># ..................
##  Check arguments                                                         ####


  stopifnot(is.logical(plot),
            is.logical(print_plot),
            is.numeric(post) | is.integer(post),
            is.numeric(prior) | is.integer(prior),
            is.numeric(Q) | is.integer(Q))

  if ( !isTRUE(plot) && isTRUE(print_plot)){
    message("'print_plot' has no effect when 'plot' is FALSE")
  }


##  .................. #< fc3ac4bea4b5054bdda78ec4479a8730 ># ..................
##  Bayes factor                                                            ####


  BF10 <-
    dlogspline(Q, logspline(post)) /
    dlogspline(Q,logspline(prior))
  BF01 <-
    dlogspline(Q, logspline(prior)) /
    dlogspline(Q,logspline(post))


##  .................. #< 597ccd506c1a6e9cb52cd7fca23de8d8 ># ..................
##  Plot                                                                    ####


  if (isTRUE(plot)){

    # Gather posterior and prior
    results <- data.frame("posterior" = post,
                          "prior" = prior )

    plot_ <- results %>%
      tidyr::gather("postprior", "gathered") %>%
      ggplot2::ggplot() +
      ggplot2::geom_density(ggplot2::aes(gathered, fill = postprior), alpha = .5) +
      ggplot2::labs(x=xlab, y=ylab)

    if(isTRUE(print_plot)){
      print(plot_)
    }


##  .................. #< 4310b4db83cb41a819f09cb31930189a ># ..................
##  Return list                                                             ####

    return(list("post_prior_plot" = plot_, "BF10" = BF10, "BF01" = BF01))

  } else {

    return(list("BF10" = BF10, "BF01" = BF01))
  }


}
