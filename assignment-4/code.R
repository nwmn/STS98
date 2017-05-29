getwd()
old = read.csv("assignment-4-nwmn/cl_apartments.csv")
library("maps")
library("lattice")
library("viridis")
map_county = readRDS("assignment-4-nwmn/maps/shp_county.RDS")
map_place = readRDS("assignment-4-nwmn/maps/shp_place.rds")

data = readRDS("assignment-4-nwmn/clean_data.RDS")

nrow(old[old$price < 200, ])

IQR(old$price, na.rm = T)

# 1 


data$isMover = grepl("MOVE", data$title, fixed = TRUE) | grepl("MOVING", data$title, fixed = TRUE) | grepl("moving", data$title, fixed = TRUE)
table(data$isMover)
data$price[data$isMover] = NA
summary(data$isMover)

data$tooLow = data$price < 150
table(data$tooLow)
data$price[data$tooLow] = NA

data$tooBig = data$sqft > 15000
table(data$tooBig)
data$sqft[data$tooBig] = NA

 ############## taken from instructor Nick A's Piazza Post about removing duplicates. 
new_data = data[order(data$date_posted, decreasing = TRUE),]
# Now we have our new_data and can use duplicated() on the title column

duplicated(new_data$title)
# This will return TRUE if R found duplicates FALSE otherwise, but we don't want them
#  
new_data[duplicated(new_data$title),]
# This returns back a data frame with ONLY the duplicated rows and all columns, but we dont want them
# So how can we get the ones that aren't duplicated? Well the simple thing to do is use the not operator !
  
n_data = new_data[!duplicated(new_data$title),]
# Adding in ! will reverse the TRUEs and FALSEs. Instead this now reads, get all the rows and that arent duplicated
# Then assign it back to be the new_data

saveRDS(data, "clean_data.RDS")
?saveRDS




data = readRDS("assignment-4-nwmn/clean_data.RDS")





names(data)
index = which.max(data$bedrooms)
data[index, ]

index = which.min(data$price)
data[index, ]

sortedPrice = data[order(data$price), ]
head(sortedPrice, 30)

data[2886,]

#615 $1 / 7br - Benidict Historical Mansion Film Location/ book for your Next Event (Beverly Hills)
# 2886, 2887 $1 postings, moving companies. remove these, set price = NA
# scam alerts 3629






which.max(tooLow$price)
lowball[51,]

#price anomalies

#615 $1 / 7br - Benidict Historical Mansion Film Location/ book for your Next Event (Beverly Hills)
# 2886, 2887 $1 postings, moving companies. remove these, set price = NA
# scam alerts 3629, often listed at $1. Easily removed excluding all unrealistic, extremely low prices (below $150). 


big = subset(data, data$sqft > 10000)
nrow(big)

summary(big)
range(big$sqft)
which.max(big$sqft)
big[4,]

# There seem to be a number of postings incorrectly advertising massive square footage. For example, the self-proclaimed "cheapest Studio" in Downtown SF boasts a listed 450,279 square feet, with a monthly rent of only $2,798. Residential units do not typically approach this scale within SF city limits. Clearly, in this case, the information provided on Craiglist about square footage is not valid considering the market price of Downtown real estate in San Francisco. 

# CAL MAP 
par(mfrow = c(1, 2))
par(mar = c(rep(15, 4)))
#dev.off()

drawCali = function(a = F, maptitle = "") { 
  map("county", "California", add = a)
  title(maptitle, line = 2)
}

par(mar = rep(15,4))

drawCali()
#points(data$longitude, data$latitude)
smoothScatter(data$longitude, data$latitude, 1000, add = TRUE)
drawCali(T, maptitle = "Geographic Distribution of Craigslist Rental Postings")


par(mar = c(rep(15,4)))
sfbay_counties = c("san francisco", "san mateo", "marin", "alameda", "contra costa", "napa", "sonoma", "santa clara", "solano")
#sfbay = paste("california", sfbay_counties, sep = ",")
sfbay = subset(data, data$shp_county %in% sfbay_counties)

