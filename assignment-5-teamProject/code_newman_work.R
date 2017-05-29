library("lattice")
library("maps")
sf = readRDS("assignment-5-team-12/data/sf_merged.rds")
shp_sf = readRDS("notes/notes/data/maps/shp_sf_neighborhood.rds")

library("ggplot2")
library("ggmap")
#install.packages("maptools")
library("maptools")
#install.packages("gpclib")
library("gpclib")


sf_hoods = geom_polygon(aes(long, lat, group = group), data = shp_sf, color = "black", alpha = 0.4, show.legend = F, fill = NA)

#install.packages("ggmap")
library("ggmap")


names(sf)


library("stringr")
table(sf$name)
sf$new_name = str_to_upper(sf$name)


sfmap = qmap("San Francisco, CA", zoom = 12, color = "bw") + geom_polygon(aes(long, lat, group = group), data = shp_sf, color = "black", alpha = 0.4, show.legend = F, fill = NA)

sfstuff = sfmap + geom_bin2d(data = sf, aes(longitude, latitude), bins = 100) + ggtitle("\nRegional Distribution of SF Violations")
print(sfstuff)





#business table ---- 


names(berk)



head(berk)



# Draw the map.
print(sfmap)

sfmap2 = get_map("San Francisco, CA", zoom = 12, source = "stamen") 
ggmap(sfmap2)



riskDistribution = sfmap + geom_point(data = sf_Risk, aes(x = longitude, y = latitude, color = risk_category), alpha = 0.3) + labs(x = "Longitude", y = "Latitude") + ggtitle("\nSan Francisco Risk Distribution By Neighborhood") 

# the overwhl 
sf_Risk = subset(sf, sf$risk_category == "High Risk")

#riskDistribution = gg + labs(x = "Longitude", y = "Latitude") + ggtitle("SF")

print(riskDistribution)

sf$risk_category[is.na(sf$risk_category)] = "N/A"

table(sf$risk_category, useNA = "always")

plot(density(berk$scoreNumber, na.rm = T), main = "Berkeley Health Inspection Score Distribution", xlab = "Health Inspection Score")

names(sf)
#gg + geom_density_2d(data = v, aes( x = longitude, y = latitude))


head(berk)


names()
#gg = sfmap + geom_point(data = liquor, aes(x = long, y = lat))
# print(gg) -- prints to plot window 


# be careful about plotting 



install.packages("gridExtra")

names(sf)

measuredScores = sf[!is.na(sf$Score), ]
#measuredScores = subset(sf, sf$Score != NA)


scoreDistribution = sfmap + geom_point(data = measuredScores, aes(x = longitude, y = latitude, color = Score, alpha = 100)) + ggtitle("\nRegional Health Inpsection Score Distribution (SF)")
print(scoreDistribution)


sf$




type = sfmap + geom_point(data = sf, aes(x = longitude, y = latitude, color = type))


print(type)

summary(sf$Score)

names(sf)
table(sf$type)

bwplot(sf$Score | sf$risk_category, sf)

names(sf)


plot(sf$risk_category)

risktab = prop.table(sort(table(sf$risk_category))) * 100
risktab = risktab[-1]
barplot(risktab, main = "San Francisco Health Violation Risk Types", ylab = "Proportion (%)", ylim = c(0, 50), xlab = "Violation Risk Type")


scoretab = prop.table(table(sf$Score)) * 100
barplot(scoretab)


plot(density(sf$Score, na.rm = T), main = "San Francisco Health Safety Score Distribution", xlab = "Score")

median(sf$Score, na.rm = T) 
mean(sf$Score, na.rm = T)
sd(sf$Score, na.rm = T)


riskValid = subset(sf, risk_category != "N/A")

densityplot(~sf$Score, riskValid, plot.points = F, groups = type, auto.key = T)

densityplot(~sf$Score, riskValid, plot.points = F, groups = risk_category, auto.key = T)


table(as.numeric(sf$Score), sf$type)



table(sf$Score)


names(sf)
table(sf$name)



## nieghborhood map 
getwd()
shp_sf = readRDS("notes/notes/data/maps/shp_sf_neighborhood.rds")

library("ggplot2")
library("ggmap")
#install.packages("maptools")
library("maptools")
#install.packages("gpclib")
library("gpclib")

# Automatically reshape the data for ggplot2.
shp_sf = fortify(shp_sf, region = "NAME")

