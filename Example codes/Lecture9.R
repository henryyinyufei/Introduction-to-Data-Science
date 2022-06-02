# vector VS. list
x = c(1,2,3,4)
x
x[1]
x[4]

y = list(7,8,9)
y

z = c(c(1,2,3),c(4,5,6))
z

aa = c()
for (i in 1:20){
  aa = c(aa, i)
}
aa

f = function() {
  a = c(7,8,9)
  b = c(5,5)
  text = "hello"
  result = list(list(a,b), text)
  return(result)
}
x = f()
x[[1]]
x[[1]][[1]]
x[[1]][[2]]

x = list(left = c(1,2,3), right = c(4,5,6))
x
x$left
x$right
x[[1]]

a = c(7,8,9)
b = c(5,5)
x = list(a,b)
x
unlist(x)

y = c(7,8,9,5,5)
as.list(y)

# translink
load("D:/Simon Fraser University/2021 spring/STAT 240/Labs/lab6/translink.RData")

lengths = function(){
  ll = c()
  xx = c()
  for (i in 1:length(data)){
    ll = c(ll, nchar(data[[i]]$text))
    xx = c(xx, data[[i]]$created)
  }
  return(data.frame(xx = xx, ll = ll))
}

ll = lengths()
plot(ll$ll)

# shinyapp
# SFTP client
# software: cyberduck
