map("county", paste("california", sfbay_counties, sep = ','), main = "T")
smoothScatter(data$longitude, data$latitude, 2000, add = TRUE)
map("county", paste("california", sfbay_counties, sep =','), add = T)
title(main = "Geographic Distribution \n(Zoomed In)", line = 2)
sfnames = sfbay_counties
sfnames = sfnames[-3]
sfnames = sfnames[-1]

sfnames
map.text(map_county, sfnames, add = TRUE, col = "white")
map.text(map_county, "San Francisco:1", labels = "San Francisco", add = TRUE, col = "white")
map.text(map_county, "Marin:2", labels = "Marin", add = TRUE, col = "white")

#dev.off()
# there are a signifigant amount of listings that are posted outside of county boundaries according to their latitude and longitude position. Many show a location in open waters, such as the San Francisco Bay. Show the map 

range(data$sqft, na.rm = T)
which.max(data$sqft)
data[17866,]


head(data$city)
head(data$craigslist)


## REMOVE DUPLICATES  then save as new file. 
## Taken in large part from Instructor Nick A's online Piazza post in regard to this task. 


# new_data = data[order(data$date_posted, decreasing = TRUE),]
# #Now we have our new_data and can use duplicated() on the title column
# 
# duplicated(new_data$title)
# #This will return TRUE if R found duplicates FALSE otherwise, but we don't want them
# 
# new_data[duplicated(new_data$title),]
# #This returns back a data frame with ONLY the duplicated rows and all columns, but we dont want them
# #So how can we get the ones that aren't duplicated? Well the simple thing to do is use the not operator !
#   
# new_data = new_data[!duplicated(new_data$title),]
# #Adding in ! will reverse the TRUEs and FALSEs. Instead this now reads, get all the rows and that arent duplicated
# #Then assign it back to be the new_data
# 
# summary(new_data)



# 2 apartment size and price 
# clean = data[-17866,]
# which.max(clean$sqft)
# clean = clean[-7060,]

# sortedfeet = data[order(data$sqft), ]
# tail(sortedfeet$sqft, 30)

#smoothScatter(clean$price, clean$sqft)
clean = data

# correct information contained in listing  
data$sqft[310] = 1500
clean$sqft[310] = 1500

data[2364,]

which.max(clean$sqft)
clean = clean[-17866,] # invalid sq footage
clean = clean[-7060,] # vacant land home 
clean$sqft[clean$sqft > 6000] = NA
clean$price[clean$price > 15000] = NA
smoothScatter(clean$sqft, clean$price, xlim = c(0, 6000),ylim = c(0, 15000)) 
              
par(mfrow = c(1, 3))

line = lm(price ~ sqft, clean)
# Add the line to the plot. a is intercept, b is slope.
coef(line)
abline(a = coef(line)[1], b = coef(line)[2], col = "black", lwd = 3)

# Even without accounting for geographic region, there seems to be a signifigant direct correlation between price and square footage in the raw dataset provided. Nevertheless, since this graph represents all unproccessed values present, there are a number of factors that could be distorting this relationship, including number of bedrooms and property location. 

data$shp_county = tolower(data$shp_county)
sfbay_counties = c("san francisco", "san mateo", "marin", "alameda", "contra costa", "napa", "sonoma", "santa clara", "solano")
#sfbay = paste("california", sfbay_counties, sep = ",")
sfbay = subset(data, data$shp_county %in% sfbay_counties)
nrow(sfbay)
index = which.max(sfbay$sqft)
sfbay = sfbay[-index,] 

# smoothScatter(sfbay$sqft, sfbay$price, main = "San Francisco \n Price By Size (Square Feet)", ylim = c(0, 15000)) 
# 
# sfbay$sqft[sfbay$sqft > 6000] = NA
# sfbay$price[sfbay$price > 15000] = NA
# 
# line = lm(price ~ sqft, sfbay)
# #?lm
# # Add the line to the plot. a is intercept, b is slope.
# coef(line)
# abline(a = coef(line)[1], b = coef(line)[2], col = "black", lwd = 3)

#map("county", c("california,los angeles", "california,orange"))


