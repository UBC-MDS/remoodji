# Rscript for functions

#' Sentiment df Function
#'
#' Generates a sentiment analysis summary dataframe of the input text. The summary dataframe would include 
#' the sentiment type, sentiment words, number of sentiment words, and highest sentiment percentage.
#'
#' @param text string: the input text for sentiment analysis
#' @param sentiment string (optional): the sentiment that the analysis focuses on, could be happy, angry, or sad etc. Defaults to "all".
#'
#' @return dataframe: a data frame that contains the summary of sentiment analysis
#' @export
#'
sentiment_df <- function(text, sentiment="all") {
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
#' @examples
#' textsentiment_to_emoji("I am very happy")
textsentiment_to_emoji <- function(text, sentiment_dataframe=NULL) {
}

#' Sentiment Plot Function
#'
#' Generates a plot to show the top n sentiment words in the input text file.
#'
#' @param text string: the input text for sentiment analysis
#' @param sentiment string (optional): the sentiment that the analysis focuses on. Defaults to "happy".
#' @param width integer (optional): the width of the output plot. Defaults to 10.
#' @param height integer (optional): the height of the output plot. Defaults to 10.
#'
#' @return graph: a plot that shows the top n sentiment words of the input text file
#' @export
#' 
sentiment_plot <- function(text, sentiment = "Happy", width=10, height=10) {
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
#' text_counter("I am very happy.")
counter <- function(text) {
}
