# Assignment 5 #

####NOTES about research question: 
# he wants us to compare city by city 
# what factors seem tied with higher sanitary scores? what factors predict low scores? 
### attach type of to variables to examine? can't figure it out!

# does geographic location matter? population density? urban or non urban? downtown vs outskirts? 
# type of food offered - you could estimate this by using text search function. 
# college towns - is the food more sanitary? are the types of food offered different? 
# is there a relationship between geopgrahic location and health inspection score? If not, what factors do seem to have a relationship with score?

#### Set Up
getwd()
setwd("C:/Users/Marie/Desktop/STS 98")
list.files()
library(rgdal)
library("ggmap")
library("lattice")
library("maps")
library("ggplot2")
library("reshape2")
library("latticeExtra")
map_county = readRDS("data/shp_county.rds")
map_place = readRDS("data/shp_place.rds")

palette = c("#fff7fb", "#ece2f0","#d0d1e6","#a6bddb","#67a9cf","#3690c0","#02818a","#016c59","#014636", "black")
c1 = rgb(0,0,200, max = 255, alpha = 60)
c2 = rgb(0,200,0, max = 255, alpha = 60)
c3 = rgb(200,0,0, max = 255, alpha = 60)

yo = readRDS("assignment-5-team-12/data/yolo_merged.rds")
yo

#### Convert date into R-recognizable time
summary(yolo)
typeof(yo$date)

fixed_date <- as.numeric(yo$date)
fixed_date <- as.Date(as.character(yo$date), "%Y%m%d")
yo$date <- fixed_date
range(yo$date, na.rm = T)
summary(yo)
head(yo)
# a range of about 9.3 years

#### Breaking down "Type" Variable
followup = as.data.frame(table(yo$business_id, yo$type))
summary(followup)
head(followup)

fol = subset(followup, Var2 == "followup")
summary(fol)
colnames(fol) = c("business_id", "type_followup", "followup")
summary(fol)
fol = fol[, c(1,3)]

rou = subset(followup, Var2 == "routine")
colnames(rou) = c("business_id", "type_routine", "routine")
rou = rou[, c(1,3)]

com = subset(followup, Var2 == "complaint")
colnames(com) = c("business_id", "type_complaint", "complaint")
com = com[, c(1,3)]

total_counts = as.data.frame(table(yo$business_id))
colnames(total_counts) = c("business_id", "total")

# now I'll merge it all
type_merge = merge(fol, rou, by = "business_id")
type_merge = merge(type_merge, com, by = "business_id")
type_merge = merge(type_merge, total_counts, by = "business_id")

dim(type_merge)
summary(type_merge)

# merging/adding other data
a = unique(yo[c("business_id", "name", "latitude", "longitude", "city")])
summary(a)
dim(a)

yolo = merge(type_merge, a, by = "business_id")
dim(yolo)
summary(yolo)
head(yolo)

# adding percentages for followups out of total health inspection visits
a = (((yolo$followup + yolo$complaint) /(yolo$total)* 100))
a = round(a, digits = 1)
yolo$per_negative <- a
yolo <- yolo[c("business_id", "name", "city", "followup", "routine", "complaint", "total", "per_negative", "latitude", "longitude")]
summary(yolo)
# changing Sac places to NAs because they don't belong in Yolo County analysis
subset(yolo, city == "Sacramento")
yo = subset(yo, !city == "Sacramento")
summary(yolo)
dim(yolo)
table(yolo$total)
subset(yolo, name == "DING HOW RESTAURANT")
(IQR(yolo$total))+median(yolo$total)

summary(yo$description)
table(yo$description)
yo_melt = melt(yo)
yo_melt = subset(yo_melt, type == "complaint" | type == "followup")
a = tail(sort(table(yo_melt$description)), 4)
dotplot(a, main = "Common Descriptions of Violation & Complaint Inspections", cex = 1.2, xlab = "Frequency", ylab = "Description per Violation")
Premises personal/cleaning items vermin-proofing 

#### Now that I've got some useable data, let's explore it...
# BIG CITY POPS: Davis (66,205), Woodland (56,590), West Sac(49,891),
# SMALL CITY POP: Winters (6,892)
204593 - 66205 - 56590- 49891 - 6892
# CENSUS DESIGNATED PLACES: Clarksburg, Dunnigan, Esparto, Guinda, Knights Landing, Madison
# note that Sacramento listings will be ignored because not in Yolo County... :(
summary(yolo$city)
summary(yolo)
dim(yolo)
range(yolo$followup)
mean(yolo$followup)
# Yolo county mean is 4.578372

