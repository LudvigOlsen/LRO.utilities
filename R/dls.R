# Package stats
# Wrapper for dlstats::cran_stats

dls <- function(packages=c("groupdata2","cvms"), apply_kable = TRUE) {

  tryCatch({statistics <- dlstats::cran_stats(packages)},
           error = function(e){
             if ("character string is not in a standard unambiguous format" %in% e){
               stop(paste0("The package does not seem to exist? Got error:",
                           "'character string is not in a standard unambiguous format'"))
             }
           })

  stats_df <- plyr::ldply(packages, function(p){
    statistics %>%
      dplyr::filter(package == p) %>%
      package_stats_(pgk = p)
  })

  stats_plot <- ggplot2::ggplot(statistics, ggplot2::aes(end, downloads, group=package, color=package)) +
    ggplot2::geom_line() + ggplot2::geom_label(ggplot2::aes(label=downloads)) +
    ggplot2::theme_bw()

  if (isTRUE(apply_kable)){
    return(list(knitr::kable(statistics), stats_df, stats_plot))
  } else {
    return(list(statistics, stats_df, stats_plot))
  }


}

package_stats_ <- function(stats_df, pgk){

  downs <- stats_df$downloads

  if (length(downs) == 1){
    warning(paste0(pgk, ": No statistics from previous months."))
    of_previous_month <- downs[length(downs)]*100
    of_mean_all_previous <- of_previous_month
  } else {
    if (sum(downs[1:(length(downs)-1)]) == 0){
      warning(paste0(pgk, ": All previous months had 0 downloads."))
      of_mean_all_previous <- downs[length(downs)] * 100
    } else {
      if (downs[length(downs)-1] == 0){
        warning(paste0(pgk, ": Previous month had 0 downloads."))
        of_previous_month <- downs[length(downs)]*100
      } else {
        of_previous_month <- (downs[length(downs)]/downs[length(downs)-1])*100
      }
      of_mean_all_previous <- (downs[length(downs)] / mean(downs[1:(length(downs)-1)])) * 100
    }
  }


  data.frame("total_downloads" = sum(downs),
             "last_month" = downs[length(downs)],
             "from_previous_month" = ifelse(of_previous_month>100,
                                            paste0(round(of_previous_month-100), "% increase"),
                                            paste0(round(100-of_previous_month), "% decrease")),
             "from_mean_of_the_past" = ifelse(of_mean_all_previous>100,
                                              paste0(round(of_mean_all_previous-100), "% increase"),
                                              paste0(round(100-of_mean_all_previous), "% decrease"))
             )
}
