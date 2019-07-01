# Package stats
# Wrapper for dlstats::cran_stats

dls <- function(package="groupdata2") {

  tryCatch({statistics <- dlstats::cran_stats(package)},
           error = function(e){
             if ("character string is not in a standard unambiguous format" %in% e){
               stop(paste0("The package does not seem to exist? Got error:",
                           "'character string is not in a standard unambiguous format'"))
             }
           })

  downs <- statistics$downloads
  of_previous_month <- (downs[length(downs)]/downs[length(downs)-1])*100
  of_mean_all_previous <- (downs[length(downs)] / mean(downs[1:(length(downs)-1)])) * 100


  total_dls <- paste0("Total downloads: ",sum(downs))
  last_month <- paste0("Last month: ",downs[length(downs)], " downloads, ",
               ifelse(of_previous_month>100,
                      paste0(round(of_previous_month-100), "% increase"),
                      paste0(round(100-of_previous_month), "% decrease")),
               " from the previous month, ",
               ifelse(of_mean_all_previous>100,
                      paste0(round(of_mean_all_previous-100), "% increase"),
                      paste0(round(100-of_mean_all_previous), "% decrease")),
               " from the mean of all previous months.")

  stats_plot <- ggplot2::ggplot(statistics, ggplot2::aes(end, downloads, group=package, color=package)) +
    ggplot2::geom_line() + ggplot2::geom_label(ggplot2::aes(label=downloads)) +
    ggplot2::theme_bw()

  return(list(knitr::kable(statistics), total_dls, last_month, stats_plot))

}