#### Overall scores by city
dav = subset(yolo, city == "Davis")
wood = subset(yolo, city == "Woodland")
westsac = subset(yolo, city == "West Sacramento")
wint = subset(yolo, city == "Winters")
other = subset(yolo, !city == "Davis" & !city == "Woodland" & !city== "West Sacramento" & !city== "Winters")

# looking just at followups
boxplot(dav$followup, wood$followup, westsac$followup, wint$followup, other$followup, las = 1, col = c("#fff7fb", "#ece2f0","#d0d1e6","#a6bddb","#67a9cf"), main = "Distribution of Inspections Due to Major Violations", xlab = "City", ylab = "Number of Follow Ups", names = c("Davis", "Woodland", "West Sac", "Winter", "Other"))
abline(h = 4.8)
mean(yolo$followup)
# line of the overall yolo follow up mean

# looking just at followups
boxplot(dav$per_negative, wood$per_negative, westsac$per_negative, wint$per_negative, other$per_negative, las = 1, col = c("#fff7fb", "#ece2f0","#d0d1e6","#a6bddb","#67a9cf"), main = "Distribution of Percent Negative Inspections", xlab = "City", ylab = "PNI Scores (Percent)", names = c("Davis", "Woodland", "West Sac", "Winter", "Other"))
abline(h = 15.5)
mean(yolo$per_negative)
# line of the overall yolo follow up mea

par(mar=c(4,4,4,4))

# looking at complaints now...
boxplot(dav$complaint, wood$complaint, westsac$complaint, wint$complaint, other$complaint, las = 1, col = c("#fff7fb", "#ece2f0","#d0d1e6","#a6bddb","#67a9cf"), main = "Distribution of Inspections Due to Complaints", xlab = "City", ylab = "Number of Complaints", names = c("Davis", "Woodland", "West Sac", "Winter", "Other"))
abline(h = 0.7)
summary(yolo$complaint)
range(yolo$complaint)
57/(sd(yolo$complaint)*3)
subset(yolo, complaint == 57)

# line of the overall yolo complaint mean

#### looking at high percent negtive eateries
a = quantile(yolo$per_negative)
b = quantile(yolo$per_negative)[4] - quantile(yolo$per_negative)[2]
a[4] + b # = 34.5
# IQR is 13.4 and IQR range is more than 34.5% percent negative visits (followups + complaints/total)
boxplot(yolo$per_negative, main = "Percent Negative-Based Inspections in Yolo", ylab = "Percent", col = "#ece2f0")
abline(h = 27.3)
summary(yolo$per_negative)
IQR(yolo$per_negative)
12.5+ (median(yolo$per_negative))
# line is of the 1.5 IQR
# some dots are overlapping. 

high_neg = subset(yolo, per_negative > 27.3)
summary(high_neg)
dim(high_neg)
summary(yolo)
#92 establishments are above the 1.5 IQR (based on percent of negative visits)
# all these had median 9 and mean 11 follow ups, in contrast with the overal median of 3 and mean 4.5 overall

#### where are the most dangerous restauraunts? looking at neg_percents for visits that are above 1.5 IQR
# 40% or 37 of all outliers are in Davis, this is 14.3% of Davis's restauraunts
a = subset(high_neg, city == "Davis")
summary(a)
range(a$per_negative)
37/92
37/259
37/792
a = subset(yolo, city == "Davis" & per_negative == 57.4)
# worst Davis = SYMPOSIUM RESTAURANT

# 29.3% or 27 of all outliers are in Woodland, this is 11.9% of the city's total restauraunts
a = subset(high_neg, city == "Woodland")
summary(a)
range(a$per_negative)
27/92
27/227
27/792
a = subset(yolo, city == "Woodland" & per_negative == 53.1)
# worst Woodland = JACKPOT MARKET & DELI

# 23.9% or 22 of all outliers are in W. Sac, this is 10.0% of the city's total restauraunts
a = subset(high_neg, city == "West Sacramento")
summary(a)
range(a$per_negative)
22/92
22/220
22/792
a = subset(yolo, city == "West Sacramento" & per_negative == 44.4)
# worst West Sacramento = BIG KAHUNA YOGURT

