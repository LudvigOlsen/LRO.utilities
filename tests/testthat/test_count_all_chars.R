library(LRO.utilities)
library(tibble)
context("count_all_chars")

test_that("count_all_chars() works correctly", {

  txt <- c("my", "cat", "went", "to school")

  # Check create_chars_table
  chars_table <- create_chars_table(txt)
  chars_vocab = get_char_vocab(txt)
  expected_freqs <- c(1, 1,2,1,1,1,1,1,3,1,3,1,1)
  names(expected_freqs) <- c(" ", unlist(strsplit(c("a c e h l m n o s t w y"), " ")))

  expect_equal(stack(chars_table), stack(expected_freqs))

  counts <- count_all_chars(txt)
  counts_with_chars_vocab <- count_all_chars(txt, chars_vocab)

  expected_counts <- tibble(" " = c(0,0,0,1),
                            a = c(0,1,0,0),
                            c = c(0,1,0,1),
                            e = c(0,0,1,0),
                            h = c(0,0,0,1),
                            l = c(0,0,0,1),
                            m = c(1,0,0,0),
                            n = c(0,0,1,0),
                            o = c(0,0,0,3),
                            s = c(0,0,0,1),
                            t = c(0,1,1,1),
                            w = c(0,0,1,0),
                            y = c(1,0,0,0),
                            string = c("my", "cat", "went", "to school"))

  expect_equal(counts, expected_counts)
  expect_equal(counts_with_chars_vocab, expected_counts)


})