# 
# la_counties = c("Los Angeles", "Ventura", "Riverside", "Orange", "San Bernardino")
# #sfbay = paste("california", sfbay_counties, sep = ",")
# la = subset(data, data$shp_county %in% tolower(la_counties))
# which.max(la$sqft)
# la$sqft[279] = NA
# smoothScatter(la$sqft, la$price, xlim = c(0, 5000), main = "Los Angeles \nPrice By Square Feet", ylim = c(0, 15000))
# la$sqft[la$sqft > 5000] = NA
# la$price[la$price > 15000] = NA
# line = lm(price ~ sqft, la)
# #?lm
# # Add the line to the plot. a is intercept, b is slope.
# coef(line)
# abline(a = coef(line)[1], b = coef(line)[2], col = "black", lwd = 3)








#smoothScatter(data$longitude, data$latitude, 3000, add = TRUE)
#map("county", sfbay, add = TRUE)


names(data)
# number of bedrooms  -- Q3 
boxplot(data$price ~ data$bedrooms, ylim = c(0, 15000), main = "Apartment Prices By Number of Bedrooms", xlab = "Number of Bedrooms", ylab = "Price ($)")

#splitting this up 
data$bedrooms[data$bedrooms == 5]

clean = data
clean = subset(clean, clean$bedrooms != 7 | clean$bedrooms != 5 )

PricesByBedroom = tapply(clean$price, clean$bedrooms, mean, na.rm = T)

PricesByBedroom = PricesByBedroom[1:5]
bedDiffs = diff(PricesByBedroom)
plot(c(0,1,2,3,4), PricesByBedroom, xaxt = 'n', xlab = "Number of Bedrooms", ylab = "Price ($)", main = "Price By Number of Bedrooms", type = "l", lwd = 3, ylim = c(1800, 4200), las = 2)
points(c(0,1,2,3,4), PricesByBedroom, col = "black", pch = 19)
axis(1,seq(0, 4, by=1), xlab = "Number of Bedrooms")

bedDiffs[0:4]
mean(bedDiffs)

plot(bedDiffs)

?plot

length(bedDiffs)


summary(data$title[data$bedrooms == 5])

medianPricesBath = tapply(clean$price, clean$bathrooms, median, na.rm = T)
boxplot(clean$price ~ clean$bedrooms, main = "Price By Bedrooms", xlab = "Number of Bedrooms", ylab = "Price", ylim = c(0, 15000))
lines(c(1:7,8), medianPricesByBedroom, lty = "dashed")

#lines(c(1,1.5,2.5,3,3.5,4,4.5,5,5.5), medianPricesBath[1:9], col = "red")


length(medianPricesBath)


## 3 answer to bathroom question

data$bathrooms = ceiling(data$bathrooms)

new = subset(data, bathrooms < 5 & bedrooms < 5)
new2 = new
new2$bathrooms = ceiling(new2$bathrooms)

bwplot(price ~ factor(bedrooms) | factor(bathrooms), new2, main = "Price By Number of Bedrooms \n(Grouped By Number of Bathrooms)", xlab = "Bedrooms", ylab = "Price", ylim = c(0, 15000))

#the amount rent increases for an additional bathroom is dependent on the total number of bedrooms, so far.  

# the amount at which price increases for an additonal bedrooms is differnt depending on how many total bedrooms. For example, when moving from a studio Additonal are more expensive    
rawData = read.csv("cl_apartments.csv")

table(data$bathroom, data$bedroom)
med_prices_nick = tapply(data$price, list(data$bedroom, data$bathrooms), median, na.rm = T)
matplot(med_prices_nick, type = 'l', lwd = 3, col = magma(4), xlab = "Number of Bedrooms", ylim = c(0, 15000)) 

legend("topright", lty = 1:5, col = 1:6, legend = colnames(med_prices_nick))

dev.off()

table(clean$bathrooms)

names(data)


view  = data[data$bedrooms == 7, ]
range(view$price, na.rm = T)
table(view$price)

which.max(view$price)
view[506,]

index = which.max(data$bedrooms)
data[index, ]



