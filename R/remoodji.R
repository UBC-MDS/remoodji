# Rscript for functions

# Load libraries
library(tidytext)
library(tidyverse)
library(dplyr)

#' Sentiment df Function
#'
#' Generates a sentiment analysis summary dataframe of the input text. The summary dataframe would include
#' the sentiment type, sentiment words, number of sentiment words, and highest sentiment percentage.
#'
#' @param text string: the input text for sentiment analysis
#' @param sentiment_input string (optional): the sentiment that the analysis focuses on, could be happy, angry, or sad etc. Defaults to "all".
#'
#' @return dataframe: a data frame that contains the summary of sentiment analysis
#' @export
#'
#'
sentiment_df <- function(text, sentiment_input="all") {

  # make the words
  text_df <- tibble(text)
  colnames(text_df) <- c("text")

  text_df

  text <- tidytext::unnest_tokens(text_df,word, text)

  # filter out stop words
  tidy_df <- dplyr::filter(text, !word %in% stop_words$word)

  # total words
  total_words <- nrow(tidy_df)

  # add the sentiment
  tidytext::get_sentiments("nrc")

  tidy_df <- inner_join(tidy_df, get_sentiments("nrc"), by = "word") # merge text and nrc together

  tidy_df <- count(tidy_df, word, sentiment, sort = TRUE) # add the word count

  tidy_df$total_words <- total_words # total_words

  tidy_df$sentiment_percent <- (tidy_df$n / tidy_df$total_words) # total_words (i.e. 75% of anticipation comes from happy)

  colnames(tidy_df) <- c("word", "sentiment", "num_of_word", "total_words", "word_sent_percentage")

  tidy_df  <- select(tidy_df, !total_words) # remove total words because we don't need it anymore

  join_df <- group_by(tidy_df, sentiment)
  join_df <- summarise(join_df, sentiment_count = sum(num_of_word))

  tidy_df <- inner_join(tidy_df, join_df)

  if (sentiment_input == "all") {
    return(tidy_df)
  } else{
    tidy_df <- filter(tidy_df, sentiment == sentiment_input)
    return(tidy_df)
  }
}

sentiment_df("I am happy")

#' Emoji Function
#'
#' Detect the word sentiments of a text and replace the with the matching emojis.
#'
#' @param text string: A text string containing english words
#' @param sentiment_dataframe data frame: A dataframe which contains word and key column which shows the sentiment of each word. Only supports
#'                                        the Happy, Sad, Suprise, Fear and Angry as keys. If no dataframe is given the results of sentiment_df
#'                                        function would be used
#'
#' @return string:  A string containing only emoji's with no words. The emojis are written in the CLDR short name format.
#' @export
#' @examples
#' textsentiment_to_emoji("I am very happy")
textsentiment_to_emoji <- function(text, sentiment_dataframe=NULL) {
}

#' Sentiment Plot Function
#'
#' Generates a plot to show the top n sentiment words in the input text file.
#'
#' @param text string: the input text for sentiment analysis
#' @param sentiment_input string (optional): the sentiment that the analysis focuses on. Defaults to "happy".
#' @param width integer (optional): the width of the output plot. Defaults to 10.
#' @param height integer (optional): the height of the output plot. Defaults to 10.
#'
#' @return graph: a plot that shows the top n sentiment words of the input text file
#' @export
#'
sentiment_plot <- function(text, sentiment_input = "joy", width=10, height=10) {

  tidy_df <- sentiment_df(text, sentiment_input)
  sentiment_word <- sentiment_input

  if (sentiment_word == "sentiment") {
    join_df <- group_by(tidy_df, sentiment)
    join_df <- summarise(join_df, sentiment_count = sum(num_of_word))
    sentiment_plot <- ggplot(join_df, aes(x = reorder(sentiment, sentiment_count), y = sentiment_count, fill = sentiment)) +
      geom_bar(stat = 'identity') +
      ggtitle(paste0("Sentiments In Text")) +
      xlab("Sentiment") +
      ylab("Sentiment Count") +
      theme(legend.position = "none")

  } else if (sentiment_word == "all") {
    all_df <- group_by(tidy_df, word)
    all_df <- summarise(all_df, word_count = mean(num_of_word), sentiment = sentiment)

    if (nrow(all_df) > 10){
      all_df <- all_df[0:10,] # slice top 10
    }

    sentiment_plot <- ggplot(all_df, aes(x = reorder(word, word_count), y = word_count, fill = sentiment)) +
      geom_bar(stat = 'identity') +
      ggtitle(paste0("Top 10 ", sentiment_word, " Words")) +
      xlab("Word") +
      ylab("Word Count") +
      facet_wrap(~sentiment) +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))

  } else {
    sent_df <- group_by(tidy_df, word)
    sent_df <- summarise(sent_df, word_count = mean(num_of_word), sentiment = sentiment)

    if (nrow(sent_df) > 10){
      sent_df <- sent_df[0:10,] # slice top 10
    }

    sentiment_plot <- ggplot(sent_df, aes(x = reorder(word, word_count), y = word_count, fill = word)) +
      geom_bar(stat = 'identity') +
      ggtitle(paste0("Top 10 ", sentiment_word, " Words")) +
      xlab("Word") +
      ylab("Word Count") +
      theme(legend.position = "none")
  }
  return(sentiment_plot)
}

#' Counter Function
#'
#' Generates a summary dataframe of the input text which contains counts for characters, words, and sentences.
#'
#' @param text string: the input text for sentiment analysis
#'
#' @return data frame: a data frame that contains the summary statistics for character, word, and sentence count.
#' @export
#' @examples
#' counter("I am very happy.")
counter <- function(text) {
}
