library(RSQLite)
library(DBI)

# Table info without loading entire table in RAM
dbcon = dbConnect(SQLite(), dbname = "pokemon.sqlite")
dbListTables(dbcon)
query_table_info = "PRAGMA table_info('Pokem')"
dbGetQuery(dbcon, query_table_info)

# Buffering query results
# what we did last lecture 
query = "SELECT Name, Generation FROM Pokem"
result = dbGetQuery(dbcon, query)
# Expecting a lot of output? Don't load it all at once into memory:
query = "SELECT Name, Generation FROM Pokem"
result = dbSendQuery(dbcon, query)
dbFetch(result, 5)
dbFetch(result, -1)
dbClearResult(result)

# Ordering results
query = "SELECT Name, Generation FROM Pokem ORDER BY ATTACK"
result = dbSendQuery(dbcon, query)
dbFetch(result, 5)
dbClearResult(result)
# descending order 
query = "SELECT Name, Generation FROM Pokem ORDER BY ATTACK DESC"
result = dbSendQuery(dbcon, query)
dbFetch(result, 5)
dbClearResult(result)

# Limit output
query = "SELECT Name, Generation FROM Pokem ORDER BY ATTACK DESC LIMIT 5"
result = dbSendQuery(dbcon, query)
dbFetch(result, -1)
dbClearResult(result)

# INSERT operations
# query = "INSERT INTO ... (..., ...) VALUES (..., ...)"
# dbSendQuery(..., query)

# Check defaults before inserting
dbGetQuery(dbcon, query_table_info)
insert = "INSERT INTO Pokem (Name, Type_1, Type_2, isLegendary, Attack) VALUES ('Lloydazoid', 'Sea', 'Flying', 'True', '3.14159')"
dbSendQuery(dbcon, insert)


# Deleting database elements
delete = "DELETE FROM Pokem WHERE Name == 'Lloydazoid'"
dbSendQuery(dbcon, delete)






# Descriptive statistics
# "5 number summary"
# "2 number summary": mean and variance
# Boxplots
# Histograms
# Density estimation

# Histogram implementation
IndicatorSum = function(x,a,b){
  #lower bound a
  #upper bound b
  #Count the number of x values
  #which are inside the (a,b] bounds
  out = rep(NA, length(a))
  for(index in 1:length(a)){
    out[index]=sum(x>a[index] & x<=b[index])
  }
  return(out)
}

# Kernel Density Estimator
x = rnorm(1000,0,1)
lowvalue = floor(min(x))
highvalue = ceiling(max(x))
width2use = 1
BinEdges = seq(from = lowvalue, to = highvalue, by = width2use)
a = BinEdges[-length(BinEdges)]
b = BinEdges[-1]
height = IndicatorSum(x,a,b)
plot((a+b)/2,height)
height = IndicatorSum(x,a,b)
hist(x,breaks = BinEdges)
points(apply(cbind(a,b),1,mean),height,
         pch = '*',cex = 10)

# Special Case
table(floor(x))

# Kernel Density, edge shift-.2
lowvalue = floor(min(x))
highvalue = ceiling(max(x))
width2use = 1
BinEdges = seq(from = lowvalue-.2, to = 1+highvalue-.2, by = width2use)
a = BinEdges[-length(BinEdges)]
b = BinEdges[-1]
height = IndicatorSum(x,a,b)
points((a+b)/2,height,pch='@',cex = 2)

# Kernel Density, edge shift+.2
lowvalue = floor(min(x))
highvalue = ceiling(max(x))
width2use = 1
BinEdges = seq(from = lowvalue-1+.2, to = 1+highvalue+.2, by = width2use)
a = BinEdges[-length(BinEdges)]
b = BinEdges[-1]
height = IndicatorSum(x,a,b)
points((a+b)/2,height,pch='^',cex = 2)



y=seq(-4,4,length=1000)
plot(y,dnorm(y),type='l',xlab = 'y',ylab='normal pdf',main = 'Weight Function',ylim=c(0,1))
lines(y, y>0&y<=1)

# How do we plot Attack Distribution within each Generation?
sql_attacks = "SELECT Name,Generation,ATTACK FROM Pokem"
output = dbGetQuery(dbcon, sql_attacks)
boxplot(output$Attack~output$Generation,las=2,xlab="Generation",main= "Attacks by Generation")

par(mfrow=c(2,3)); 
for( lp in 1:6) { 
  hist(output$Attack[output$Generation==lp])
}

par(mfrow=c(2,3)); 
for( lp in 1:6) { 
  plot(density(output$Attack[output$Generation==lp]),main= paste("Generation",lp))
}

par(mfrow=c(1,1)); 
plot(density(output$Attack),type='n',main= "Attacks by Generation"); 
for( lp in 1:6) {
  lines(density(output$Attack[output$Generation==lp]),col=lp,lwd=2)
};
legend("topright",paste("Generation",1:6),col=1:6,lwd=2)

# Using a common bandwidth
par(mfrow=c(1,1));
plot(density(output$Attack),type='n',main= "Attacks by Generation",xlab="Attacks");
bandw = density(output$Attack)
for( gen in 1:6) {
  lines(density(output$Attack[output$Generation==gen], bw=bandw$bw), col=gen, lwd=2)
};
legend("topright",paste("Generation",1:6),col=1:6,lwd=2)

# Unknown number of Generations
par(mfrow=c(1,1));
plot(density(output$Attack),type='n',main= "Attacks by Generation",xlab="Attacks");
bandw = density(output$Attack)
UniqueGens = unique(output$Generation)
for( gen in 1:length(UniqueGens)){
  lines(density(output$Attack[output$Generation== UniqueGens [gen]],bw= bandw$bw), col=gen, lwd=2)
};
legend("topright",paste("Generation", UniqueGens),col=1:6,lwd=2) #<¡ªensures order

# Aggregating results without bringing everything into R
# (Failed way to) count the number of Pokemon per generation:
sql_poke = "SELECT Generation, count(Generation) AS NumberPerG FROM Pokem"
QuerryOut = dbSendQuery(dbcon, sql_poke)
dbFetch(QuerryOut, 5)
# or
dbGetQuery(dbcon, sql_poke)
# (Correct way to) count the number of Pokemon per generation:
sql_poke = "SELECT Generation, count(Generation) AS NumberPerG FROM Pokem GROUP BY Generation"
dbGetQuery(dbcon, sql_poke)

# Count and come up with more summaries of Pokemon per generation:
sql_poke = "SELECT Generation, SUM(Attack) AS SumAttack, 
                               COUNT(Generation) AS NumberPerG, 
                               AVG(Attack) AS AvgAttacks 
              FROM Pokem 
              GROUP BY Generation"
dbGetQuery(dbcon, sql_poke)

sql_poke = "SELECT Generation, SUM(Attack) AS SumAttack, 
                               COUNT(Generation) AS NumberPerG, 
                               AVG(Attack) AS AvgAttacks,
                               MIN(Attack) AS MinAttacks, 
                               MAX(Attack) AS MaxAttacks 
              FROM Pokem
              GROUP BY Generation"
dbGetQuery(dbcon, sql_poke)

dbDisconnect(dbcon)











