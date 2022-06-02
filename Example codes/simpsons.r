library(RCurl)
library(stringr)

# This code extracts the rating of Simpsons episodes from RT.

# It breaks on episode 6 for some reason.

n = 10

df = data.frame(
  season = rep(NA, n),
  year = rep("", n),
  rating = rep(NA, n)
)

for (i in 1:n) {
  print(paste(i, ' / ', n))
  url = paste0('https://www.rottentomatoes.com/tv/the_simpsons/s', i)
  s = getURL(url)
  df[i, 1] = i
  
  s1 = gsub("[[:space:]]", "", s)
  
  match = str_match_all(s1, "<spanclass=\"h3subtle\">\\((.*?)\\)</span>")
  year = match[[1]][2]
  df[i, 2] = year
  
  
  match = str_match_all(s1, "<spanclass=\"mop-ratings-wrap__percentage\">(.*?)%</span>")
  rating = as.numeric(match[[1]][2,2])
  df[i, 3] = rating
  print(paste(i, year, rating))
}


