# loading package
library(RSQLite)

# establish cOnnection
# In Textbook (Not working)
#sqlite <- dbDriver("SQLite")
#con <- dbConnect(sqlite, "birthdays.db")

#
con = dbConnect(RSQLite::SQLite(), dbname = "pokemon.sqlite")

# 'plain' SQL
sql <- "SELECT * FROM Pokem"
res <- dbGetQuery(con, sql)
res

res <- dbSendQuery(con, sql)
fetch(res)

# general information
dbGetInfo(con)

# listing tables
dbListTables(con)

# reading tables
res <- dbReadTable(con, "Pokem")
res

# writing tables
dbWriteTable(con, "test", res)

# table exists?
dbExistsTable(con, "test")

# remove table
dbRemoveTable(con, "test")

# checking data type
dbDataType(con, res$Name)
dbDataType(con, res$Type_1)
dbDataType(con, res$isLegendary)
dbDataType(con, res$Body_Style)

# transaction management
dbBeginTransaction(con)
dbRollback(con)
dbCommit(con)
dbDisconnect(con)
