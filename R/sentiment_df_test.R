library(tidytext)
library(tidyverse)
library(dplyr)
library(textdata)
get_sentiments("nrc")

text = "I am angry scared angry mad smiling and happy and happy and happy and I have sadness" # remove for function
#text = "This week, show us a smile (yours or someone else's), make us smile, or both. Share a photo of something that has brought a moment of joy into your life recently, or focus on the outcome of that joy. If you're not feeling particularly cheerful at the moment — it's still 2018, after all — no need to fake your way into the challenge, either. Smiles come in all shades and flavors, including the half-hearted, tired, bitter, and resigned (to name a few). So whether the emotions you channel in your photo are full of cheer or not, I can't wait to see your take on this theme."

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

sentiment_input = "trust"

if (sentiment_input == "all") {
  tidy_df
} else{
  tidy_df <- filter(tidy_df, sentiment == sentiment_input)
  tidy_df
}

############################################################### sentiment_plot

sentiment_word = "sentiment"

if (sentiment_word == "sentiment") {
  join_df <- group_by(tidy_df, sentiment)
  join_df <- summarise(join_df, sentiment_count = sum(num_of_word))
  sentiment_plot <- ggplot(join_df, aes(x = reorder(sentiment, sentiment_count), y = sentiment_count, fill = sentiment)) +
    geom_bar(stat = 'identity') +
    ggtitle(paste0("Sentiments In Text")) +
    xlab("Sentiment") +
    ylab("Sentiment Count") +
    theme(legend.position = "none")
  sentiment_plot

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
  sentiment_plot

} else {
  sentiment_df <- filter(tidy_df, sentiment == sentiment_word) # filter for input sentiment
  sentiment_df <- group_by(sentiment_df, word)
  sentiment_df <- summarise(sentiment_df, word_count = mean(num_of_word), sentiment = sentiment)

  if (nrow(sentiment_df) > 10){
    sentiment_df <- sentiment_df[0:10,] # slice top 10
  }

  sentiment_plot <- ggplot(sentiment_df, aes(x = reorder(word, word_count), y = word_count, fill = word)) +
    geom_bar(stat = 'identity') +
    ggtitle(paste0("Top 10 ", sentiment_word, " Words")) +
    xlab("Word") +
    ylab("Word Count") +
    theme(legend.position = "none")
  sentiment_plot
}



