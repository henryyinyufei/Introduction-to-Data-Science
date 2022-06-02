# kmeans for Parkinson's data
data = read.table(file = 'parkinsons.data', sep = ',', header = TRUE)
data = data[,-1]
set.seed(240)
result = kmeans(data, 3)

assignment = result$cluster

plot(data[assignment == 1, 1], data[assignment == 1, 2], col = "blue", xlim = range(data[,1]), ylim = range(data[,2]))
points(data[assignment == 2, 1], data[assignment == 2, 2], col = "red")
points(data[assignment == 3, 1], data[assignment == 3, 2], col = "yellow")


mykmeans = function(x, k, iters){
  N = dim(x)[1]
  D = dim(x)[2]
  
  centres = matrix(NA, k, D)
  clusters = rep(NA, N) # each entry between 1 and K
  
  for (i in 1:N){
    clusters[i] = sample.int(k, 1)
  }
  
  for (iter in 1:iters){
    for (k in 1:k){
      for (d in 1:D){
        centres[k, d] = mean(x[clusters == k, d]) 
      }
    }
    distanceMatrix <- matrix(NA, nrow=N, ncol=k)
    for(i in 1:k) {
      distanceMatrix[,i] <- sqrt(rowSums(t(t(x)-centres[i,])^2))
    }
    clusters <- apply(distanceMatrix, 1, which.min)
    centres <- apply(x, 2, tapply, clusters, mean)
  }
  return(list(locations=centres, assignment=clusters))
}

## missing data
data = read.table(file = 'parkinsons.data', sep = ',', header = TRUE)
data = data[,-1]

N = dim(data)[1]
D = dim(data)[2]

prop = 0.1
for (i in 1:N){
  for (j in 1:D){
    if (runif(1) < prop){
      data[i,j] = NA
    }  
  }
}
sum(is.na(data))
sum(is.na(data)/(N*D))

# fill in missing data with mean
for (d in 1:D){
  mu = mean(data[!is.na(data[, d]), d])
  data[is.na(data[, d]), d] = mu
}
