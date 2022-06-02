# Debugging

# Types of bugs
## Syntax errors
## Runtime errors
## Logic errors

# Debugging strategies
## Print statements
## Examination of stack trace     #options(error = traceback)
## Breakpoints & browsers     #options(error = browser)

# Example: Broken FizzBuzz
# fb = function(n) {
#   for (i in 1:n) {
#     if ((j %% 3 == 0) && (j %% 5 == 0) {          
#       cat("FizzBuzz\n")
#     }
#     if (j %% 3 == 0) {
#       cat("Fizz\n")
#     }
#     if (j %% 5 == 0) {
#       cat("Buzz\n")
#     }
#     else {
#       cat(sprintf("%d\n", j))
#     }
#   }
# }

# error
# missing bracket 
# i , j
# else if 

# fixed
fb = function(n) {
  for (j in 1:n) {
    if ((j %% 3 == 0) && (j %% 5 == 0)) {
      cat("FizzBuzz\n")
    }
    else if (j %% 3 == 0) {
      cat("Fizz\n")
    }
    else if (j %% 5 == 0) {
      cat("Buzz\n")
    }
    else {
      cat(sprintf("%d\n", j))
    }
  }
}

fb(100)

Sys.setlocale(locale = "english")
# String manipulation in R
# Read a text file into a string:
fn = "alice.txt"
s = readChar(fn, file.info(fn)$size)
nchar(s) # Gives the number of characters

# We want a vector with one word per coordinate
# We want to strip leading and trailing whitespace
s = trimws(s)
x = strsplit(s, '\\s+')
x = unlist(x)

# Create a Word Cloud
library(wordcloud)
t = table(x)
wordcloud(names(t), t)

# Remove stop words:
x = strsplit(tolower(s), '\\s+')
#...


# Live coding web scraping for the Simpsons on rotten tomatoes
library(RCurl)
library(stringr)
library(httr)
simpsons = function() {
  
}

# empty data frame
df = data.frame(
  season = rep(NA, n),
  year = rep("", n),
  rating = rep(NA, n)
)

n = 32
for (i in 1:n){
  print(paste(i, ' / ', n))
  
  url = paste0('https://www.rottentomatoes.com/tv/the_simpsons/s', i)
  s = GET(url)
  s = content(s, "text")

  df[i, 1] = i

  s1 = gsub("[[:space:]]", "", s)
    
  match = str_match_all(s1, "<spanclass=\"h3subtle\">\\((.*?)\\)</span>")
  year = match[[1]][1,2]
  df[i, 2] = year
  
  match = str_match_all(s1, "<spanclass=\"mop-ratings-wrap__percentage\">(.*?)%</span>")
  if (length(match[[1]]) == 4){
    rating = as.numeric(match[[1]][2,2])    
  }
  else {
    rating = as.numeric(match[[1]][1,2])
  }
  df[i, 3] = rating
  
  print(paste(i, year, rating))
}


# Season 1
url = 'https://www.rottentomatoes.com/tv/the_simpsons/s1'
s = GET(url)
s = content(s,"text")
# remove space and new line
s1 = gsub("[[:space:]]", "", s)

# extract rating
match = str_match_all(s1, "<spanclass=\"mop-ratings-wrap__percentage\">(.*?)%</span>")
match
dim(match[[1]])
rating = as.numeric(match[[1]][2,2])

# extract year
match = str_match_all(s1, "<spanclass=\"h3subtle\">\\((.*?)\\)</span>")
year = match[[1]][1,2]






