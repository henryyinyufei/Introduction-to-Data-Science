Sys.setlocale(locale = "english")
setwd("D:/Simon Fraser University/2021 spring/STAT 240/Examples")


x = iris
boxplot(x$Sepal.Length)
hist(x$Sepal.Length)


x = read.table(
  file = 'pokemon_2019.csv',
  header = T,
  sep = ',',
  quote = "")

plot(x$Attack, x$Defense)

# Concatenate two vectors and plot
hist(c(x$Attack, x$Defense))

data = x
# Indexing:
s = data[1, 1]; s = data[1, 'Name']; s = data$Name[1]
# Logical indexing:
s = data[data$Type_1 == 'Ground', ]
s = data[data$Type_1 == 'Ground' | data$Type_2 == 'Ground', ]
# Operators: == != | & > < >= <=
  
# Plot attack vs defense of ground Pok¨¦mon only:
s = data[data$Type_1 == 'Ground', ]
plot(s$Attack, s$Defense, xlab = 'Attack', 
     ylab ='Defense', main = 'Ground Pok¨¦mon', pch = 19, cex = .4)

# Count unique levels:
table(data$Type_1)

# Boxplot of attack for each type of Pok¨¦mon:
boxplot(Attack~Type_1, data = data, xlab = 'Type')
# improvement 
boxplot(Attack~Type_1, data = data, xlab = 'Type', las = 2)
