Assignment 5
setwd("..")
setwd("STS98/assignment-5-team-12/data")

Q1

1
b=read.csv(file="berkeley.csv",header=TRUE)
score = 100 - 4 * (# of minor violations) - 8 * (# of major violations)

b$major_violation=b$Major_Violation_Personal_Hygiene|b$Major_Violation_Inadequate_Cooking|b$Major_Violation_Unsafe_Food_Source|b$Major_Violation_Contaminated_Equipment|b$Major_Violation_Improper_Holding_Temperature,
MajorV=b[10]+b[12]+b[14]+b[16]+b[18]
MinorV=b[11]+b[13]+b[15]+b[17]+b[19]

b$score=100-4*(MinorV)-8*(MajorV)

2

b$violation=(MajorV+MinorV)>0

sort(table(b$violation))

yesV=subset(b,violation==TRUE)

#Setting Up Data

a=readRDS("alameda_merged.rds")

y=readRDS("yolo_merged.rds")

oakland=subset(a,city=="Oakland")

library('rgdal')
library("ggmap")
library("lattice")
library("maps")
library("ggplot2")
library("reshape2")

#scores
levels(a$result)[levels(a$result)=="g"] <- "green"
levels(a$result)[levels(a$result)=="G"] <- "green"
levels(a$result)[levels(a$result)=="r"] <- "red"
levels(a$result)[levels(a$result)=="R"] <- "red"
levels(a$result)[levels(a$result)=="y"] <- "yellow"
levels(a$result)[levels(a$result)=="Y"] <- "yellow"

a_clean=subset(a, result=="green"|result=="yellow"|result=="red")
a_red=subset(a_clean2,red>"0")

# melting

rating = as.data.frame(table(a_clean$business_id, a_clean$result))
summary(rating)
head(rating)
tail(rating)

red = subset(rating, Var2 == "red")
colnames(red) = c("business_id", "trash", "red")
red = red[, c(1,3)]
yellow = subset(rating, Var2 == "yellow")
colnames(yellow) = c("business_id", "trash", "yellow")
yellow = yellow[, c(1,3)]
green = subset(rating, Var2 == "green")
colnames(green) = c("business_id", "trash", "green")
green = green[, c(1,3)]

total_counts = as.data.frame(table(a_clean$business_id))
colnames(total_counts) = c("business_id", "total")

# merging it
type_merge = merge(red, yellow, by = "business_id")
type_merge = merge(type_merge, green, by = "business_id")
type_merge = merge(type_merge, total_counts, by = "business_id")

dim(type_merge)
summary(type_merge)

# merging/adding other data
d = unique(a_clean[c("business_id", "name", "latitude", "longitude", "city")])
d$business_id = as.factor(d$business_id)
summary(d)
dim(d)

a_clean2 = merge(type_merge, d, by = "business_id")
dim(a_clean2)
summary(a_clean2)
head(a_clean2)

# Percentages

e = (((a_clean2$red)+(a_clean2$yellow) /(a_clean2$total)* 100))
e = round(e, digits = 1)
a_clean2$per_neg <- e
a_clean2 <- a_clean2[c("business_id", "name", "city", "followup", "routine", "complaint", "total", "per_negative", "latitude", "longitude")]
summary(a_clean2)

#Exploring Data

#random col that's blank but had 10806 observations. What is it??

#Most Dangerous Restaurants - Alameda (Oakland, Fremont, and San Leandro)
colnames(a)
sort(table(a$city))

a_clean$result <- factor(a_clean$result)
barplot(table(a_clean$result), main="Overall Alameda Results",col=c("chartreuse3","red2","gold"),ylim=c(0,95000),xlab="Color Received by Eatery",ylab="Number of Recorded Results")

  #oakland
oakland=subset(a_clean, city=="Oakland")
barplot(table(oakland$result))
sort(table(oakland$result))
Red: 5.4%
Yellow: 20.7%
Green: 73.9%

  #fremont
fremont=subset(a_clean, city=="Fremont")
barplot(table(fremont$result))
sort(table(fremont$result))
Red: 4.4%
Yellow: 19.7%
Green: 75.9%

  #san leandro
san_leandro=subset(a_clean, city=="San Leandro")
barplot(table(san_leandro$result))
sort(table(san_leandro$result))
Red: 2.5%
Yellow: 17.1%
Green: 80.5%

  #Plotting them
red = c(5.4, 4.4, 2.5)
yellow = c(20.7, 19.7, 17.1)
green = c(73.9, 75.9, 80.5)

bb = data.frame(row.names=c("Oakland", "Fremont", "San Leandro"), "% Of Resaturants with Red Rating" = c(5.4, 4.4, 2.5), "% of Restaurants with Yellow Rating" = c(20.7, 19.7, 17.1),"% of Restaurants with Green Rating" = c(73.9, 75.9, 80.5))
bb
bbb = do.call(rbind, bb)
barplot(bbb, beside = T, las = 1, main="Ratings Recieved by Eateries in Each City", xlab="City", ylab="Percent", names.arg = c("Oakland","Fremont","San Leandro"), col= c("red2", "gold", "chartreuse3"))
legend("topright", c("Total City's Eateries", "Total FNI Eateries (40)"), fill = c("red", "yellow", "green"), title = "Percent Out of:")
?barplot

  # Exploring Descriptions Column
sort(table(a_red$description))

oak_red = subset(a_red,city=="Oakland")
fre_red = subset(a_red,city=="Fremont")
sanl_red = subset(a_red,city=="San Leandro")

tail(sort(table(oak_red$description)))
tail(sort(table(fre_red$description)))
tail(sort(table(sanl_red$description)))

#biggest violation in each era: No rodents, insects, birds, or animals

  # Red Restaurants in Each City

oak_red2 = subset(a_clean2,red>"0"&city=="Oakland")
fre_red2 = subset(a_clean2,red>"0"&city=="Fremont")
sanl_red2 = subset(a_clean2,red>"0"&city=="San Leandro")

head(sort(table(oak_red2$red)))
head(sort(table(fre_red2$red)))
head(sort(table(sanl_red2$red)))

mean(oak_red2$red)
mean(fre_red2$red)
mean(sanl_red2$red)

  # Density Plot
plot(density(a_clean2$per_neg))

  # Graphing Maps

library("maps")
locator(1)
getwd()
map_place = readRDS("shp_place.rds")
observedCities = subset(map_place, map_place$NAME %in% c("Oakland", "Fremont", "San Leandro"))
map_county = readRDS("shp_county.rds")
acounty = subset(map_county,map_county$NAME %in% c("Alameda"))
#map("county","california,alameda", xlim=c(-122.3338,-121.8587))
plot(acounty)
plot(observedCities,add = T)
title("Eateries with Red Results", line = 1)

points(oak_red2$longitude, oak_red2$latitude,col="blue")
points(fre_red2$longitude, fre_red2$latitude,col="red")
points(sanl_red2$longitude, sanl_red2$latitude,col="green")
        
legend("topright",cex = 1, legend = c("Oakland","Fremont","San Leandro"), pch = 19, col = c("blue","red","green")) 


# what types of resturants typically have more violations? are there any trends?

schools <- c("ELEMENTARY", "SCHOOL", "COLLEGE", "ELEM")
schools_sub = grepl(paste(schools,collapse="|"), a_clean2$name)
schools_sub = subset(a_clean2, schools_sub)
summary(schools_sub$red)
# mean:0.01

sweets <- c("CREAM", "SCOOP", "SNO", "DOZEN", "KREME", "COOKIE", "CAKE", "BASKIN", "YOGURT", "DONUT", "DOUNUT", "C. R. E. A. M", "CANDY", "CREAMERY", "DESSERTS")
sweets_sub = grepl(paste(sweets,collapse="|"), a_clean2$name)
sweets_sub = subset(a_clean2, sweets_sub)
summary(sweets_sub$red)
# mean: 0.76

mexican <- c("TACOS", "ACO", "TAMALES", "DOS COYOTES", "DEL TACO", "COCINA", "Y MAS", "ARCOIRIS", "EL ", "LA ", "LAS ", "LOS ", "TAQUERIA", "BARAJAS", "CASA", "MEXICAN", "MEXICO", "BURRITO")
mexican_sub = grepl(paste(mexican,collapse="|"), a_clean2$name)
mexican_sub = subset(a_clean2, mexican_sub)
summary(mexican_sub$red)
# mean: 0.52

store <- c("WALMART", "WHOLE FOODS", "SAFEWAY"," FOOD 4", "FOOD STORE", "COSTCO",  "MARKET", "SUPERMARKET", "BEL AIR", "BUTCHER", "GROCERIES", "GROCERY OUTLET", "GROCERY")
store_sub = grepl(paste(store,collapse="|"), a_clean2$name)
store_sub = subset(a_clean2, store_sub)
summary(store_sub$red)
# mean: 0.6

hotel <- c("SUITES", "ALL STARS", "RESORT", "BED &", "HOLIDAY 6", "INN", "ECONO", "MOTEL")
hotel_sub = grepl(paste(hotel,collapse="|"), a_clean2$name)
hotel_sub = subset(a_clean2, hotel_sub)
summary(hotel_sub$red)
# mean: 0.13

chinese <- c("HUNAN", "WOK", "CHINA", "NOODLE CITY", "DING HOW", "GOLDEN", "RICE", "ORIENT", "PANDA")
chinese_sub = grepl(paste(chinese,collapse="|"), a_clean2$name)
chinese_sub = subset(a_clean2, chinese_sub)
summary(chinese_sub$red)
# mean: 1.672

eastthai <- c("ALI BABA", "CHICKPEAS", "KABAB", "KATHMANDU", "BANGKOK", "THAI", "INDIAN", "CURRY")
eastthai_sub = grepl(paste(eastthai,collapse="|"), a_clean2$name)
eastthai_sub = subset(a_clean2, eastthai_sub)
summary(eastthai_sub$red)
# mean: 1.714

italian <- c("VITO'S", "PIZZA", "ITALIAN", "CAESARS")
italian_sub = grepl(paste(italian,collapse="|"), a_clean2$name)
italian_sub = subset(a_clean2, italian_sub)
summary(italian_sub$red)
# mean:0.51

american <- c("WINGSTOP", "WIENERSCHNITZEL", "CAFE", "SANDWICH", "KOUNTRY", "McDONALDS", "KENTUCKY", "JACK IN", "IHOP", "FAT FACE", "BARBECUE", "DENNY'S", "CREPEVILLE", "WAFFLES", "CORKWOOD", "CARL'S", "CAROL'S", "BURGERS", "BURGER", "BAR & GRILL", "ROADHOUSE", "AGGIE", "APPLEBEE", "BARISTA", "BEACH HUT", "33", "DINER")
american_sub = grepl(paste(american,collapse="|"), a_clean2$name)
american_sub = subset(a_clean2, american_sub)
summary(american_sub$red)
# mean:0.5225

japan <- c("TERIYAKI", "SUSHI", "BAMBU", "JAPANESE", "MOSHI")
japan_sub = grepl(paste(japan,collapse="|"), a_clean2$name)
japan_sub = subset(a_clean2, japan_sub)
summary(japan_sub$red)
# mean:1.007 

convenience <- c("KWIK", "FAST & EASY",  "MART", "QUICK", "VALERO", "1 STOP", "CIRCLE K", "7-ELEVEN", "MINI MART", "MART", "GAS", "SHELL", "ARCO", "AM/PM", "LIQUOR", "76")
convenience_sub = grepl(paste(convenience,collapse="|"), a_clean2$name)
convenience_sub = subset(a_clean2, convenience_sub)
summary(convenience_sub$red)
# mean: 0.08

cater <- c("ASTE TO DINE", "CATERING", "AMBROSIA")
cater_sub = grepl(paste(cater,collapse="|"), a_clean2$name)
cater_sub = subset(a_clean2, cater_sub)
summary(cater_sub$red)
# mean:0.08

style_mean = round(c(0.08,0.08,1.01,0.52,0.51,1.71,1.67,0.13,0.6,0.52,0.76,0.01), digits = 1) 
range(style_mean)


par(mar=c(4.1, 7.1, 4.1, 2.1))
barplot(style_mean, names.arg = c("Catering", "Gas/Mini Mart", "Japanese", "American", "Italian", "Eastern/Thai", "Chinese", "Hotel/Inn", "Food Store", "Mexican", "Sweets", "Schools"), las = 1, horiz = T, main = "Violations by Type of Food Sold", xlim = c(0, 2), col="powderblue", xlab="Average Number of Violations")

# Extra

japan <- c("TERIYAKI", "SUSHI", "BAMBU", "JAPANESE", "MOSHI")
japan_sub2 = grepl(paste(japan,collapse="|"), a_clean$name)
japan_sub2 = subset(a_clean,japan_sub2)

# Berkeley

# set up
setwd("..")
setwd("STS98/assignment-5-team-12/data")
b = readRDS("berkeley.rds")
summary(b)

# Density of Score
plot(density(b$scoreNumber),main="Berkeley Score Density",xlab="Score")
# because they were all either 86, 92, and 96, it only shows 

# All of the data given to us with Berkeley has at least one type of violation

b2$total_majorV=(b2$Major_Violation_Personal_Hygiene+b2$Major_Violation_Inadequate_Cooking+b2$Major_Violation_Unsafe_Food_Source+b2$Major_Violation_Contaminated_Equipment+b2$Major_Violation_Improper_Holding_Temperature)
b2$total_minorV=(b2$Minor_Violation_Personal_Hygiene+b2$Minor_Violation_Inadequate_Cooking+b2$Minor_Violation_Unsafe_Food_Source+b2$Minor_Violation_Contaminated_Equipment+b2$Minor_Violation_Improper_Holding_Temperature)

sort(table(b2$total_majorV))
# only 14 restaurants have Major violations
sort(table(b2$total_minorV))
# 23 restaurants have 2 minor violations, and 83 have 1

MajorV=subset(b2,total_majorV=="1")
sort(table(MajorV))

sort(table(MajorV$total_minorV))
# only two major violating restaurants have a minor violation as well

# Barplots
barplot(table(b2$total_majorV),col=c("pink","yellow"),xlab="Number of Major Violations",main="Major Violations in Berkeley",ylab="Number of Eateries")
barplot(table(b2$total_minorV),col=c("gray","orange","blue"),xlab="Number of Minor Violations per Eatery",main="Minor Violations in Berkeley",ylab="Number of Eateries")