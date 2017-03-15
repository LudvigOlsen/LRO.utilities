
#   __________________ #< a71cc822eeebaccb5828de4c16a03916 ># __________________
#   helper: count_char_occurences                                           ####

count_char_occurrences <- function(char, s) {

  ##  ............................................................................
  ##  Description                                                             ####

  #
  # Count how many times a char is in a string
  # Uli Köhler at
  # https://techoverflow.net/2012/11/10/r-count-occurrences-of-character-in-string/
  #

  ##  .................. #< 918f59c557502d39a263579fa839a984 ># ..................
  ##  Count char occurences                                                   ####

  s2 <- gsub(char,"",s)
  return (nchar(s) - nchar(s2))
}