# 10.5% or 1 of all outliers are in Winters, this is 4.3% of the Winter's total restauraunts
a = subset(high_neg, city == "Winters")
summary(a)
range(a$per_negative)
4/92
4/38
4/792
a = subset(yolo, city == "Winters" & per_negative == 42.9)
# worst Winters = WINTERS COUNTRY MARKET

# 4.2% or 2 of the outliers are in a non-city, this is 2.2% of all non-city establishments
a = subset(high_neg, !city == "Davis" & !city == "Woodland" & !city== "West Sacramento" & !city== "Winters")
summary(a)
dim(a)
range(a$per_negative)
2/92
2/48
2/792
a = subset(yolo, !city == "Davis" & !city == "Woodland" & !city== "West Sacramento" & !city== "Winters")
dim(a)
a = subset(yolo, !city == "Davis" & !city == "Woodland" & !city== "West Sacramento" & !city== "Winters" & per_negative == 50.0)
# worst non-city = MADISON HIGH SCHOOL (note, only one follow up after only one routine visit...)

high_per_city = c(14.3, 10.0, 10.0, 4.3, 2.2)
high_per_outliers = c(40, 23.9, 23.9, 10.5, 4.2)
high_per_yolo = c(2.8, )

par(mar=c(5.1, 5.8, 4.1, 2.1))

bb = data.frame(row.names=c("Davis", "Woodland", "West Sac.", "Winters", "Other"), "% Of Total City Eateries" = c(6.2, 5.3, 4.1, 2.6, 4.2), "% of Total Dangerous Eateries" = c(40, 30.0, 22.5, 2.5, 5))
bb
bbb = do.call(rbind, bb)
barplot(bbb, horiz = TRUE, beside = T, las = 1, xlim=c(0,50), main="Highly Unsanitary Eateries in Yolo County",  xlab="Percent", names.arg = c("Davis", "Woodland", "West Sac.", "Winters", "Other"), col= c("#d0d1e6", "#016c59"))
legend("topright", c("Total City's Eateries", "Total Highly Unsanitry Eateries (92)"), fill = c("#d0d1e6", "#016c59"), title = "Percent Out of:")
?barplot

#### what are the most dangerious restauraunts? (examined all across Yolo)
summary(yolo)
dim(yolo)
c = table(yolo$per_negative)
tail(c, n = 82)

# looking worst 8 eateries which is the top 1% of neg_visit ratings 
# they have percentages above 46%
a = subset(yolo, per_negative > 46)
a
# rename annoyingly long name
levels(a[ ,2]) <- c(levels(a[ ,2]),"THE BLACK PEARL")
a[6 ,2] <- "THE BLACK PEARL"

a$name <- as.character(a$name)
a$name[a$name == "MADISON HIGH SCHOOL"] = "MADISON HIGH SCHOOL (MADISON)"
a$name[a$name == "DAVIS HOLIDAY 6"] = "DAVIS HOLIDAY 6 (DAVIS)"
a$name[a$name == "SYMPOSIUM RESTAURANT"] = "SYMPOSIUM RESTAURANT (DAVIS)"
a$name[a$name == "JACKPOT MARKET & DELI"] = "JACKPOT MARKET & DELI (WOODLAND)"
a$name[a$name == "FAT FACE"] = "FAT FACE (DAVIS)"
a$name[a$name == "YETI RESTAURANT"] = "YETI RESTAURANT (DAVIS)"
a$name[a$name == "THE BLACK PEARL"] = "THE BLACK PEARL (WOODLAND)"
a$name[a$name == "UVAGGIO"] = "UVAGGIO (WOODLAND)"

# plot it
par(mar=c(5.1, 4.1, 4.1, 2.1))
dotplot(a$name ~ a$per_negative, col = c("#016c59"), main = "Yolo's Worst 1% PNI Scores", xlim = c(46,58), xlab = "Percent (Negative Insp. / Total Insp.)", ylab = "Restaurant Name", pch = c(19), cex = 1, auto.key=list(space="top", columns=3, title="City", cex.title=1))
?barplot
dim(yolo)

