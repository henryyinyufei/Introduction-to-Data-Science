# Example: FizzBuzz

# "Write a program that prints the numbers from 1 to 100. 
#But for multiples of three print "Fizz" instead of the number 
#and for multiples of five print "Buzz". 
#For numbers which are multiples of both three and five, print "FizzBuzz"."


for (i in 1:100) {
  if (((i %% 3) == 0) && ((i %% 5) == 0)) {
    cat("FizzBuzz")
    cat("\n")
  } else if ((i %% 3) == 0){
    cat("Fizz")
    cat("\n")
  } else if ((i %% 5) == 0){
    cat("Buzz")
    cat("\n")
  } else {
    cat(as.numeric(i))
    cat("\n")
  }
}

# function 
fb = function (n) {
  for (i in 1:n) {
    if (((i %% 3) == 0) && ((i %% 5) == 0)) {
      cat("FizzBuzz")
      cat("\n")
    } else if ((i %% 3) == 0){
      cat("Fizz")
      cat("\n")
    } else if ((i %% 5) == 0){
      cat("Buzz")
      cat("\n")
    } else {
      cat(as.numeric(i))
      cat("\n")
    }
  }
}
fb(100)

# Libraries and starting SQL
# Connecting to the database:
library(RSQLite)
db_poke = dbConnect(RSQLite::SQLite(), dbname = "pokemon.sqlite")
dbListTables(db_poke)

# About the database:
names(dbReadTable(db_poke, "Pokem"))
tail(dbReadTable(db_poke, "Pokem"))
#Z(dbReadTable(database_name, table_name))

# SQL queries
quer = "SELECT * FROM Pokem WHERE Attack>100"
dbGetQuery(db_poke, quer)

# Selecting based on logicals
quer = "SELECT Name FROM Pokem WHERE isLegendary =='True'"
dbGetQuery(db_poke, quer)

# Composite logicals
quer = "SELECT Name FROM Pokem WHERE isLegendary == 'True' AND Generation == 3"
dbGetQuery(db_poke, quer)
