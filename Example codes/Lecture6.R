# Finding unique combinations vs counting unique combinations
# unique() vs table()
x1 = c("a", "b", "c", "b", "b")
unique(x1)
table(x1)

class(x1)
factor(x1)
f1 = factor(x1)
z = f1[1]
z
f1 = 1
z

# Website scraping by hand

# Getting a website into R:
library(RCurl)
url = 'https://www.reuters.com/article/us-baseball-mlblawsuit/astros-red-sox-major-league-baseball-urge-dismissalof-sign-stealing-lawsuit-idUSKCN20H0SK'
# s = getURL(url) # Not working due to SSL problem. options:(1) Rstudio Cloud (2) stackoverflow (3)httr package GET() function

library(httr)
s<- GET(url)
s <- content(s, "text")




# Extracting website text
# Two methods:
# Design regular expressions to extract text
# Parse the HTML into a tree using an R library such as XML

# String manipulation
# Three main operations:
## Search
## Extract
## Replace

# Base R 
# Three main operations:
## Search - grep/ grepl(l=logical)
## Extract - gregexpr/ substr/ regmatches
## Replace - sub/ gsub

# grep:
# input a vector or list
# output indices of elements with the pattern
(ExampleText = c("1 - small thing to do",
                 "2 - 2 big things that we're doing",
                 "Some Small things that were done 4 free - 333",
                 "four Things that we've done"))
grep("that", ExampleText) #which elements have that
grepl("that", ExampleText)
grep("small", ExampleText) #which elements have small (but not Small)
grepl("small", ExampleText)
grep("small", ExampleText, ignore.case = TRUE) #which elements have small or Small or smAll,¡­
grepl("small", ExampleText, ignore.case = TRUE)
grep("small", ExampleText, ignore.case = TRUE, value=TRUE) #which elements contains small, or Small, or smALl,..


# substr: subset a string of text
# input is a string of text
# output is the elements from start to stop.
(Example1 = "1 - small thing to do")

# grep just says if ¡°mall¡± exists (1) or not (0) in Example1
grep("mall",Example1) #element in which it exists (there is only one element)
grep("mdall",Example1) #can¡¯t be found

#Extract the letters between positions start and stop(inclusive)
substr(Example1,start=6,stop=15)


# gregexpr:
# input a vector or list of text
# output list showing text start position and pattern length
(ExampleText = c("1 - small thing to do",
                 "2 - 2 big things that we're doing",
                 "Some Small things that were done 4 free - 333", 
                 "four Things that we've done"))
gregexpr("thing", ExampleText)
gregexpr("small", ExampleText)
gregexpr("small", ExampleText, ignore.case = TRUE)


# gsub:
# replace a pattern within a string
# input a list, vector, or string
(ExampleText = c("1 - small thing to do",
                 "2 - 2 big things that we're doing",
                 "Some Small things that were done 4 free - 333", 
                 "four Things that we've done"))
gsub("thing", "stuff", ExampleText) #replace ¡°thing¡± with ¡°stuff¡±
gsub("thing", "stuff", ExampleText,ignore.case = TRUE) # replace ¡°thing¡±,¡±Thing¡±, ¡°ThInG¡±,¡­ with ¡°stuff¡±

sub("t", "*", ExampleText)

# Simpler Syntax
# library(stringr)
# Three main operations:
## Search - str_detect
## Extract - str_extract / str_extract_all
## Replace - str_replace / str_replace_all

# Formal regular expressions
# Concatenation
# Or |
# Closure *
# Parentheses ()

# Finding General Pieces:
# \w = word characters (groups of letters)
# \W = non word characters
# \s = space characters
# \S = no space characters
# \d = digits
# \D = non digits
# \b = word edge
# \B = non word edge
# \< = word beginning
# \> = word end

# Extended/Shorthand













