# Rscript for functions

# Load libraries
library(tidytext)
library(tidyverse)
library(dplyr)
library(textdata)
library(emojifont)

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

  unique_sentiment <- c("sentiment", "all", "anger", "anticipation", "disgust", "fear", "joy", "sadness", "surprise", "trust", "positive", "negative")

  # exception
  if (!is.character(text) | !is.character(sentiment_input)){
    stop("Only strings are allowed for function input")
  }else if (!sentiment_input %in% unique_sentiment){
    stop("Input not in [all, anger, anticipation, disgust, fear, joy, sadness, surprise, trust, positive, negative]")
  }


  # make the words
  text_df <- dplyr::tibble(text)
  colnames(text_df) <- c("text")

  text_df

  text <- tidytext::unnest_tokens(text_df,word, text)

  # filter out stop words
  tidy_df <- dplyr::filter(text, !word %in% stop_words$word)

  # total words
  total_words <- nrow(tidy_df)

  # add the sentiment

  #nrc <- get_sentiments("nrc")
  nrc <- textdata::lexicon_nrc(manual_download = FALSE)
  tidy_df <- dplyr::inner_join(tidy_df, nrc, by = "word") # merge text and nrc together

  tidy_df <- dplyr::count(tidy_df, word, sentiment, sort = TRUE) # add the word count

  tidy_df$total_words <- total_words # total_words

  tidy_df$sentiment_percent <- (tidy_df$n / tidy_df$total_words) # total_words (i.e. 75% of anticipation comes from happy)

  colnames(tidy_df) <- c("word", "sentiment", "num_of_word", "total_words", "word_sent_percentage")

  tidy_df  <- dplyr::select(tidy_df, !total_words) # remove total words because we don't need it anymore

  join_df <- dplyr::group_by(tidy_df, sentiment)
  join_df <- dplyr::summarise(join_df, sentiment_count = sum(num_of_word))

  tidy_df <- dplyr::inner_join(tidy_df, join_df)

  if (sentiment_input == "all") {
    return(tidy_df)
  } else{
    tidy_df <- dplyr::filter(tidy_df, sentiment == sentiment_input)
    return(tidy_df)
  }
}


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
textsentiment_to_emoji <- function(text, sentiment_dataframe=NULL) {
  # testing text be a str type
  if (!is.character(text)){
    stop("Only strings are allowed for function input")
  }

  # If no dataframe is given use the results of sentiment_df
  if (is.null(sentiment_dataframe)) {
    sentiment_dataframe <- remoodji::sentiment_df(text)
  }

  if (!is.data.frame(sentiment_dataframe)){
    stop("sentiment_dataframe must be a dataframe!")
  }

  if(!"word" %in% colnames(sentiment_dataframe))
  {
    stop("sentiment_dataframe must column 'word'")
  }

  if(!"sentiment" %in% colnames(sentiment_dataframe))
  {
    stop("sentiment_dataframe must column 'sentiment'")
  }

  # Removing punctuations in string
  text <- gsub('[[:punct:] ]+',' ',text)

  # Add the emojis of each word one by one
  emojis <- c()

  words <- strsplit(text, " ")[[1]]
  for (word_to_change in words) {
    df_filtered <-  dplyr::filter(sentiment_dataframe,word==word_to_change)
    num_rows <- nrow(df_filtered)
    # If no sentiment exists for the word go to the next word
    if (num_rows==0) {
      next
    }
    # Because a word might have multiple emotions one will be chosen randomly.
    rand_row <- sample.int(num_rows,1)
    sentiment <- dplyr::pull(df_filtered,sentiment)
    sentiment <- sentiment[rand_row]
    # Add the word according to the sentiment
    if (sentiment == "anger") {
      emojis <- append(emojis,emojifont::emoji('rage'))
    } else if (sentiment == "anticipation") {
      emojis <- append(emojis,emojifont::emoji('sunglasses'))
    } else if (sentiment == "disgust") {
      emojis <- append(emojis,emojifont::emoji('mask'))
    } else if (sentiment == "fear") {
      emojis <- append(emojis,emojifont::emoji('fearful'))
    } else if (sentiment == "joy") {
      emojis <- append(emojis,emojifont::emoji('smile'))
    } else if (sentiment == "sadness") {
      emojis <- append(emojis,emojifont::emoji('cry'))
    } else if (sentiment == "surprise") {
      emojis <- append(emojis,emojifont::emoji('open_mouth'))
    } else if (sentiment == "trust") {
      emojis <- append(emojis,emojifont::emoji('wink'))
    } else if (sentiment == "positive") {
      emojis <- append(emojis,emojifont::emoji('heavy_plus_sign'))
    } else if (sentiment == "negative") {
      emojis <- append(emojis,emojifont::emoji('heavy_minus_sign'))
    }
  }
  emojis
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

  unique_sentiment <- c("sentiment", "all", "anger", "anticipation", "disgust", "fear", "joy", "sadness", "surprise", "trust", "positive", "negative")

  if (!is.character(text) | !is.character(sentiment_input)){
    stop("Only strings are allowed for function input")
  }else if (!sentiment_input %in% unique_sentiment){
    stop("Input not in [all, anger, anticipation, disgust, fear, joy, sadness, surprise, trust, positive, negative]")
  }else if (!is.numeric(width)){
    stop("Only integers are allowed for height input")
  }else if (!is.numeric(height)){
    stop("Only integers are allowed for width input")
  }

  tidy_df <- remoodji::sentiment_df(text, sentiment_input)
  sentiment_word <- sentiment_input

  if (sentiment_word == "sentiment") {
    join_df <- dplyr::group_by(tidy_df, sentiment)
    join_df <- dplyr::summarise(join_df, sentiment_count = sum(num_of_word))
    sentimentplot <- ggplot2::ggplot(join_df, aes(x = reorder(sentiment, sentiment_count), y = sentiment_count, fill = sentiment)) +
      geom_bar(stat = 'identity') +
      ggtitle(paste0("Sentiments In Text")) +
      xlab("Sentiment") +
      ylab("Sentiment Count") +
      theme(legend.position = "none")

  } else if (sentiment_word == "all") {
    all_df <- dplyr::group_by(tidy_df, word)
    all_df <- dplyr::summarise(all_df, word_count = mean(num_of_word), sentiment = sentiment)

    if (nrow(all_df) > 10){
      all_df <- all_df[0:10,] # slice top 10
    }

    sentimentplot <- ggplot2::ggplot(all_df, aes(x = reorder(word, word_count), y = word_count, fill = sentiment)) +
      geom_bar(stat = 'identity') +
      ggtitle(paste0("Top 10 ", sentiment_word, " Words")) +
      xlab("Word") +
      ylab("Word Count") +
      facet_wrap(~sentiment) +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))

  } else {
    sent_df <- dplyr::group_by(tidy_df, word)
    sent_df <- dplyr::summarise(sent_df, word_count = mean(num_of_word), sentiment = sentiment)

    if (nrow(sent_df) > 10){
      sent_df <- sent_df[0:10,] # slice top 10
    }

    sentimentplot <- ggplot2::ggplot(sent_df, aes(x = reorder(word, word_count), y = word_count, fill = word)) +
      geom_bar(stat = 'identity') +
      ggtitle(paste0("Top 10 ", sentiment_word, " Words")) +
      xlab("Word") +
      ylab("Word Count") +
      theme(legend.position = "none")
  }
  return(sentimentplot)
}

#' Counter Function
#'
#' Generates a summary dataframe of the input text which contains counts for characters, words, and sentences.
#'
#' @param text string: the input text for sentiment analysis
#'
#' @return data frame: a data frame that contains the summary statistics for character, word, and sentence count.
#'
#' @export
#' @examples
#' counter("I am very happy.")
counter <- function(text) {
  #Must be a character
  if (!is.character(text)){
    stop("Only strings are allowed for function input")
  }
  #Can't be NA
  if(is.na(text)){
    stop("Please input text")
  }
  #Can't be of length 0
  if(text == ""){
    stop("Please input text")
  }

  text_df <- dplyr::tibble(text=text)

  num_char <- nchar(text)

  num_words <- text_df %>%
    tidytext::unnest_tokens(word, text) %>%
    pull(word) %>%
    length()

  num_sentence <- text_df %>%
    tidytext::unnest_tokens(sentence, text, token="sentences") %>%
    pull(sentence) %>%
    length()

  counter_df <- dplyr::tibble("char_count" = num_char, "word_count" = num_words, "sentence_count" = num_sentence)
}
