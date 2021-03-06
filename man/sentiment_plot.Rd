% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/remoodji.R
\name{sentiment_plot}
\alias{sentiment_plot}
\title{Sentiment Plot Function}
\usage{
sentiment_plot(text, sentiment_input = "joy", width = 10, height = 10)
}
\arguments{
\item{text}{string: the input text for sentiment analysis}

\item{sentiment_input}{string (optional): the sentiment that the analysis focuses on. Defaults to "happy".}

\item{width}{integer (optional): the width of the output plot. Defaults to 10.}

\item{height}{integer (optional): the height of the output plot. Defaults to 10.}
}
\value{
graph: a plot that shows the top n sentiment words of the input text file
}
\description{
Generates a plot to show the top n sentiment words in the input text file.
}
