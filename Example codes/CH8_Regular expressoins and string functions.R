# A short example
# Our task is to extract the names and numbers and to put them into a data frame
raw.data <- "555-1239Moe Szyslak(636) 555-0113Burns, C. Montgomery555-6542Rev. Timothy Lovejoy555 8904Ned Flanders636-555-3226Simpson,Homer5553642Dr. Julius Hibbert"

library(stringr)
name <- unlist(str_extract_all(raw.data, "[[:alpha:]., ]{2,}"))
name
phone <- unlist(str_extract_all(raw.data, "\\(?(\\d{3})?\\)?(-| )?\\d{3}(-| )?\\d{4}"))
phone

data.frame(name = name, phone = phone)

# 8.1 Regular expressions
# str_extract() str_extract_all()
example.obj <- "1. A small sentence. - 2. Another tiny sentence."
str_extract(example.obj, "small")
str_extract(example.obj, "banana")
unlist(str_extract_all(example.obj, "sentence"))

# return a list
out <- str_extract_all(c("text", "manipulation", "basics"), "a")
out

# case sensitive
str_extract(example.obj, "small")
str_extract(example.obj, "SMALL")

unlist(str_extract_all(example.obj, "en"))
str_extract(example.obj, "mall sent")

# ^ 
# The caret symbol (^) at the beginning of a regular expression marks the beginning of a string！
# $
# $ at the end marks the end
str_extract(example.obj, "2")
str_extract(example.obj, "??2")
unlist(str_extract_all(example.obj, "sentence$"))

# |
# the pipe,
# displayed as |. This character is treated as an OR operator such that 
# the function returns all matches to the expressions before and after the pipe.
unlist(str_extract_all(example.obj, "tiny|sentence"))

# .
# The most general among them is the period character. It matches any character
str_extract(example.obj, "sm.ll")

# []
# A character class means that any of the characters within the brackets will be matched.
str_extract(example.obj, "sm[abc]ll")

# -
# employ ranges of characters, using a dash -.
str_extract(example.obj, "sm[a-p]ll")

# the character class [uvw. ] matches the letters u, v and w as well as a period and a blank space
# Inside a character class, a dot only matches a literal dot.
unlist(str_extract_all(example.obj, "[uvw. ]"))

# predefined classes
unlist(str_extract_all(example.obj, "[[:punct:]]"))

# A redundant inclusion of a character in a character class will only match each instance once
unlist(str_extract_all(example.obj, "[AAAAAA]"))

# extend a predefined character class by adding elements to it.
unlist(str_extract_all(example.obj, "[[:punct:]ABC]"))

# invert their meanings by adding a caret (^) at the beginning of a character class.
# Doing so, the function will match everything except the contents of the character class.
unlist(str_extract_all(example.obj, "[^[:alnum:]]"))

# extract a sequence starting with an s, ending with a l, and any three alphabetic characters in between from our running example.
str_extract(example.obj, "s[[:alpha:]][[:alpha:]][[:alpha:]]l")

# {}
# quantifiers
# a number in {} after a character signals a fixed number of repetitions of this character
str_extract(example.obj, "s[[:alpha:]]{3}l")

# +
# + sign, which signals that the preceding item has to be matched one or more times
str_extract(example.obj, "A.+sentence")

# R applies greedy quantification
# change this behavior by adding a ? to the expression in order to 
#signal that we are only looking for the shortest possible sequence
str_extract(example.obj, "A.+?sentence")

# apply a quantifier to a group of characters, we enclose them in parentheses.
# asking the function to return a sequence of characters 
# where the first character can be any character and 
# the second and third characters have to be an e and an n.
# We are asking the function for all instances where this sequence appears at least once, but at most five times.
unlist(str_extract_all(example.obj, "(.en){1,5}"))
# The function will thus match all sequences that run from any character over e to n 
# where the n has to appear at least once but at most five times.
unlist(str_extract_all(example.obj, ".en{1,5}"))

# match metacharacters literally, we precede them with two backslashes
unlist(str_extract_all(example.obj, "\\."))

# alternative than preceding every metacharacter with a backslash.
# fixed()
unlist(str_extract_all(example.obj, fixed(".")))

# available shortcuts.
# \w
unlist(str_extract_all(example.obj, "\\w+"))

# word edges
# \>, \<, and \b.
# extract all e from our running example that are at the end of a word
unlist(str_extract_all(example.obj, "e\\b"))

# backreferencing
# we are looking for the first letter in our running example 
# and！whatever it may be！want to match further instances of that particular letter. 
# To do so, we enclose the element in question in parentheses！for example, ([[:alpha:]]) 
# and reference it using \1.
str_extract(example.obj, "([[:alpha:]]).+?\\1")

# stringr package
str_extract(example.obj, "tiny")
str_extract_all(example.obj, "[[:digit:]]")

# the location of a match in a given string, we use the functions str_locate() or str_locate_all().
str_locate(example.obj, "tiny")

# make use of positional information in a string to extract a substring using the function str_sub().
str_sub(example.obj, start = 35, end = 38)

# replace a given substring
str_sub(example.obj, 35, 38) <- "huge"
example.obj

# str_replace() and str_replace_all() are used for replacements more generally
str_replace(example.obj, pattern = "huge", replacement = "giant")

# split
unlist(str_split(example.obj, "-"))
# fix the number of particles we want the string to be split into
as.character(str_split_fixed(example.obj, "[[:blank:]]", 5))

# We can apply the functions to several strings at the same time
char.vec <- c("this", "and this", "and that")
str_detect(char.vec, "this")
str_count(char.vec, "this")
str_count(char.vec, "\\w+")

# duplicate strings
dup.obj <- str_dup(char.vec, 3)
dup.obj

# count the number of characters
length.char.vec <- str_length(char.vec)
length.char.vec

# str_pad()
# str_trim() 
# They are used to add characters to the edges of strings or trim blank spaces
char.vec <- str_pad(char.vec, width = max(length.char.vec),
                       side = "both", pad = " ")
char.vec

char.vec <- str_trim(char.vec)
char.vec

# join strings
cat(str_c(char.vec, collapse = "\n"))
str_c("text", "manipulation", sep = " ")
# If the length of one vector is the multiple of the other, the function automatically recycles the shorter one.
str_c("text", c("manipulation", "basics"), sep = " ")

# A couple more handy functions

# agrep()
# provides approximate matching via the Levenshtein distance
agrep("Barack Obama", "Barack H. Obama", max.distance = list(all = 3))
agrep("Barack Obama", "Michelle Obama", max.distance = list(all = 3))

# pmatch()
# The function returns the positions of the strings in the first vector in the second vector
pmatch(c("and this", "and that", "and these", "and those"), char.vec)

# make.unique()
# ransform a collection of nonunique strings by adding digits where necessary
make.unique(c("a", "b", "a", "c", "b", "a"))



