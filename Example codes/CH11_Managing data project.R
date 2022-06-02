library(stringr)
library(XML)
library(RCurl)

setwd("D:/Simon Fraser University/2021 spring/STAT 240/Examples/CH11")

# we use the dir() function to produce a character vector with all the file names in the current directory
all_files <- dir("stocks")
all_files

# we set up a list as an intermediate data structure
closing_stock <- list()


# The get_stock() extractor function is a custom function that works on the entire Apple node 
#and returns the date and closing value for each day.
getStock <- function(x) {
  date <- xmlValue(x[["date"]])
  value <- xmlValue(x[["close"]])
  c(date, value)
}

# First, we construct the path of each XML file and save the information in a new object called path.

# The information is needed for the next step, where we pass the path to the parsing function xmlParse(). 
#This creates the internal representation of the file inside a new object called parsed_stock.

# Finally, we obtain the desired information from the parsed object by means of an XPath statement.
for (i in 1:length(all_files)) {
  path <- str_c("stocks/", all_files[i])
  parsed_stock <- xmlParse(path)
  closing_stock[[i]] <- xpathSApply(parsed_stock, "//Apple", getStock)
}

# We go ahead and unlist the container list to process each information individually and put it into a more convenient data format
closing_stock <- unlist(closing_stock)
closing_stock <- data.frame(matrix(closing_stock, ncol = 2, byrow = T))
colnames(closing_stock) <- c("date", "value")

# Finally, we recast the value information into a numerical vector and the date information into a vector of class Date.
closing_stock$date <- as.Date(closing_stock$date, "%Y/%m/%d")
closing_stock$value <- as.numeric(as.character(closing_stock$value))

# We are ready to create a visual representation of the extracted data. We use plot() to create a time-series of the stock values
plot(closing_stock$date, closing_stock$value, 
     type = "l", 
     main = "", 
     ylab = "Closing stock", 
     xlab = "Time")

# Using while-loops and control structures
a <- 0
while(a < 3){
  a <- a + 1
  print(a)
}
# we can also break a loop with an if() clause and a break command.
a <- 0
while(TRUE){
  a <- a + 1
  print(a)
  if(a >= 3){
    break
  }
}

# As the first step, we construct the paths to the XML files on the local hard drive
files <- str_c("stocks/", all_files)

# We create a function getStock2() that parses an XML file and extracts relevant information.
#This code is similar to the one we used before.
getStock2 <- function(file){
  parsedStock <- xmlParse(file)
  closing_stock <- xpathSApply(parsedStock,
                               "//Apple/date | //Apple/close",
                               xmlValue)
  closing_stock <- as.data.frame(matrix(closing_stock,
                                        ncol = 2,
                                        byrow = TRUE))
}

# Implementation of progress feedback: Messages and progress bars
baseurl <- "http://www.r-datacollection.com/materials/workflow/stocks"
links <- str_c(baseurl, "/stocks_", 2003:2013, ".xml")

# Next, we set up a loop over the length of links. 
#Inside the loop, we download the file, create a sensible name using basename() to return the source file name, 
#and then write the XML code to the local hard drive.
N <- length(links)
for(i in 1:N){
  stocks <- getURL(links[i])
  name <- basename(links[i])
  write(stocks, file = str_c("stocks/", name))
  cat(i, "of", N, "-", name, "\n")
}

for(i in 1:30) {
  if(i %% 10 == 0){
    cat(i, "of", 30, "\n")
  }
}

write("", "download.txt")

N <- length(links)
for(i in 1:N){
  stocks <- getURL(links[i])
  name <- basename(links[i])
  write(stocks, file = str_c("stocks/", name))
  feedback <- str_c(i, "of", N, "-", name, "\n", sep = " ")
  cat(feedback)
  write(feedback, "download.txt", append = T)
  write(nchar(stocks), "download.txt", append = T)
  write("- -----------\n", "download.txt", append = T)
}

progress_bar <- txtProgressBar(min = 0, max = N, style = 3)
for(i in 1:N){
  stocks <- getURL(links[i])
  name <- basename(links[i])
  write(stocks, file = str_c("stocks/", name))
  setTxtProgressBar(progress_bar, i)
  Sys.sleep(1)
}

if (!file.exists("quotes")) dir.create("quotes")
time <- str_replace_all(as.character(Sys.time()), ":", "_")
fname <- str_c("quotes/rquote ", time, ".html")
url <- "http://www.r-datacollection.com/materials/workflow/rQuotes.php"
download.file(url = url, destfile = fname)
