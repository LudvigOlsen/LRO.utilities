#packages: polspline, dplyr, tidyr, ggplot2

savageDickey <- function(post, prior, Q, xlab="parameter values", printplot=TRUE){
  
  results <- data.frame("dposterior" = samples$BUGSoutput$sims.list[post], 
                        "dprior" = samples$BUGSoutput$sims.list[prior] )
  plot <- results %>% 
    gather("postprior", "gathered") %>%
    ggplot() +
    geom_density(aes(gathered, fill = postprior), alpha = .5) +
    labs(x=xlab)
  
  BF10 <- 
    dlogspline(Q, logspline(results[post])) / 
    dlogspline(Q,logspline(results[prior]))
  BF01 <- 
    dlogspline(Q, logspline(results[prior])) / 
    dlogspline(Q,logspline(results[post]))
  
  if(isTRUE(printplot)){
    print(plot)  
  }
  
  return(list("Postprior_plot"=plot, "BF10" = BF10, "BF01" = BF01))
  
}