# plot(clean$price ~ clean$bedrooms, main = "Price By Bedrooms", xlab = "Number of Bedrooms", ylab = "Price")
# lines(c(0:6,8), medianPricesByBedroom)
# bedEqualBath = subset(data, data$bedroom == data$bathroom)
# bedEqualBath = subset(bedEqualBath, bedrooms != 7)
# medianPricesEqualBath = tapply(bedEqualBath$price, bedEqualBath$bedrooms, median, na.rm = T)
# lines(c(1:5), medianPricesEqualBath, col = "red")
# 
# bed_NEqualBath = subset(data, data$bedroom != data$bathroom)
# bed_NEqualBath = subset(bed_NEqualBath, bedrooms != 7)
# 
# medianPricesNEqualBath = tapply(bed_NEqualBath$price, bed_NEqualBath$bedrooms, median, na.rm = T)
# 
# medianPricesNEqualBath
# lines(c(0:6,8), medianPricesNEqualBath, col = "blue")


median(as.Date(data$date) - as.Date(data$date_posted), na.rm = T)

$
  
data$date_Diff = as.Date(data$date) - as.Date(data$date_posted)

range(data$date_Diff, na.rm = T)
plot(density(as.numeric(data$date_Diff), na.rm = T), xlim = c(0, 14), main = "Time Difference Between Date Posted and Date Available")


densityplot(~as.numeric(data$date_Diff, na.rm = T)|shp_county, data, plot.points = F, xlim = c(-10, 100), xlab = "Date Difference (Number of Days)", main = "Time Difference Between Date Posted and Date Available", col = "black", lwd = 3)

histogram(~as.numeric(data$date_Diff, na.rm = T), data, plot.points = F, xlim = c(0, 50), xlab = "Date Difference (Number of Days)", main = "Time Difference Between Date Posted and Date Available", col = "grey", breaks = 300)


clean = data
clean2 = subset(clean, shp_county %in% c("sonoma", "san francisco", "marin", "shasta", "yolo", "nevada"))
#clean3 = subset(data, shp_county == "san francisco")

histogram(~as.numeric(clean2$date_Diff, na.rm = T) | shp_county, clean2, xlim = c(-5, 50), xlab = "Date Difference (Number of Days)", main = "Time Difference Between Date Posted and Date Available \nBy County", col = "grey", breaks = 35)

mean(data$date_Diff, na.rm = T)
timeDiff = subset(data, as.numeric(date_Diff) < 15)
mean(timeDiff$date_Diff, na.rm = T)

quantile(data$date_Diff,na.rm = T)

#postedinAdvance = subset(data, data$date_Diff >= 0)
data$date_Diff = as.Date(data$date) - as.Date(data$date_posted)
data$date_Diff[data$date_Diff < 0] = 0
range(data$date_Diff, na.rm = T)

which.max(data$date_Diff)
#data$date[9110] = NA
data[2447,] = NA
data$date[4226] = NA

range(data$date_Diff, na.rm = T)
mean(data$date_Diff, na.rm = T)
median(data$date_Diff, na.rm = T)

# clean$date[4226]
# 
# # plot(density(as.numeric(data$date_Diff[!is.na(data$date_Diff)]), xlim = c(0, 200)))
# 
# densityplot(as.numeric(data$date_Diff), xlim = c(0, 200), plot.points = F, col = "black")
# #xlab = "Days Posted in Advance")
# 
# names(postedinAdvance)
# sf_advancedpost = subset(postedinAdvance, postedinAdvance$shp_county %in% sfbay_counties)
# #sf_advancedpost = subset(postedinAdvance, postedinAdvance$shp_county %in% sfbay)
# nrow(sf_advancedpost)
# 
# outsideCal = data$shp_state[!data$shp_state == "California" | NA]
# table(outsideCal)
# 
# outsideCal = subset(data, shp_state != "California" | NA)
# outsideCal