# map these on a graph... (show top 10%)
# top 10% have percent negative of 23.4
top10_negper = subset(yolo, per_negative >= 23.4)
summary(top10_negper)
map("county", "california,yolo", col = "grey", fill = TRUE, mar = c(1,1,1,1), xlim = c(-121.829, -121.5118), ylim = c(38.49508, 38.72218))
points(top10_negper$longitude, top10_negper$latitude, col = c3, pch = 19, cex = 1.3)
title("Locations of Top 10% Frequent Negative Inspections", line = 1)
legend("topright", cex = 1.3, legend = "Eatery", pch = 19, col = c3)
a = subset(place_maps, county == "Yolo")
plot(a, add = T)
text(-121.7358, 38.62358, labels = "      Yolo County", cex = 2, col = "white")
text(-121.7489, 38.71191, labels = "Woodland")
text(-121.7521, 38.52203, labels = "      Davis")
text(-121.5895, 38.61351, labels = "       West Sacramento")


#### what types of resturants typically have more violations? are there any trends?
sort(yolo$name)

schools <- c("ELEMENTARY", "SCHOOL", "COLLEGE", "ELEM")
schools_sub = grepl(paste(schools,collapse="|"), yolo$name)
schools_sub = subset(yolo, schools_sub)
summary(schools_sub$followup)
# school median 1.0 / mean 1.5
a = "school"
a = as.factor(a)
schools_sub$type <- a 
schools_sub_merge = schools_sub[, c(1, 11)]

sweets <- c("CREAM", "SCOOP", "SNO", "DOZEN", "KREME", "COOKIE", "CAKE", "BASKIN", "YOGURT", "DONUT", "DOUNUT", "C. R. E. A. M", "CANDY", "CREAMERY", "DESSERTS")
sweets_sub = grepl(paste(sweets,collapse="|"), yolo$name)
sweets_sub = subset(yolo, sweets_sub)
summary(sweets_sub$followup)
# sweets median 4.0 / mean 4.56
a = "sweets"
a = as.factor(a)
sweets_sub$type <- a 
sweets_sub_merge = sweets_sub[, c(1, 11)]

mexican <- c("TACOS", "ACO", "TAMALES", "DOS COYOTES", "DEL TACO", "COCINA", "Y MAS", "ARCOIRIS", "EL ", "LA ", "LAS ", "LOS ", "TAQUERIA", "BARAJAS", "CASA", "MEXICAN", "MEXICO", "BURRITO")
mexican_sub = grepl(paste(mexican,collapse="|"), yolo$name)
mexican_sub = subset(yolo, mexican_sub)
summary(mexican_sub$followup)
# mexican median 6.0 / mean 7.58
a = "mexican"
a = as.factor(a)
mexican_sub$type <- a 
mexican_sub_merge = mexican_sub[, c(1, 11)]


store <- c("WALMART", "WHOLE FOODS", "SAFEWAY"," FOOD 4", "FOOD STORE", "COSTCO",  "MARKET", "SUPERMARKET", "BEL AIR", "BUTCHER", "GROCERIES", "GROCERY OUTLET", "GROCERY")
store_sub = grepl(paste(store,collapse="|"), yolo$name)
store_sub = subset(yolo, store_sub)
summary(store_sub$followup)
# store median 4.0 / mean 5.36
a = "grocery_store"
a = as.factor(a)
store_sub$type <- a 
store_sub_merge = store_sub[, c(1, 11)]

hotel <- c("SUITES", "ALL STARS", "RESORT", "BED &", "HOLIDAY 6", "INN", "ECONO", "MOTEL")
hotel_sub = grepl(paste(hotel,collapse="|"), yolo$name)
hotel_sub = subset(yolo, hotel_sub)
summary(hotel_sub$followup)
# hotel median 2.0 / mean 3.09
a = "hotel"
a = as.factor(a)
hotel_sub$type <- a 
hotel_sub_merge = hotel_sub[, c(1, 11)]


chinese <- c("HUNAN", "WOK", "CHINA", "NOODLE CITY", "DING HOW", "GOLDEN", "RICE", "ORIENT", "PANDA")
chinese_sub = grepl(paste(chinese,collapse="|"), yolo$name)
chinese_sub = subset(yolo, chinese_sub)
summary(chinese_sub$followup)
# chinese median 3.0 / mean 5.82
a = "chinese"
a = as.factor(a)
chinese_sub$type <- a 
chinese_sub_merge = chinese_sub[, c(1, 11)]

