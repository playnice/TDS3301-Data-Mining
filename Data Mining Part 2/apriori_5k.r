#start time
ptm <- proc.time()

library(readr)
#read file and add header for X5000_out1
setwd("C:/Users/User/Desktop/Data Mining Part 2")
X5000_out1 <- read.csv("5000-out1.csv", header=FALSE, col.names = c("ReceiptID", "Item1", "Item2", "Item3", "Item4", "Item5", "Item6", "Item7", "Item8"))

#match the item code with item name
item.code <- c('Chocolate Cake' = 0, 'Lemon Cake' = 1, 'Casino Cake' = 2, 'Opera Cake' = 3, 'Strawberry Cake' = 4, 'Truffle Cake' = 5, 'Chocolate Eclair' = 6, 'Coffee Eclair' = 7, 'Vanilla Eclair' = 8, 'Napoleon Cake' = 9, 'Almond Tart' = 10,'Apple Pie' = 11, 'Apple Tart' = 12, 'Apricot Tart' = 13, 'Berry Tart' = 14, 'Blackberry Tart' = 15, 'Blueberry Tart' = 16, 'Chocolate Tart' = 17, 'Cherry Tart' = 18, 'Lemon Tart' = 19, 'Pecan Tart' = 20,'Ganache Cookie' = 21, 'Gongolais Cookie' = 22, 'Raspberry Cookie' = 23, 'Lemon Cookie' = 24, 'Chocolate Meringue' = 25, 'Vanilla Meringue' = 26, 'Marzipan Cookie' = 27, 'Tuile Cookie' = 28, 'Walnut Cookie' = 29, 'Almond Croissant' = 30,'Apple Croissant' = 31, 'Apricot Croissant' = 32, 'Cheese Croissant' = 33, 'Chocolate Croissant' = 34, 'Apricot Danish' = 35, 'Apple Danish' = 36, 'Almond Twist' = 37, 'Almond Bear Claw' = 38, 'Blueberry Danish' = 39, 'Lemon Lemonade' = 40,'Raspberry Lemonade' = 41, 'Orange Juice' = 42, 'Green Tea' = 43, 'Bottled Water' = 44, 'Hot Coffee' = 45, 'Chocolate Coffee' = 46, 'Vanilla Frappuccino' = 47, 'Cherry Soda' = 48, 'Single Espresso' = 49)

for(i in 2:9){
  X5000_out1[[i]] <- names(item.code)[match(X5000_out1[[i]], item.code)]
}

X5000_out1[is.na(X5000_out1)] <- ""

#change data type of the columns
for(i in 1:9){
  X5000_out1[i] <- sapply(X5000_out1[i], as.factor)
}

#save as new file 
write.csv(X5000_out1,"ItemList5k.csv", row.names = TRUE)

#perform apriori algorithm
library(arules)
trans5k = read.transactions(file="ItemList5k.csv", format="basket",sep=",",cols=1);
rules5k <- apriori(trans5k,parameter=list(minlen = 2,supp = 0.03, conf = 0.7,target="rules"))
quality(rules5k)<-round(quality(rules5k),digits=3) 
#sorted by lift
rules5k.sorted <- sort(rules5k,by="lift")
inspect(rules5k.sorted)
summary(rules5k.sorted)

#plot data
library(arulesViz)
plot(rules5k.sorted)
plot(rules5k, method="grouped")
plot(rules5k.sorted, method="graph")

#stop time
proc.time() - ptm