# 
# 
# #par(mfrow = c(1,2))
# plot(density(as.matrix(sf_advancedpost$date_Diff)), xlim = c(0, 60), xlab = "Days Posted in Advance")
# 
# la_advancedpost = subset(postedinAdvance, postedinAdvance$shp_county %in% la_counties)
# #sf_advancedpost = subset(postedinAdvance, postedinAdvance$shp_county %in% sfbay)
# nrow(la_advancedpost)
# 
# plot(density(as.matrix(la_advancedpost$date_Diff)), xlim = c(0, 60), xlab = "Days Posted in Advance", add = T)
# 
# # answer is yes, the amount of time that a rental posting is created in advance does change depending on location. Though the vast majority of postings are uploaded less than a week before avalibility, 
# 
# median(as.numeric(sf_advancedpost$date_Diff))
# median(as.numeric(la_advancedpost$date_Diff))
# 
# table(data$date_Diff)
# 
# ?as.date()


# 
# par(mar = rep(10,4))
# map("county", "california")
# 
# data$shp_county = tolower(data$shp_county)
# la = c('orange', "los angeles", "ventura")
# 
# data_la = subset(data, data$shp_county %in% la)
# nrow(data_la)
# data_la$shp_place = droplevels(data_la$shp_place)
# la_prices = tapply(data_la$price, data_la$shp_county, median, na.rm = T)
# range(la_prices, na.rm = T)
# la_prices
# 
# #color palette 
# #br = c(0, 14780, 1645, 2081, Inf)
# col = cut(la_prices, 3, dig.lab = 10)
# palette = magma(10)[4:7]
# 
# 
# summary(la_prices)
# 
# la = paste("california", la, sep= ",")
# map("county", la, col = palette[col], fill = TRUE, mar = rep(10, 4), bg = "gray60")
# legend("bottomleft", levels(col), fill = palette, cex = 0.75)


# sfbay = c("San Francisco", "San Mateo", "Santa Clara", "Contra Costa", "Alameda", "Napa", "Solano", "Sonoma", "Marin")
# sfbay = paste("california", sfbay, sep = ",")
# sfbay = map("county", sfbay, namesonly = TRUE)
# data$region = paste(data$shp_state, data$shp_county, sep = ",")
# data_sfbay = subset(data, region %in% sfbay)
# 
# sfbayprice = tapply(data_sfbay$price, data_sfbay$region, median, na.rm = T)
# 
# palette = magma(10)[4:7]
# map("county", sfbay, fill = TRUE, col = palette, bg = "gray50")
# title("Prices for San Francisco Bay Area", line = 1)
# map.text("county", sfbay, add = TRUE, col = "white")
# legend("bottomleft", legend = sfbay, levels(col), fill = palette)

#5 
map_county = readRDS("assignment-4-nwmn/maps/shp_county.rds")
map_place = readRDS("assignment-4-nwmn/maps/shp_place.rds")
summary(map_place)

sfbay = c("San Francisco", "San Mateo", "Santa Clara", "Contra Costa", "Alameda", "Napa", "Solano", "Sonoma", "Marin")
#sfbay = tolower(sfbay)
#sfbay = paste("california",sfbay, sep = ',')
#sfbay = map("county", sfbay, namesonly = TRUE)

sf_place = subset(map_place, map_place$county %in% sfbay)
sf_county = subset(map_county, map_county$NAME %in% sfbay)
data_sfbay = subset(data, data$shp_county %in% tolower(sfbay))
#nrow(data_sfbay)
data_sfbay$shp_place = droplevels(data_sfbay$shp_place)
prices = tapply(data_sfbay$price, data_sfbay$shp_place, mean, na.rm=T)
prices
#prices = prices[as.character(sf_place$NAME)]
br = c(0, 500, 1500, 2500, 3500, Inf)
prices
col = cut(prices, br, dig.lab = 10)
palette = inferno(5)[1:5]
#col = palette[sfcolor]

plot(sf_county)
plot(sf_place, col = palette[col], add = T)
title("Average Price of Apartments in San Francisco Bay Area", line = 1)
sfnames = sfbay
sfnames = sfnames[-1]
sfnames = sfnames[-8]