# Set up the neighborhoods. Settings outside aes() are treated as constants, not variables.



table(sf$type)

real_issues = subset(sf, type %in% c("Complaint", "Foodborne Illness Investigation", "Complaint Reinspection/Followup", "Multi-agency Investigation"))

complaints = subset(real_issues, type == "Complaint")
real_issues = subset(real_issues, type %in% c("Foodborne Illness Investigation", "Complaint Reinspection/Followup", "Multi-agency Investigation"))

nrow(real_issues)



realissues = sfmap + geom_point(data = real_issues, aes(x = longitude, y = latitude, color = type, alpha = 30)) 
print(realissues)


risky = subset(sf, sf$risk_category %in% c("High Risk", "Moderate Risk"))


nrow(risky)





complaintMap = sfmap + stat_bin_2d(data = complaints, aes(x = longitude, y = latitude), bins = 100) + ggtitle("\nRegional Distribution of Complaints")
print(complaintMap)




names(sf)


head(sf)
nrow(sf)

range(sf$Score,na.rm = T)

index = which.min(sf$Score)

sf[index,]

bad = subset(sf, Score <= 70)

badMap = sfmap + stat_bin_2d(data = bad, aes(x = longitude, y = latitude), bins = 100) + ggtitle("\nRegional Distribution of SF Eateries in Poor Operating Condition \n (Health Inspection Score <= 70)")
# ok so this shows that the lowest inspection scores are located downtown in the financial district.... 
print(badMap)





# score histogram 
plot(density(sf$Score,na.rm = T), main = "San Francisco Health Inspection Score Distribution", xlab = "Score")
abline(v = mean(sf$Score, na.rm = T), lty = "dashed", lwd = 3)
legend("topleft", lty = "dashed", legend = "Average", lwd = 3)


# 90 +  is good 
# 86-90 is adequate 
# 71-85 means needs improvement 
# less than 70 is poor



adequate = subset(sf, Score > 85 & Score < 90)
ad_map = sfmap + stat_bin_2d(data = adequate, aes(x = longitude, y = latitude), bins = 100) + ggtitle("\nRegional Distribution of Eateries with Adequate Safety Records \n (Health Inspection Score of 86-90)")
print(ad_map)

good = subset(sf, Score > 90)
good_map = sfmap + stat_bin_2d(data = good, aes(x = longitude, y = latitude), bins = 100) + ggtitle("\nRegional Distribution of Eateries with Good Safety Records \n (Health Inspection Score of 90+)")
print(ad_map)

needsImprov = subset(sf, Score >= 71 & Score <= 85)
needImprov_map= sfmap + stat_bin_2d(data = needsImprov, aes(x = longitude, y = latitude), bins = 100) + ggtitle("\nRegional Distribution of Eateries In Need of Sanitary Improvement \n (Health Inspection Score of 71-85)")
print(needImprov_map)






sf$score = sf$Score

mean(sf$score, na.rm = T)


print(badMap)


perfect = subset(sf, Score == 100)


perfectMap = sfmap + stat_bin_2d(data = perfect, aes(x = longitude, y = latitude), bins = 100) + ggtitle("\nRegional Distribution of Perfect Health Inspection Scores")
print(perfectMap)


x$score_cat = factor(x$score <= 70)

facet_wrap(~ score_cat)


#this shoes there are many more perfect scores than very low scores. also, the density of perfect scores is clustered more heavily in the SOMA / bay bridge area.. investiage possible reasons... tourism? 


library("gridExtra")
sf$names = tolower(sf$names)

#use 
sort(table(sf$name))


p1 <- perfectMap
p2 <- badMap

grid.arrange(p1, p2, nrow = 1)

######################### search 


table(sf$name)


schools <- c("ELEMENTARY", "SCHOOL", "COLLEGE", "ELEM")
schools_sub = grepl(paste(schools,collapse="|"), sf$new_name)
schools_sub = subset(sf, schools_sub)
hist(schools_sub$Score)
abline(v = median(schools_sub$Score, na.rm = T), lwd = 3, lty = "dashed") # 95




#summary(schools_sub$followup)
# school median 1.0 / mean 1.5

