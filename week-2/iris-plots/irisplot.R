iris
colnames(iris)
pairs(iris[1:4], main = "Edgar Anderson's Iris Data", pch = 21, bg = c("orange", "purple", "grey")[unclass(iris$Species)])

