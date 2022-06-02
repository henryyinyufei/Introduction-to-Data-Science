library(httr)
library(tidyverse)
library(stringr)
library(RCurl)
url = 'https://pitchfork.com/reviews/albums/jeff-parker-suite-for-max-brown/'

url = 'https://pitchfork.com/reviews/albums/pale-waves-who-am-i/'
res <- getURL(url, ssl.verifypeer = FALSE)
s = GET(url)
s = content(s, "text")
s1 = gsub("[[:space:]]", "", s)

match = str_match_all(s1, "<spanclass=\"score\">(.*?)</span>")
as.numeric(match[[1]][1,2])

library(rvest)
simple <- read_html(url)

a <- simple %>%
  html_nodes(".dropcap p") %>%
  html_text()

cat(a, sep = "\n\n")