sweets = c("CREAM", "SCOOP", "SNO", "DOZEN", "KREME", "COOKIE", "CAKE", "BASKIN", "YOGURT", "DONUT", "DOUNUT", "C. R. E. A. M", "CANDY", "CREAMERY", "DESSERTS")
sweets_sub = grepl(paste(sweets,collapse="|"), sf$new_name)
sweets_sub = subset(sf, sweets_sub)
hist(sweets_sub$Score, freq = F)
abline(v = median(sweets_sub$Score, na.rm = T), lwd = 3, lty = "dashed") # < 90 

#summary(sweets_sub$followup)
# sweets median 4.0 / mean 4.56

mexican = c("TACOS", "ACO", "TAMALES", "DOS COYOTES", "DEL TACO", "COCINA", "Y MAS", "ARCOIRIS", "EL ", "LA ", "LAS ", "LOS ", "TAQUERIA", "BARAJAS", "CASA", "MEXICAN", "MEXICO", "BURRITO")
mexican_sub = grepl(paste(mexican,collapse="|"), sf$new_name)
mexican_sub = subset(sf, mexican_sub)
hist(mexican_sub$Score, freq = F)
abline(v = median(mexican_sub$Score, na.rm = T), lwd = 3, lty = "dashed") # 85



# mexican median 6.0 / mean 7.58

supermarkets = c("WALMART", "WHOLE FOODS", "SAFEWAY"," FOOD 4", "FOOD STORE", "COSTCO",  "MARKET", "SUPERMARKET", "BEL AIR", "BUTCHER", "GROCERIES", "GROCERY OUTLET", "GROCERY")
store_sub = grepl(paste(supermarkets,collapse="|"), sf$new_name)
store_sub = subset(sf, store_sub)
hist(store_sub$Score, freq = F)
abline(v = median(store_sub$Score, na.rm = T), lwd = 3, lty = "dashed") # 85


# store median 4.0 / mean 5.36

hotel <- c("SUITES", "ALL STARS", "RESORT", "BED &", "HOLIDAY 6", "INN", "ECONO", "MOTEL")
hotel_sub = grepl(paste(hotel,collapse="|"), sf$new_name)
hotel_sub = subset(sf, hotel_sub)
hist(hotel_sub$Score, freq = F)
abline(v = median(hotel_sub$Score, na.rm = T), lwd = 3, lty = "dashed") # ~90 
# hotel median 2.0 / mean 3.09

chinese <- c("HUNAN", "WOK", "CHINA", "NOODLE CITY", "DING HOW", "GOLDEN", "RICE", "ORIENT", "PANDA")
chinese_sub = grepl(paste(chinese,collapse="|"), sf$new_name)
chinese_sub = subset(sf, chinese_sub)
hist(chinese_sub$Score, freq = F)
abline(v = median(chinese_sub$Score, na.rm = T), lwd = 3, lty = "dashed") # less than 85

# chinese is low too 

thai <- c("CHICKPEAS", "KABAB", "BANGKOK", "THAI", "INDIAN", "CURRY", "NAAN")
thai_sub = grepl(paste(thai,collapse="|"), sf$new_name)
thai_sub = subset(sf, thai_sub)
hist(thai_sub$Score, freq = F)
abline(v = median(thai_sub$Score, na.rm = T), lwd = 3, lty = "dashed") # 80' s
# eastthai median 6.0 / mean 9.84

italian <- c("VITO'S", "PIZZA", "ITALIAN", "CAESARS")
italian_sub = grepl(paste(italian,collapse="|"), sf$new_name)
italian_sub = subset(sf, italian_sub)
hist(italian_sub$Score, freq = F)
abline(v = median(italian_sub$Score, na.rm = T), lwd = 3, lty = "dashed") # 85+ 
# italian median 4.0 / mean 4.21

american <- c("WINGSTOP", "WIENERSCHNITZEL", "CAFE", "SANDWICH", "MCDONALDS", "KENTUCKY", "JACK IN", "IHOP", "FAT FACE", "BARBECUE", "DENNY'S", "CREPEVILLE", "WAFFLES", "CORKWOOD", "CARL'S", "CAROL'S", "BURGERS", "BURGER", "BAR & GRILL", "ROADHOUSE", "AGGIE", "APPLEBEE", "BARISTA", "BEACH HUT", "33", "DINER")
american_sub = grepl(paste(american,collapse="|"), sf$new_name)
american_sub = subset(sf, american_sub)
hist(american_sub$Score, freq = F)
abline(v = median(american_sub$Score, na.rm = T), lwd = 3, lty = "dashed") # 85+ 
# american median 6.0 / mean 6.27

