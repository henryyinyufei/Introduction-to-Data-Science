# Case Study: World Hertiage Sites in Danger

# Load library
library(stringr)
library(XML)
library(maps)

# Error: failed to load external entity "http://en.wikipedia.org/wiki/List_of_World_Heritage_in_Danger"
#heritage_parsed <- htmlParse("https://en.wikipedia.org/wiki/List_of_World_Heritage_in_Danger")
#tables <- readHTMLTable(heritage_parsed, stringsAsFactors = FALSE)


library(httr)
tables <- GET("http://en.wikipedia.org/wiki/List_of_World_Heritage_in_Danger")
tables <- readHTMLTable(rawToChar(tables$content), header = T)

# select the table we are interested in (the second one)
danger_table <- danger_table <- tables[[2]]
names(danger_table)

# select only those that contain information about the site¡¯s name, location, criterion of
#heritage (cultural or natural), year of inscription, and year of endangerment.
danger_table <- danger_table[, c(1, 3, 4, 6, 7)]

# The variables in our table have been assigned unhandy names, so we relabel them.
colnames(danger_table) <- c("name", "locn", "crit", "yins", "yend")

# we have a look at the names of the first few sites:
danger_table$name[1:3]

# The variable crit, which contains the information whether the site is of cultural or natural character, is recoded
danger_table$crit <- ifelse(str_detect(danger_table$crit, "Natural") == TRUE, "nat", "cult")
danger_table$crit[1:3]

# the two variables y_ins and y_end are turned into numeric ones
danger_table$yins <- as.numeric(danger_table$yins)
danger_table$yins[1:3]

# Some of the entries in the y_end variable are ambiguous as they contain several years
# We select the last given year in the cell.
# regular expression, which goes [[:digit:]]4$  ##???
yend_clean <- unlist(str_extract_all(danger_table$yend, "[:digit:]{4}[^d]$"))
danger_table$yend <- as.numeric(str_sub(yend_clean,1,4))
danger_table$yend[1:3]

# The locn variable is a bit of a mess, exemplified by three cases drawn from the data-set:
danger_table$locn[c(1, 3, 5)]

# extract latitude and longitude using "regular expression"
reg_y <- "[/][ -]*[[:digit:]]*[.]*[[:digit:]]*[;]"
reg_x <- "[;][ -]*[[:digit:]]*[.]*[[:digit:]]*"
y_coords <- str_extract(danger_table$locn, reg_y)
y_coords <- as.numeric(str_sub(y_coords, 3, -2))
danger_table$y_coords <- y_coords
x_coords <- str_extract(danger_table$locn, reg_x)
x_coords <- as.numeric(str_sub(x_coords, 3, -1))
danger_table$x_coords <- x_coords
danger_table$locn <- NULL


round(danger_table$y_coords, 2)[1:3]
round(danger_table$x_coords, 2)[1:3]

# dim() returns the number of rows and columns of the data frame; head() returns the first few observations:
dim(danger_table)
head(danger_table)

# map
pch <- ifelse(danger_table$crit == "nat", 19, 2)
map("world", col = "darkgrey", lwd = 0.5, mar = c(0.1, 0.1, 0.1, 0.1))
points(danger_table$x_coords, danger_table$y_coords, pch = pch)
box()

# We find that there are more cultural than natural sites in danger.
table(danger_table$crit)

# displays the distribution of the second variable that we generated using the hist() command
hist(danger_table$yend,
        freq = TRUE,
        xlab = "Year when site was put on the list of endangered sites",
        main = "")

# Even more interesting is the distribution of time spans between the year of inscription and the year of endangerment
duration <- danger_table$yend - danger_table$yins
hist(duration,
        freq = TRUE,
        xlab = "Years it took to become an endangered site",
        main = "")












