# Jake Newman 

# directory setup
setwd("assignment-2-nwmn/")
list.files()

# initial variable assignment
priceData = readRDS("usda_prices.rds")

# Part 1
head(priceData)
range(priceData$year)
table(priceData$year)

# Part 2
length(table(priceData$food)) #output = 54
table(priceData$food)

# Part 3

# extract yogurt data
yogurt = subset(priceData, quarter == 1 & year == 2010 & (food == "regular fat yogurt & other dairy" | food == "low fat yogurt & other dairy") )

# find index of cheapest yogurt, then find corresponding market
which.min(yogurt$price) 
yogurt[18,] #san antonio, price = 0.659878

# differentiate between lowfat and regular fat yogurt 
lowfat = subset(priceData, quarter == 1 & year == 2010 & (food == "low fat yogurt & other dairy")) 
regFat = subset(priceData, quarter == 1 & year == 2010 & (food == "regular fat yogurt & other dairy")) 

# find index of cheapest lowfat / regular yogurt, then find corresponding markets
which.min(lowfat$price) #row 18
lowfat[18,]
which.min(regFat$price) #row22
regFat[22,] #north pacific

# so yes, fat content does make a difference. 

# Part 4

# find index of most expensive yogurt, then find corresponding market
which.max(yogurt$price)
yogurt[37,] #urban NY


# Part 5 

# extract orange vegetable data
orangeVeggies = subset(priceData, major_cities == "San Francisco" & (food == "canned orange vegetables" | food == "fresh/frozen orange vegetables")) 

# differentiate between canned & fresh/frozen
canned = subset(orangeVeggies, food == "canned orange vegetables")
freshFrozen = subset(orangeVeggies, food == "fresh/frozen orange vegetables")

# plot canned price data on y axis and corresponding dates on x axis as solid line
plot(canned$price ~ canned$date, canned, type = "l", main = "Orange Vegetable Prices Over Time", ylab = "Price ($)", xlab = "Date")

# add fresh/frozen data as dashed line
lines(freshFrozen$price ~ freshFrozen$date, freshFrozen, lty = "dashed")

#add legend
legend("topleft", legend = c("Canned", "Fresh/Frozen"), lty = c("solid", "dashed"))

# compare price range between canned & fresh/frozen, excluding NA values
range(canned$price, na.rm = TRUE)
range(freshFrozen$price, na.rm = TRUE)

# compare average price between canned & fresh/frozen, exlcuding NA values
mean(canned$price, na.rm = TRUE)
mean(freshFrozen$price, na.rm = TRUE)

# compare price variability between canned & fresh/frozen, excluding NA values
sd(canned$price, na.rm = TRUE)
sd(freshFrozen$price, na.rm = TRUE)

# Part 6 

# extract milk data
milk_oz = subset(priceData, food == "regular fat milk")

# convert raw price data into gallon prices
milkConversion = milk_oz
milkConversion[5] = milkConversion[5] * 36
milk_gallonPrice = milkConversion

# plot gallon price data against correspinding dates
boxplot(milk_gallonPrice$price ~ milk_gallonPrice$date, main = "Milk Gallon Prices Over Time", ylab = "Price ($ / gallon)", xlab = "Date", xaxt = 'n')

# clean up x axis for readability
x_coords = seq_along(unique(milk_gallonPrice$date))
axis(1, x_coords, FALSE)
axis(1, c(1, 5, 9, 13, 17, 21, 25), 2004:2010)

# Part 7

table(priceData$division)

# extract ice cream data
iceCream = subset(priceData, food == "ice cream and frozen desserts" & year != "2004")

# differentiate between west coast and east coast
westCoast = subset(iceCream, division == "Pacific" & division != "Mountain")
eastCoast = subset(iceCream, division == "New England" | division == "Middle Atlantic" | division == "South Atlantic")

# compare means (averages)
mean(westCoast$price)
mean(eastCoast$price)

# compare medians
median(westCoast$price)
median (eastCoast$price)

# compare variability using standard deviation
sd(westCoast$price)
sd(eastCoast$price)


