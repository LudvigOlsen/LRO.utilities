#' @title Counts frequencies of each character
#' @export
count_all_chars <- function(strings, char_vocab = NULL) {
  if (is.null(char_vocab)) char_vocab <- get_char_vocab(strings)

  count_df <- plyr::ldply(strings, function(s){
    count_all_chars_single(s, char_vocab)
  })

  count_df[ , order(names(count_df))] %>%
    dplyr::mutate(string = strings) %>%
    tibble::as_tibble()

}

count_all_chars_single <- function(string, char_vocab){

  chars_table <- create_chars_table(string)

  # Add the rest of the chars not in string to table
  missing_chars <- setdiff(char_vocab, names(chars_table))

  if (length(missing_chars) > 0){
    missing_char_table_elements <- rep(0, length(missing_chars))
    names(missing_char_table_elements) <- missing_chars
    chars_table <- c(chars_table, missing_char_table_elements)
  }

  tidyr::spread(stack(chars_table), key="ind", val="values")
}


get_char_vocab <- function(txt){
  chars_table <- create_chars_table(txt)
  names(chars_table)
}

create_chars_table <- function(txt){
  txt <- paste(txt, collapse = '')
  table(strsplit(txt, ""))
}

#
# create_chars_table(c("hej", "all", "jeg hedder hansi"))
# create_chars_table("hej alle")
#
# char_vocab <- get_char_vocab(c("hej", "all", "jeg hedder hansi"))
# count_all_chars(c("hej", "all", "jeg hedder hansi"))
