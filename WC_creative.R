library(tidyverse)
library(lubridate)
library(scales)
library(dplyr)
library(stringr)
library(gutenbergr)
library(tidytext)
path <- "/Users/olivier/Library/Mobile Documents/com~apple~CloudDocs/Projects/great_books/western_canon.csv"
list <- read.csv(path, header = TRUE, sep = ,)
IDs <- unique(list$ID)
IDs <- IDs[!is.na(IDs)]
my_mirror <- "http://mirrors.xmission.com/gutenberg/"
great_books <- gutenberg_download(IDs, mirror = my_mirror, 
                                  meta_fields = "author")
great_books <- great_books %>% unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)
great_books %>%
  count(word) %>%
  top_n(10, n) %>%
  mutate(word = reorder(word, n)) %>% arrange(desc(n))
old_en <- c("thou", "thy", "thee")
old_en <- tibble(line = c(1, 2, 3), word = old_en)
great_books <- great_books %>% filter(!word %in% old_en$word)
great_books %>%
  count(word) %>%
  top_n(10, n) %>%
  mutate(word = reorder(word, n)) %>% arrange(desc(n))
