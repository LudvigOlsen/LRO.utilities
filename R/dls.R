# Package stats
# Wrapper for adjustedcranlogs::adj_cran_downloads # previously dlstats::cran_stats

dls <- function(packages = c("groupdata2", "cvms"), from = "2016-01-01",
                to = lubridate::today(), n_comparison = 100, times = 1, # TODO times not used yet
                apply_kable = TRUE) {

  statistics <- download_stats(packages = packages, from = from, to = to, n_comparison = n_comparison)

  # Download multiple times to find more stable mindownloads
  # statistics <- plyr::ldply(seq_len(times), function(i){
  #   download_stats(packages = packages, from = from, to = to, n_comparison = n_comparison) %>%
  #     dplyr::mutate(iter = i)
  # })
  #
  # extra_statistics <- statistics %>%
  #   dplyr::filter(iter != 1) %>%
  #   dplyr::group_by(.data$package, .data$date) %>%
  #   dplyr::summarise_if(is.numeric, .funs = mean)
  #
  #

  stats_df <- statistics %>%
    dplyr::group_by(.data$package, month=lubridate::ceiling_date(date, "month")-1) %>%
    dplyr::summarise(min_downloads = sum(.data$mindownloads),
                     downloads = sum(.data$count),
                     adjusted_downloads = sum(.data$adjusted_downloads),
                     adjusted_total_downloads = max(.data$adjusted_total_downloads),
                     total_downloads = max(.data$total_downloads),
                     updates = sum(.data$updateday)) %>%
    dplyr::filter(.data$downloads > 0)

  current_month <- stats_df %>%
    dplyr::group_by(.data$package) %>%
    dplyr::filter(dplyr::row_number() == dplyr::n())

  past_months <- stats_df %>%
    dplyr::group_by(.data$package) %>%
    dplyr::filter(dplyr::row_number() != dplyr::n()) %>%
    dplyr::summarise(avg_downloads = mean(downloads),
                     avg_adj_downloads = mean(adjusted_downloads))

  current_month <- current_month %>%
    dplyr::left_join(past_months, by = "package") %>%
    dplyr::mutate(direction_downloads = ifelse(avg_downloads > downloads, "down", "up"),
                  direction_adj_downloads = ifelse(avg_adj_downloads > adjusted_downloads, "down", "up"),
                  from_mean_of_the_past = round(abs(downloads / avg_downloads) * 100),
                  from_mean_of_the_past_adj = round(abs(adjusted_downloads / avg_adj_downloads)  * 100),
                  change = stringr::str_c(from_mean_of_the_past, direction_downloads, sep="% "),
                  change_adj = stringr::str_c(from_mean_of_the_past_adj, direction_adj_downloads, sep="% ")) %>%
    dplyr::select(-c(direction_downloads, direction_adj_downloads,
                     from_mean_of_the_past, from_mean_of_the_past_adj)) %>%
    dplyr::rename(count = downloads,
                  adj_count = adjusted_downloads,
                  total = total_downloads,
                  adj_total = adjusted_total_downloads,
                  avg = avg_downloads,
                  adj_avg = avg_adj_downloads) %>%
    dplyr::select(package, total, adj_total, count, adj_count,
                  change, change_adj, avg, adj_avg, min_downloads, updates)

  past_three_days <- statistics %>%
    dplyr::group_by(.data$package) %>%
    dplyr::filter(dplyr::row_number() %in% c(dplyr::n() - 1:3))

  stats_plot <- stats_df %>%
    ggplot2::ggplot(ggplot2::aes(month, adjusted_downloads,
                                 group = package, color = package)) +
    ggplot2::geom_line() +
    ggplot2::geom_label(ggplot2::aes(label = paste0(adjusted_downloads," (", downloads, ")")),
                        label.size = 0.03) +
    ggplot2::theme_bw() +
    ggplot2::labs(x = "Month", y = "# Adjusted Downloads")

  if (isTRUE(apply_kable)){
    return(list(knitr::kable(stats_df), "past_three_days" = past_three_days, "this_month" = current_month, stats_plot))
  } else {
    return(list(stats_df, "past_three_days" = past_three_days, "this_month" = current_month, stats_plot))
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
             "this_month" = downs[length(downs)],
             "from_previous_month" = ifelse(of_previous_month>100,
                                            paste0(round(of_previous_month-100), "% increase"),
                                            paste0(round(100-of_previous_month), "% decrease")),
             "from_mean_of_the_past" = ifelse(of_mean_all_previous>100,
                                              paste0(round(of_mean_all_previous-100), "% increase"),
                                              paste0(round(100-of_mean_all_previous), "% decrease"))
             )
}

download_stats <- function(packages, from, to, n_comparison){

  # Download stats
  statistics <- tryCatch({
    adjustedcranlogs::adj_cran_downloads(
      packages = packages,
      from = from,
      to = to,
      numbercomparison = n_comparison
    )
  },
  error = function(e) {
    if ("character string is not in a standard unambiguous format" %in% e) {
      stop(
        paste0(
          "The package does not seem to exist? Got error:",
          "'character string is not in a standard unambiguous format'"
        )
      )
    } else (
      stop(e)
    )
  })

  statistics

}
