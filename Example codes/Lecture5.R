library(RSQLite)


# SQL: Aggregating results
dbcon = dbConnect(RSQLite::SQLite(),
                  dbname="D:\\Simon Fraser University\\2021 spring\\STAT 240\\Examples\\pokemon.sqlite")
query = "SELECT Generation, 
                count(Generation) AS NumberPerG 
         FROM Pokem"
QuerryOut = dbSendQuery(dbcon, query)
dbFetch(QuerryOut, 5)

# More Math on the Pokemon within generation:
query = "SELECT Generation, 
                SUM(Attack) AS SumAttack,
                COUNT(Generation) AS NumberPerG, 
                AVG(Attack) AS AvgAttacks
        FROM Pokem 
        GROUP BY Generation"
dbGetQuery(dbcon, query)

# SQL: Server side computations
# More Math on the Pokemon within generation:
sql_poke = "SELECT Generation, 
                   SUM(Attack)/COUNT(Generation) AS myavg, 
                   AVG(Attack) AS AvgAttacks
            FROM Pokem 
            GROUP BY Generation"
dbGetQuery(dbcon, sql_poke)
# What is wrong here?
# division in sql using integer division

sql_poke = "SELECT Generation,
                   SUM(Attack)/(COUNT(Generation)*1.0) AS myavg, 
                   AVG(Attack) AS AvgAttacks 
            FROM Pokem 
            GROUP BY Generation"
dbGetQuery(dbcon, sql_poke)
# COUNT() produces an integer so the result must be an integer. 
# Multiplying by 1.0 converts it to a Double and allows the result to be a double.

# More basic summaries of Pokemon per generation:
sql_poke = "SELECT Generation, 
                   SUM(Attack) AS SumAttack,
                   COUNT(Generation) AS NumberPerG, 
                   AVG(Attack) AS AvgAttacks, 
                   MIN(Attack) AS MinAttacks, 
                   MAX(Attack) AS MaxAttacks 
            FROM Pokem 
            GROUP BY Generation"
dbGetQuery(dbcon, sql_poke)

# To do more general math you need to move some operations to the database:
initExtension(dbcon)
sql_poke = "SELECT Generation, 
                   STDEV(Attack) AS stdev,
                   AVG(Attack) AS AvgAttacks 
            FROM Pokem 
            GROUP BY Generation"
dbGetQuery(dbcon, sql_poke)
# Which functions:
?initExtension

sql_poke = "SELECT DISTINCT Type_1 FROM Pokem"
dbGetQuery(dbcon, sql_poke)

sql_poke = "SELECT DISTINCT Type_1, Type_2 FROM Pokem"
dbGetQuery(dbcon, sql_poke)

# UNION stacks (and sorts) the values from two queries (duplicates are removed)
sql_poke = "SELECT Type_1 
            FROM Pokem 
            UNION 
            SELECT isLegendary 
            FROM Pokem"
dbGetQuery(dbcon, sql_poke)

# UNION ALL stacks the values from two queries (duplicates are kept)
sql_poke = "SELECT Type_1 
            FROM Pokem 
            UNION ALL 
            SELECT isLegendary 
            FROM Pokem"
dbGetQuery(dbcon, sql_poke)

sqlcheck = "SELECT Type_1, 
                   isLegendary, 
                   COUNT(*) AS NOccurences 
            FROM (SELECT Type_1, isLegendary FROM Pokem)
            GROUP BY Type_1, isLegendary"
dbGetQuery(dbcon, sqlcheck)


# Doing a query on a query
# Sometimes a complex query might be easiest if done in steps.
# A VIEW is a virtual table in the database. 
#Create a query as a VIEW and then call a new query on that VIEW

# Create, find, examine, and remove a VIEW
sql_poke = "CREATE VIEW pokemean 
            AS 
            SELECT Generation,
                   SUM(Attack)/COUNT(Generation) AS myavg, 
                   AVG(Attack) AS AvgAttacks
            FROM Pokem 
            GROUP BY Generation"
dbSendQuery(dbcon, sql_poke)
dbListTables(dbcon)

query_table_info = "PRAGMA table_info('pokemean')"
dbGetQuery(dbcon,query_table_info)
dbSendQuery(dbcon, "drop view pokemean")
dbListTables(dbcon)

# Note that View tables are virtual and unevaluated (they are like pointers)
dbSendQuery(dbcon, "INSERT INTO Pokem (Generation) VALUES ('9')")
dbGetQuery(dbcon, "SELECT * from pokemean")
dbSendQuery(dbcon, "DELETE FROM Pokem WHERE Generation==9")
dbGetQuery(dbcon, "SELECT * from pokemean")

# WITH lets you define a temporary table. It disappears after the query is called.
# Using Temporary Tables
sql_poke = "WITH pokestuff 
            AS 
            (SELECT Generation, 
                    SUM(Attack)/COUNT(Generation) AS myavg, 
                    AVG(Attack) AS AvgAttacks, 
                    STDEV(Attack) AS stdev 
            FROM Pokem)
            SELECT Pokem.Attack, 
                   pokestuff.AvgAttacks , 
                   Pokem.Attack, 
                   pokestuff.AvgAttacks AS Resids 
            FROM pokestuff, Pokem"
(out = dbGetQuery(dbcon, sql_poke))
par(mfrow=c(2,1))
hist(out$Attack,50)
hist(out$Resids,50)
dbDisconnect(dbcon)

#
par(mfrow=c(1,1))
x = c(rnorm(1000,2,1),rnorm(1000,7,1))
hist(x,
     100,
     xlab="x = 2 Normals",
     probability = TRUE,
     main = "100 breaks",
     xlim=c(-4,13))


sprintf('test-%02d.pdf',1)
sprintf('     %d     %f     ', 7, 1.23212)
sprintf('     %05d     %.3f     ', 7, 1.23212)
sprintf('     %05d     %.3e     ', 7, 1.23212)
sprintf('%+d',7)
sprintf('%+d',-7)
?sprintf


x = c(rnorm(1000,2,1),rnorm(1000,7,1))
hist(x,
     100,
     xlab="x",
     probability = TRUE,
     main = "mixture of 2 Normals",
     xlim=c(-4,13))

lines(density(x),col=2,lwd=3)
grid = seq(-4,13,length=1000)
lines(grid,.5*dnorm(grid,2,1,)+.5*dnorm(grid,7,1,),lty=2,col=4,lwd=4)
legend("topleft",
       lty=c(0,1,2),
       col=c(1,2,4),
       c("100 bin histogram","Density","Truth"))



# 2D Density Plot
dbcon = dbConnect(RSQLite::SQLite(),
                  dbname="D:\\Simon Fraser University\\2021 spring\\STAT 240\\Labs\\lab3\\lab03.sqlite")
dbListTables(dbcon)
poke = dbGetQuery(dbcon, "SELECT * FROM Vanpoke")
dbDisconnect(dbcon)

library(MASS)
library(sp)
library(rworldmap)
library(rworldxtra)
worldmap = getMap(resolution = "high")
NrthAm = worldmap[which(worldmap$REGION =="North America"),]
plot(NrthAm,xlim=c(-124,-122.4), ylim=c(48.7,49.6),main = "Vancouver-ish")
points(poke$longitude,poke$latitude,pch='.')
est2 = kde2d(poke$longitude,poke$latitude,n = c(121,150))
contour(est2, add=TRUE,col=2,lwd=3)


# Random samples from a normal distribution
hist(rnorm(1000),
     50,
     main="1000 random samples from the Normal Distribution",
     xlab = "Distance from the Mean in SD units")

