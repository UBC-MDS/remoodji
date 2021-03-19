
<!-- README.md is generated from README.Rmd. Please edit that file -->

# remoodji

<!-- badges: start -->

[![R-CMD-check](https://github.com/UBC-MDS/remoodji/workflows/R-CMD-check/badge.svg)](https://github.com/UBC-MDS/remoodji/actions)
[![codecov](https://codecov.io/gh/UBC-MDS/remoodji/branch/master/graph/badge.svg?token=7XPNSHR40J)](https://codecov.io/gh/UBC-MDS/remoodji)
<!-- badges: end -->

Remoodji is a text analysis package that focuses on sentiment analysis
in text files in quantitative and qualitative ways. Specifically, it is
used for determining what kind of underlying emotion your input text
gives off and quantitative analyses of your text (character, word, and
sentence count as well as visual and quantitative sentiment analysis).
The emotions analyzed include angry, sad, happy, and disgust. Another
core feature of Remoodji is it replaces words with emojis to provide the
user with a text file where it is easier to pick up on the emotions
being conveyed in a visually appealing snapshot view. This package can
be useful when proofreading an important message which you want to
elicit a certain emotion or tone, particularly with a given pattern or
rhythm (speeches, letters, applications, songs, poems, etc).

## Installation

You can install the released version of remoodji from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("remoodji")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("UBC-MDS/remoodji")
```

## Functions

Counter: - With an input of textfile it will output a dataframe with
character count, word count, and sentence count. Sentiment Analysis
Dataframe: - With an input of a textfile it will output a dataframe with
sentiment analysis (e.g. sentiment type, sentiment words, and percentage
of overall sentiment per emotion). Character Replacement: - With the
input of a textfile and the ability to choose which emotions you would
like to replace (e.g. certain emotions or all) it will output a textfile
that has emotional words replaced with emojis. Sentiment Analysis Plot:
- With the input of a dataframe from the sentiment analysis function it
will output a visualization on the most emotionally charged words that
appear in the text.

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(remoodji)
#> Loading required package: tidyverse
#> ── Attaching packages ─────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.2     ✓ purrr   0.3.4
#> ✓ tibble  3.0.3     ✓ dplyr   1.0.2
#> ✓ tidyr   1.1.2     ✓ stringr 1.4.0
#> ✓ readr   1.3.1     ✓ forcats 0.5.0
#> ── Conflicts ────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
## basic example code
```

## Contribution to Ecosystem

  - While [tidytext](https://github.com/juliasilge/tidytext) (R) and
    [nltk](https://github.com/nltk/nltk) (Python) already exist, this
    package takes it a step further by providing qualitative sentiment
    analysis in a visually appealing format by replacing emotional words
    with emojis and further analyzing text data to provide more
    quantitative sentiment analysis.
  - We also add visualizations to further this quantitative sentiment
    analysis in a way that these packages do not.

## Dependencies

  - tidyverse
  - dplyr
  - tidytext
  - textdata
  - emojifont

## Contributors

  - [Aidan Mattrick](https://github.com/aidanmattrick)
  - [Kevin Shahnazari](https://github.com/kshahnazari1998)
  - [Zhanyi Su](https://github.com/YikiSu)
  - [Rachel Wong](https://github.com/rachelywong)

### Credits

This package was created with Devtools from R packages by Hadley Wickham
and Jenny Bryan (<https://r-pkgs.org/index.html>).
