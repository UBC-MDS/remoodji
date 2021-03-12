library(remoodji)
library(tidytext)
library(tidyverse)
library(textdata)
library(dplyr)
library(testthat)
library(emojifont)

# test function for exception handling for sentiment_df function
test_that("Exception handlings for sentiment_df function are failing", {
  # test exception handling for sentiment_df function
  expect_error(remoodji::sentiment_df(123, "all"))
  expect_error(remoodji::sentiment_df("I am happy", 123))
  expect_error(remoodji::sentiment_df("I am happy", "Happy"))
})

# test function for exception handlings for sentiment_plot function
test_that("Exception handlings for sentiment_plot function are failing", {
  # test exception handling for sentiment_plot function
  expect_error(remoodji::sentiment_plot(123, "all"))
  expect_error(remoodji::sentiment_plot("I am happy", 123))
  expect_error(remoodji::sentiment_plot("I am happy", "Happy"))
  expect_error(remoodji::sentiment_plot("I am happy", "joy", width="happy"))
  expect_error(remoodji::sentiment_plot("I am happy", "joy", height="happy"))
})


# test function for the sentiment_df function
test_that("Dataframe outputs are correct", {
  # test exception handling for sentiment_df function
  output_df <- remoodji::sentiment_df("I sorry, is bad, the happy, and excited", "all")
  expect_true("bad" %in% output_df$word & "excited" %in% output_df$word & "happy" %in% output_df$word) # there should be only 3 emotion words in the input text
  expect_equal(ncol(output_df), 5)                                                                     # there should be 5 columns in the output
  expect_equal(output_df$num_of_word[[1]], 1)                                                          # for each word, there should be only one word count
  expect_true(is_tibble(remoodji::sentiment_df("I am happy")))
})


#' test_that function is sentiment_plot
test_that('Plot should use geom_bar and map x to x-axis, and y to y-axis and fill to fill.', {

  test_text <- "I am happy and smiling and jumping and cheering and dancing, but still angry and crying inside."

  sentiment_plot_sentiment <- remoodji::sentiment_plot(test_text, sentiment_input = "sentiment")
  sentiment_plot_all <- remoodji::sentiment_plot(test_text, sentiment_input = "all")
  sentimentplot <- remoodji::sentiment_plot(test_text, sentiment_input = "joy")

  expect_true("GeomBar" %in% c(class(sentiment_plot_sentiment$layers[[1]]$geom)))
  expect_true("reorder(sentiment, sentiment_count)" == rlang::get_expr(sentiment_plot_sentiment$mapping$x))
  expect_true("sentiment_count" == rlang::get_expr(sentiment_plot_sentiment$mapping$y))
  expect_true("sentiment" == rlang::get_expr(sentiment_plot_sentiment$mapping$fill))

  expect_true("GeomBar" %in% c(class(sentiment_plot_all$layers[[1]]$geom)))
  expect_true("reorder(word, word_count)" == rlang::get_expr(sentiment_plot_all$mapping$x))
  expect_true("word_count" == rlang::get_expr(sentiment_plot_all$mapping$y))
  expect_true("sentiment" == rlang::get_expr(sentiment_plot_all$mapping$fill))

  expect_true("GeomBar" %in% c(class(sentimentplot$layers[[1]]$geom)))
  expect_true("reorder(word, word_count)" == rlang::get_expr(sentimentplot$mapping$x))
  expect_true("word_count" == rlang::get_expr(sentimentplot$mapping$y))
  expect_true("word" == rlang::get_expr(sentimentplot$mapping$fill))
})

# test function for exception handlings for textsentiment_to_emoji function
test_that("Exception handlings for textsentiment_to_emoji  function are failing", {
  # test exception handling for sentiment_plot function
  expect_error(remoodji::textsentiment_to_emoji(123))
  expect_error(remoodji::textsentiment_to_emoji("I am sad",123))
  expect_error(remoodji::textsentiment_to_emoji("",data.frame(words=c("hi"),sentiment=c("fear"))))
})

# test function for correct output for textsentiment_to_emoji function
test_that("Wrong output for textsentiment_to_emoji function", {
  # test exception handling for sentiment_plot function
  expect_equal(remoodji::textsentiment_to_emoji("I am hi",data.frame(word=c("hi"),sentiment=c("fear"))), emojifont::emoji('fearful'))
  expect_null(remoodji::textsentiment_to_emoji("",data.frame(word=c("hi"),sentiment=c("fear"))))
})

