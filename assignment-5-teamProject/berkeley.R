library("reshape2")
library("lattice")


getwd()
data = read.csv("assignment-5-team-12/data/berkeley.csv")
head(data)

#data$new = 1
#score = 100 - 4 * (# of minor violations) - 8 * (# of major violations)


majorV = data[[10]] + data[[12]] + data[[14]] + data[[16]] + data[[18]]
minorV = data[[11]] + data[[13]] + data[[15]] + data[[17]] + data[[19]]

#data$score = 100 - 4 * (minorV) - 8 * (majorV)
data$scoreNumber = 100 - 4 * minorV - 8 * majorV
data$hasViolation = majorV+minorV > 0 
table(data$hasViolation)

violations = subset(data, hasViolation)
nrow(violations)

m = melt(violations, measure.vars = names(violations[10:19]))
head(m)
levels(m$variable)

colnames(m)[12] = "violation"

# berkeley data is now clean ! 

head(m)

saveRDS(m, "assignment-5-team-12/data/berkeley.rds")




names(violations[10:19])
head(violations)





## merging datasets 


sf_biz = read.csv("assignment-5-team-12/data/san_francisco/businesses.csv")
sf_insp = read.csv("assignment-5-team-12/data/san_francisco/inspections.csv")
sf_violations = read.csv("assignment-5-team-12/data/san_francisco/violations.csv")

names(sf_biz)
names(sf_insp)
names(sf_violations)

sf_merge = merge(sf_biz, sf_insp, by = "business_id" , all = T)
sf_merged = merge(sf_merge, sf_violations, by = c("business_id", "date"), all = T)

saveRDS(sf_merged, "assignment-5-team-12/data/sf_merged.rds")

yolo_biz = read.csv("assignment-5-team-12/data/yolo/businesses.csv")
yolo_insp = read.csv("assignment-5-team-12/data/yolo/inspections.csv")
yolo_violations = read.csv("assignment-5-team-12/data/yolo/violations.csv")

names(yolo_biz)
names(yolo_insp)
names(yolo_violations)

yolo_merge = merge(yolo_biz, yolo_insp, by = "business_id")
yolo_merged = merge(yolo_merge, yolo_violations, by = c("business_id", "date"), all = T)

saveRDS(yolo_merged, "assignment-5-team-12/data/yolo_merged.rds")

#alameda 
ala_biz = read.csv("assignment-5-team-12/data/alameda/businesses.csv")
ala_insp = read.csv("assignment-5-team-12/data/alameda/inspections.csv")
ala_violations = read.csv("assignment-5-team-12/data/alameda/violations.csv")

names(ala_biz)
names(ala_insp)
names(ala_violations)

ala_merge = merge(ala_biz, ala_insp, by = "business_id")
ala_merged = merge(ala_merge, ala_violations, by = c("business_id", "date"), all = T)

saveRDS(ala_merged, "assignment-5-team-12/data/alameda_merged.rds")




# NOTES about research question: 

# he wants to compare city by city 
# what factors seem tied with higher sanitary scores? what factors predict low scores? 
# does geographic location matter? population density? urban or non urban? downtown vs outskirts? 
# type of food offered - you could estimate this by using text search function. 
# college towns - is the food more sanitary? are the types of food offered different? 

# is there a relationship between geopgrahic location and health inspection score? If not, what factors do seem to have a relationship with score?
# what types of resturants typically have more violations? are there any trends?

# what are the most dangerous resturants? does this differ by city? 
# does the relative housing price / cost of living seem to be related to the sanitary conditions of resturants? 



