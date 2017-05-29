#Part B Question 1

#1
?which.max()

#3
testNumbers = c(3, -1, 4, 2.5)
which.max(testNumbers)

#4
tiedNumbers = c(10, 5, 10, 3)
which.max(tiedNumbers)

#Part B Question 2

#Setup and variable assignment 
setwd("STS98")
list.files()
setwd("assignment-1-nwmn")
list.files()
x = readRDS("mystery.rds")

#Type and Class
typeof(x)
class(x)
dim(x)

#Check for the varible labels
head(x)