map.text(map_county, sfnames, add = TRUE, col = "black", lwd = 10)
map.text(map_county, "San Francisco:4", labels = "SF", add = TRUE, col = "black", lwd = 10)
map.text(map_county, "Marin:2", labels = "Marin", add = TRUE, col = "black", lwd = 10)

legLabel = levels(col)
legLabel
levels(legLabel) = c("<500", "$500 up to $1,500", "$1,500 up to $2,500", "$2,500 up to $3,500", "$3,500+")

legend("bottomleft", legend = levels(legLabel), fill = palette, title = "Average Price ($)", text.width = 1)


par(mar = c(rep(15,4)))

la_counties = c("Los Angeles", "Ventura", "Riverside", "Orange", "San Bernardino")
la_place = subset(map_place, map_place$county %in% la_counties)
la_county = subset(map_county, map_county$NAME %in% la_counties)
data_la = subset(data, data$shp_county %in% tolower(la_counties))
#nrow(data_la)
data_la$shp_place = droplevels(data_la$shp_place)
prices = tapply(data_la$price, data_la$shp_place, mean, na.rm=T)

br = c(0, 500, 1500, 2500, 3500, Inf)
prices
col = cut(prices, br, dig.lab = 10)
palette = inferno(5)[1:5]

plot(la_county)
plot(la_place, col = palette[col], add = T)
title("Average Price of Apartments in Greater LA Area", line = 1)
la_names = la_counties
la_names
la_names = la_names[-2]
la_names = la_names[-1]

map.text(map_county, la_names, add = TRUE, col = "black", lwd = 10)
map.text(map_county, "Los Angeles:3", labels = "Los Angeles", add = TRUE, col = "black", lwd = 10)
map.text(map_county, "Ventura:2", labels = "Ventura", add = TRUE, col = "black", lwd = 10)

# map.text(map_county, "San Francisco:1", labels = "San Francisco", add = TRUE, col = "white")
# map.text(map_county, "Marin:2", labels = "Marin", add = TRUE, col = "white")

legLabel = levels(col)
legLabel
levels(legLabel) = c("<500", "$500 up to $1,500", "$1,500 up to $2,500", "$2,500 up to $3,500", "$3,500+")

legend("bottomleft", legend = levels(legLabel), fill = palette, title = "Average Price ($)", text.width = 2)




#locator(1)





plot(density(la$sqft, na.rm = T), xlim = c(0, 4000))

dense_counties = c("los angeles", "san diego", "santa clara", "san francisco", "fresno", "sacramento")

outskirt_counties = c("del norte", "siskiyou", "modoc", "humboldt", "trinity", "shasta", "lassen", "plumas", "butte", "glenn")

dense = subset(data, data$shp_county %in% dense_counties)
outskirt = subset(data, data$shp_county %in% outskirt_counties)

#par(mfrow=c(1,2))
dense$sqft[dense$sqft > 3000] = NA
outskirt$sqft[outskirt$sqft > 3000] = NA

plot(density(dense$sqft, na.rm = T), main = "Apartment Size By Population Level", xlab = "Apartment Size (Square Feet)")
lines(density(outskirt$sqft, na.rm = T), lty= "dashed")

length(density(outskirt$sqft, na.rm = T))
range(outskirt$sqft, na.rm = T)

head(data$shp_county)

legend("topright", legend = c("Highly Populated", "Not Highly Populated"), lty = c("solid", "dashed"))

par(mfrow = c(1, 3))
boxplot(sfbay$sqft, ylim = c(0, 4000))
boxplot(la$sqft, ylim = c(0, 4000))
boxplot(outskirt$sqft, ylim = c(0, 4000))


clean = data
clean$sqft[clean$sqft>4000] = NA

clean = subset(clean, shp_county %in% c("sonoma", "yolo", "santa clara", "san francisco", "marin", "los angeles", "san diego","sacramento", "solano"))


# 2 plot 
xyplot(price ~ sqft| shp_county, clean, xlim = c(0, 4500), ylim = c(0, 12000), main = "Regional Comparison: \nPrice By Square Footage", panel = panel.smoothScatter, ylab = "Price ($)", xlab = "Square Feet")

#7 