eastthai <- c("ALI BABA", "CHICKPEAS", "KABAB", "KATHMANDU", "BANGKOK", "THAI", "INDIAN", "RAJA'S")
eastthai_sub = grepl(paste(eastthai,collapse="|"), yolo$name)
eastthai_sub = subset(yolo, eastthai_sub & !name == "TARAD THAI MARKET" & !name == "KATHMANDU KITCHEN - CATERING" & !name == "CHAND'S INDIAN GROCERIES")
summary(eastthai_sub$followup)
# eastthai median 6.0 / mean 9.84
a = "eastern_thai"
a = as.factor(a)
eastthai_sub$type <- a 
eastthai_sub_merge = eastthai_sub[, c(1, 11)]

italian <- c("VITO'S", "PIZZA", "ITALIAN", "CAESARS")
italian_sub = grepl(paste(italian,collapse="|"), yolo$name)
italian_sub = subset(yolo, italian_sub)
summary(italian_sub$followup)
# italian median 4.0 / mean 4.21
a = "italian"
a = as.factor(a)
italian_sub$type <- a 
italian_sub_merge = italian_sub[, c(1, 11)]


american <- c("WINGSTOP", "WIENERSCHNITZEL", "CAFE", "SANDWICH", "KOUNTRY", "McDONALDS", "KENTUCKY", "JACK IN", "IHOP", "FAT FACE", "BARBECUE", "DENNY'S", "CREPEVILLE", "WAFFLES", "CORKWOOD", "CARL'S", "CAROL'S", "BURGERS", "BURGER", "BAR & GRILL", "ROADHOUSE", "AGGIE", "APPLEBEE", "BARISTA", "BEACH HUT", "33", "DINER")
american_sub = grepl(paste(american,collapse="|"), yolo$name)
american_sub = subset(yolo, american_sub)
summary(american_sub$followup)
# american median 6.0 / mean 6.27
a = "american"
a = as.factor(a)
american_sub$type <- a 
american_sub_merge = american_sub[, c(1, 11)]

japan <- c("TERIYAKI", "SUSHI", "BAMBU", "JAPANESE", "MOSHI")
japan_sub = grepl(paste(japan,collapse="|"), yolo$name)
japan_sub = subset(yolo, japan_sub)
summary(japan_sub$followup)
# japan median 3.0 / mean 6.17
a = "japanese"
a = as.factor(a)
japan_sub$type <- a 
japan_sub_merge = japan_sub[, c(1, 11)]

convenience <- c("KWIK", "FAST & EASY",  "MART", "QUICK", "VALERO", "1 STOP", "CIRCLE K", "7-ELEVEN", "MINI MART", "MART", "GAS", "SHELL", "ARCO", "AM/PM", "LIQUOR", "76")
convenience_sub = grepl(paste(convenience,collapse="|"), yolo$name)
convenience_sub = subset(yolo, convenience_sub)
summary(convenience_sub$followup)
# gas mart median 3.0 / mean 4.25
a = "gas/mini_mart"
a = as.factor(a)
convenience_sub$type <- a 
convenience_sub_merge = as.data.frame(convenience_sub[, c(1, 11)])


cater <- c("ASTE TO DINE", "CATERING", "AMBROSIA", "CATER")
cater_sub = grepl(paste(cater,collapse="|"), yolo$name)
cater_sub = subset(yolo, cater_sub)
summary(cater_sub$followup)
# hotel median 0.0 / mean 0.17
a = "cater"
a = as.factor(a)
cater_sub$type <- a 
cater_sub_merge = as.data.frame(cater_sub[, c(1, 11)])

style_mean = round(c(0.2, 4.3, 6.17, 6.27, 4.21, 9.84, 5.82, 3.09, 5.36, 7.58, 4.56, 1.5), digits = 1) 
style_median = round(c(0.0, 3.0, 3.0, 6.0, 4.0, 6.0, 3.0, 2.0, 4.0, 6.0, 4.0, 1.0), digits = 1)
range(style_mean)
range(style_median)