japan <- c("TERIYAKI", "SUSHI", "BAMBU", "JAPANESE", "MOSHI")
japan_sub = grepl(paste(japan,collapse="|"), sf$new_name)
japan_sub = subset(sf, japan_sub)
hist(japan_sub$Score, freq = F)
abline(v = median(japan_sub$Score, na.rm = T), lwd = 3, lty = "dashed") # 85 
# japan median 3.0 / mean 6.17

convenience <- c("KWIK", "FAST & EASY",  "MART", "QUICK", "VALERO", "1 STOP", "CIRCLE K", "7-ELEVEN", "MINI MART", "MART", "GAS", "SHELL", "ARCO", "AM/PM", "LIQUOR", "76")
convenience_sub = grepl(paste(convenience,collapse="|"), sf$new_name)
convenience_sub = subset(sf, convenience_sub)
hist(convenience_sub$Score, freq = F)
abline(v = median(sweets_sub$Score, na.rm = T), lwd = 3, lty = "dashed") # almost 90
# gas mart median 3.0 / mean 4.25

cater <- c("CATERING", "CATER")
cater_sub = grepl(paste(cater,collapse="|"), sf$new_name)
cater_sub = subset(sf, cater_sub)
hist(cater_sub$Score, freq = F)
abline(v = median(sweets_sub$Score, na.rm = T), lwd = 3, lty = "dashed")
# hotel median 0.0 / mean 0.17



plot(density(chinese_sub$Score, na.rm = T), main = "San Francisco's Most Unsanitary Cuisine Types", xlab = "Health Inspection Score")
lines(density(thai_sub$Score, na.rm = T), lty = "dashed")
lines(density(sf$Score, na.rm = T), lty = 3)
legend("topleft", legend = c("Chinese", "Thai / Indian", "All Eateries"), lty = c(1:3))




nrow(sf)
names(sf) ## 59381 rows 22 vars 






sortedViolations = sort(table(sf$description))

top10 = tail(sortedViolations, 10)

par(mar = c(10, 28, 10, 10))
barplot(top10, horiz = T, las = 2, main = "SF's Top 10 Most Frequent Violation Types")



names(sf)
table(sf$risk_category)


repeat_tab= sort(table(sf$business_id))

hist(repeat_tab)

quantile(repeat_tab)[[4]] + (IQR(repeat_tab)* 1.5) # 13.5 = 1.5x IQR

median(repeat_tab) #+ 13.5 # ~ 20 violations

outliers = repeat_tab[repeat_tab > 25]
outliers

smoothScatter(outliers)

sf[sf$business_id == 10238, ]
sf[sf$business_id == 75139, ]



sfbay_counties = c("san francisco", "san mateo")
#sfbay = paste("california", sfbay_counties, sep = ",")

map("county", paste("california", sfbay_counties, sep = ','), main = "T")
smoothScatter(sf$longitude, sf$latitude, 2000, add = TRUE)
map("county", paste("california", sfbay_counties, sep =','), add = T)


length(unique(sf$business_id))


# King of Thai is a local chain, having multiple stores throughouthe city, which could possibly inflate and explain why it has so many violations. Nevertheless, 

# Hakka Resturant

range(sf$Score, na.rm = T)

table(sf$city)

table(sf$date)

date = as.numeric(sf$date)
date = as.Date(as.character(sf$date), "%Y%m%d")
range(date, na.rm = T)

(as.Date("2013-05-13") -as.Date("2016-12-15") )/ 365



sf_biz = read.csv("assignment-5-team-12/data/san_francisco/businesses.csv")

eateries = sfmap + geom_bin2d(data = sf_biz, aes(x = longitude, y = latitude), bins = 100) + ggtitle("\nRegional Distribution of SF Eatery Locations")
print(eateries)



berk = readRDS("assignment-5-team-12/data/berkeley.rds")
nrow(berk)
names(berk)


berkmap = qmap("Berkeley, CA", zoom = 13, color = "bw")

berkeateries = berkmap + geom_bin2d(data = berk, aes(x = longitude, y = latitude), bins = 100) + ggtitle("\nRegional Distribution of \nBerkeley Eatery Violations")
print(berkeateries)

names(berk)

boxplot(berk$scoreNumber, ylim = c(80, 100), main = "Score Distribution of \nBerkeley Eatery Locations")


head(berk)

median(berk$scoreNumber)
nrow(sf_biz)
length(unique(sf_biz$buis))