laundry = data
levels(laundry$laundry) = c("private / in-unit","private / in-unit", "none", "non-private", "non-private")

densityplot(~ sqft, laundry, groups = laundry, key = list(text = list(levels(laundry$laundry)), space = "top", lines = list(lty = c(1:3))), plot.points = F, xlim = c(0, 3000), main = "Apartment Size By Laundry Type", xlab = "Apartment Size (Square Feet)", lty = c(1:3), col = "black")

# clean4 = data
# clean4$parking[clean4$parking == "street"] = "none"

#8

data$freeparking = data$parking
levels(data$freeparking) = c("Free", "Free", "None", "Free", "Paid", "Paid", "Paid")


densityplot(~ price, data, groups = freeparking, key = list(text = list(levels(data$freeparking)), space = "top", lines = list(lty = 1:3)), plot.points = F, xlim = c(0, 6000), main = "Rent Price By Parking Type", xlab = "Rent Price ($)", lty = 1:3, col = "black")

names(data)

?densityplot

#9

pets = data
levels(pets$pets) = c("pets allowed", "pets allowed", "pets allowed", "pets negotiable", "no pets allowed")



densityplot(~ sqft, pets, groups = pets, auto.key = T, plot.points = F, xlim = c(0, 3000), main = "Apartment Size By Pet Friendliness", xlab = "Apartment Size (Square Feet)")


densityplot(~ sqft, pets, groups = pets, key = list(text = list(levels(pets$pets)), space = "top", lines = list(lty = 1:3)) , plot.points = F, xlim = c(0, 3000), main = "Apartment Size By Pet Friendliness", xlab = "Apartment Size (Square Feet)", lty = 1:3, col = "black")




# paid washers only really exist in apartments smaller than 1k sq feet 




# 
# ?xyplot








#discussion with clark 


# dim(data)
# 
# apt = data
# 
# apt$bath2 = ceiling(apt$bathrooms)
# model = lm(price ~ bedrooms*bath2, data = apt)
# summary(model)
# 
# 
# coef(model)[4]
# 
# unique(apt$bathroom)
# unique(apt$bath2)


# nrow(data)
# prices2 = tapply(data$price, data$shp_county, median, na.rm = T)
# head(prices2, 30)
# 
# par(mar = c(rep(15, 4)))
# map("county", "california", fill = T, col = c("red", "blue"))
# counties = map("county", "california", namesonly = TRUE, plot = FALSE)
# 
# 
# 
# 
# names(data)
# data$map_county = paste(data$state, data$shp_county, sep=',')
# head(data$map_place)
# prices2 = tapply(data$price, data$map_county, median, na.rm = T)
# prices2 = prices2[counties]
# # 
# # map("county", "california", fill = T, col = prices2)
# 
# 
# 
# 
# names(data)
# 
# data$bathroomINT = ceiling(data$bathrooms)
# 
# boxplot(data$price ~ data$bathroomINT)
# 
# 
# 
# 
# ?plot
# 
# 
# table(data$bathroomINT)
# 
# 
# 
# par(mar = c(rep(15, 4)))
# 
# map("county", c(paste("california", data$shp_county, sep = ',')))
# 
# table(data$shp_place)
# 
# 
# newclean = subset(data, data$sqft < 5000)
# xyplot(price ~ sqft | bedrooms, data = newclean, xlim = c(0, 5000), panel = panel.smoothScatter)
# 
# 
# 
# ?xyplot
# 
# data$bedrooms
# data$date_Diff[data$date_Diff > 500] = NA
# 
# sfbay$date_diff = as.Date(date)
# 
# 
# hist(as.numeric(data$date_Diff), breaks = 50)
# 
# 
# plot(density(data$sqft[!is.na(data$sqft)]), xlim = c(0, 3500))
# lines(density(sfbay$sqft[!is.na(sfbay$sqft)]), xlim = c(0, 3500), lty = "dashed", add = T)
# 
# library("lattice")
# ?lattice
# 
# bwplot(price ~ bedrooms, data = data)
# 
# 
# 
# barchart(data$bedrooms, data$price)