par(mar=c(4.1, 7.1, 4.1, 2.1))
barplot(style_mean, names.arg = c("Catering", "Gas/Mini Mart", "Japanese", "American", "Italian", "Eastern/Thai", "Chinese", "Hotel/Inn", "Food Store", "Mexican", "Sweets", "Schools"), las = 1,horiz = T, col = c1, xlab = "Number of Follow Up Inspections", main = "Follow Up Inspections by Type of Eatery", xlim = c(0, 10))
barplot(style_median, horiz = T, add = T, col = c2)
legend("topright", c("Mean", "Median"), fill = c(c1, c2), cex = .9)
?barplot

## ROUND 2, looking at neg_percent instead...
summary(schools_sub$per_negative)
# school median 5.0 / mean 8.2

summary(sweets_sub$per_negative)
# sweets median 16.7 / mean 16.7

summary(mexican_sub$per_negative)
# mexican median 18.2 / mean 17.7

summary(store_sub$per_negative)
# store median 15.7 / mean 16.6

summary(hotel_sub$per_negative)
# hotel median 13.9 / mean 14.8

summary(chinese_sub$per_negative)
# chinese median 11.1 / mean 12.2

summary(eastthai_sub$per_negative)
# eastthai median 17.1 / mean 17.8

summary(italian_sub$per_negative)
# italian median 14.0 / mean 15.1

summary(american_sub$per_negative)
# american median 16.9 / mean 18.3

summary(japan_sub$per_negative)
# japan median 16.7 / mean 15.4

summary(convenience_sub$per_negative)
# gas mart median 13.6 / mean 14.4

summary(cater_sub$per_negative)
# cater median 0.0 / mean 1.8

style_mean_per = round(c(1.8, 14.4, 15.4, 18.3, 15.1, 17.8, 12.2, 14.8, 16.6, 17.7, 16.7, 8.2), digits = 1) 
style_median_per = round(c(0.0, 13.6, 16.7, 16.9, 14.0, 17.1, 11.1, 13.9, 15.6, 18.2, 16.7, 5.0), digits = 1)
range(style_mean_per)
range(style_median_per)

par(mar=c(4.1, 7.1, 4.1, 2.1))
barplot(style_mean_per, names.arg = c("Catering", "Gas/Mini Mart", "Japanese", "American", "Italian", "Eastern/Thai", "Chinese", "Hotel/Inn", "Food Store", "Mexican", "Sweets", "Schools"), las = 1,horiz = T, col = c1, xlab = "Percent", main = "PNI Scores by Type of Eatery", xlim = c(0, 20))
barplot(style_median_per, horiz = T, add = T, col = c2)
legend("bottomright", c("Mean", "Median"), fill = c(c1, c2), cex = .9)
?barplot
# in analysis, need to compare these two bar charts... (follow up visits by %_FNIs)

#### Comparing cities
davis = subset(yolo, city == "Davis")
woodland = subset(yolo, city == "Woodland")
w_sac = subset(yolo, city == "West Sacramento")
summary(yolo)

# setting up map basics
palette = c("#fff7fb", "#ece2f0","#d0d1e6","#a6bddb","#67a9cf","#3690c0","#02818a","#016c59","#014636", "black")
map("county", "california,yolo", col = "grey", fill = TRUE)

# showing all restauraunt violations in terms of followup inspections
br = c(0, 1, 3, 5, 7, 9, 11, 13, Inf)
col = cut(yolo$followup, br)
col
map("county", "california,yolo", col = "grey", fill = TRUE, mar = c(1,1,1,1))
points(yolo$longitude, yolo$latitude, col = palette[2:10], pch = 19, cex = 1)
title("Number of Follow Up Inspections in Yolo County", line = 1)
legend("bottomleft", cex = 1, legend = c("0", "1-2", "3-4", "5-6", "7-8", "9-10", "11-12", "13+"), pch = 19, col = palette[2:10])
a = subset(place_maps, county == "Yolo")
plot(a, add = T)
text(-121.7489, 38.71191, labels = "Woodland")
text(-121.7521, 38.52203, labels = "      Davis")
text(-121.7113, 38.61953, labels = "                 West Sacramento")
text(-122.0448, 38.92361, labels = "                   Dunnigan")
text(-122.0301, 38.56565, labels = "             Winters")
text(-122.0612, 38.72859, labels = "        Esparto")
text(-121.587, 38.44761, labels = "   Clarksburg")

# zooming into major cities
br = c(0, 10, 20, 30, 40, 50, Inf)
col = cut(yolo$per_negative, br)
col
map("county", "california,yolo", col = "grey", fill = TRUE, mar = c(1,1,1,1), xlim = c(-121.829, -121.5118), ylim = c(38.49508, 38.72218))
points(yolo$longitude, yolo$latitude, col = palette[2:10], pch = 19, cex = .8)
title("Number of Follow Up Inspections in Major Cities", line = 1)
legend("topright", cex = 1, legend = c("0", "1-2", "3-4", "5-6", "7-8", "9-10", "11-12", "13+"), pch = 19, col = palette[2:10])
a = subset(place_maps, county == "Yolo")
plot(a, add = T)
text(-121.7489, 38.71191, labels = "Woodland")
text(-121.7521, 38.52203, labels = "      Davis")
text(-121.5895, 38.61351, labels = "       West Sacramento")

# use place_shp data to show averages

####
plot(density(mexican_sub$per_negative, na.rm = T), las = 1, col = "red", lty = 1, lwd = 2, main = "Distribution of Top 3 Worst Eatery Types in Yolo County", xlab = "Percent of Inspections Due to Violations and/or Complaints", xlim = c(3, 50))
lines(density(american_sub$per_negative, na.rm = 1), lty = 1, lwd = 2, col = "blue")
lines(density(eastthai_sub$per_negative, na.rm =1), lty = 1, lwd = 2, col = "green")

yolo_clean = subset(yolo, !yolo$name %in% c())
lines(density(yolo$per_negative, na.rm = 1), lty = 3, lwd = 2, col = "black")
legend("topright", legend = c("Mexican", "American", "Middle Eastern/Thai", "Overall"), col = c("red", "blue", "green", "black"), lty = c(1, 1, 1, 3), lwd = 2)
locator(1)

#### 
summary(yolo$city)
summary(yolo$per_negative)
range(perneg_yolo)
sort(perneg_yolo)

select_perneg_yolo = subset(perneg_yolo, city %in% yolo_cities)


#### Bin scores into 4 
# good 
# adequate
# needs improvement
# poor
                       
plot(density(yolo$per_negative), xlim = rev(c(0,65)), main = "Distribution of Yolo's PNI", xlab = "Percent Out of Total Inspections")               
locator(1)
range(yolo$per_negative)
?density
?rev

sfbay = c("San Francisco", "San Mateo", "Santa Clara", "Contra Costa", "Alameda", "Napa", "Solano", "Sonoma", "Marin")
#sfbay = tolower(sfbay)
#sfbay = paste("california",sfbay, sep = ',')
#sfbay = map("county", sfbay, namesonly = TRUE)
library("rje")

yolo_place = subset(map_place, map_place$NAME %in% yolo_cities)
summary(yolo_place)
yolo_county = subset(map_county, NAME == "Yolo")
data_yolocounty = subset(yolo, yolo$city %in% yolo_cities)

#nrow(data_sfbay)
data_yolocounty$city = droplevels(data_yolocounty$city)
perneg_yolo = tapply(yolo$per_negative, yolo$city, mean)
summary(perneg_yolo)
br = c(-Inf, 7, 11, 15, 19, Inf)
perneg_yolo = perneg_yolo[as.character(yolo_place$NAME)]
col = cut(perneg_yolo, br, dig.lab = 10)

par(mar = c(rep(1,4)))

plot(yolo_county, col = "grey")
plot(yolo_place, col = palette[col], add = T)
title("Percent Means of Negative Inspections in Yolo County", line = -1)
text(-121.7489, 38.71191, labels = "Woodland")
text(-121.7521, 38.52203, labels = "      Davis")
text(-121.5895, 38.61351, labels = "          West Sac.")
text(-122.057, 38.72793, labels = "       Esparto")
text(-122.0049, 38.86349, labels = "            Dunnigan")
text(-121.5995, 38.44447, labels = "    Clarksburg")
text(-122.0321, 38.56921, labels = "     Winters")
text(-122.0333, 38.78339, labels = "      Yolo County", cex = 2, col = "white")

legend("bottomleft", legend = c("0-6", "7-10", "11-14", "15-18", "19+"), fill = palette, title = "Mean Percent per City")
locator(1)
