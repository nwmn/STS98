#setup 

library(lattice)
getwd()
setwd("newman")
list.files()
setwd("assignment-3-nwmn/")
rawData = readRDS("hcmst.rds")

#1

#Catagorical: Gender attraction, house type, race, religion
#Ordinal: Income, Education(?), relationship quality 
#numerical: Number of children, Partner Age, Years lived together

range(rawData$survey_date)
median(rawData$age)

#2

regions = NULL
regions = sort(table(rawData$division))
regions = prop.table(regions) * 100


par(mar=c(5,10,4,1))
barplot(regions, horiz = T, las = 1, main = "Regional Distribution By US Census Divisions", xlab = "Proportion (%)", xlim = c(0, 20))
title(ylab = "Census Division (USA)", line = 8)

par(mfrow = c(2, 2))

race = table(rawData$race)
race = prop.table(race)
race = race *100
race

dotchart(as.numeric(race), main = "Population By Race", xlab = "Proportion (%)", labels = c("Caucasian",'African American','Native American', 'Asian', 'Other', 'Hispanic'))
axis(1, at= c(10, 30, 50, 70), labels = F)


gender = rawData$gender
gender = subset(gender, gender != "other")
gender = factor(gender)
levels(gender)
plot(gender)

#gender distribution

male = subset(gender, gender == "male")
female = subset(gender, gender == "female")
prop_male = length(male) / length(gender)
prop_male
prop_female = length(female) / length(gender)
prop_female

prop_female + prop_male

49.15+50.85

##age 

hist(rawData$age, main = "Age Distribution For All Subjects", xlab = "Age (Years)", xlim = c(15, 95))
axis(1, at = c(15, 20,25, 30,35,45, 50,55,60, 65, 70,75, 85, 95), labels = F)
axis(1, at = c(30, 40, 50, 70,80,90))
abline(v = median(rawData$age), lty = 2, lwd = 3)
legend("topright", legend = "Median", lty = "dashed", lwd = 3)

mean(rawData$age)

## income distribution
income = rawData$income
par(mar=c(5,13,4,1))
plot(income, main = "Household Income Distribution", xlab = "Frequency (Count)", col = "grey", las = 1, horiz = T, xlim = c(0, 500))
title(ylab = "Income Distribution (US Dollars)", line = 10)
axis(1, at = c(0, 50, 150, 250, 350, 450, 500), labels = F)


##race 

race = table(rawData$race)
race = prop.table(race)
race = race *100
race

dotchart(as.numeric(race), main = "Population By Race", xlab = "Proportion (%)", labels = c("Caucasian",'African American','Native American', 'Asian', 'Other', 'Hispanic'))
axis(1, at= c(10, 30, 50, 70), labels = F)


# 3 

#calculate comparative stats for broke up, got married, etc. 
rawData$got_married

n_participants = nrow(rawData$id)
n_relations = subset(rawData, partner == T & breakup != "partner deceased")


breakups = subset(rawData, partner == T & breakup == "yes")
n_breakups = nrow(breakups)
n_breakups
percentBrokeup = n_breakups / nrow(n_relations)
percentBrokeup = percentBrokeup * 100
percentBrokeup

got_married = subset(rawData, got_married == TRUE, married = F)
n_gotmarried = nrow(got_married)
n_gotmarried
percentMarried = n_gotmarried / nrow(n_relations)
percentMarried = percentMarried * 100
percentMarried # 3.698

nrow(got_married)

rawData$partner_deceased

eventualMarriage = subset(rawData, married == FALSE & got_married == TRUE)
lateBreakups = subset(eventualMarriage, breakup == "yes")
nrow(lateBreakups)
head(lateBreakups, 10)
summary(lateBreakups)

nrow(lateBreakups)

summary(lateBreakups) #mostly straight people, west south central, age hist below, 
hist(lateBreakups$age, col = "grey", breaks = 10, main = "Age Distribution of Late Breakups", xlab = "Age (Years)", ylab = "Frequency (Count)")
axis(1, at = c(20, 25, 30, 35, 40, 45, 50, 55, 60), label = F)
?hist

#so, answer is yes to last part of question. notable findings - 8/9 lived in detached one-family homes. all head more than 10 years of education, none attended the same highschool. perhaps most interesting is that they all reported positive feelings about the relationship. this is most interesting and perplexing commonality between these 9 people. 


#4 

#averaged age of couples

breakupsCount = NULL
breakupsCount = table( ((rawData$age + rawData$partner_age) / 2) , rawData$breakup == "yes")
colnames(breakupsCount) = c("FALSE", "Broke Up")
#breakupsCount = breakupsCount[,-1]
breakupsCount
y = breakupsCount[,2]
breakupsAge = table(rawData$age, rawData$breakup =="yes")
breakupsAge

x = row.names(breakupsCount)

which.max(breakupsCount[,2])

class(breakupsAge)

par(mfrow = c(1, 2))

plot(x, y, type ='l', main = "Number of Breakups By Averaged Ages of Couples", xlab = "Averaged Age (Years)", ylab = "Number of Breakups")

plot(x, y, type ='l', main = "Number of Breakups By Averaged Ages of Couples", xlab = "Averaged Age (Years)", ylab = "Number of Breakups", xlim = c(18, 45))



hist(y, main = "Number of Breakups By Age", xlab = "Age (Years)", ylab = "Number of Breakups")


breakupsCount2 = table(rawData$years_relationship, rawData$breakup == "yes")
breakupsCount
y2 = breakupsCount2[,2]
x2 = as.integer(row.names(breakupsCount2))

#plot(x2, y2, type ='l', main = "Number of Breakups By Age of Relationship", xlab = "Age (Years)", ylab = "Number of Breakups")

par(mfrow = c(1, 2)) 
hist(y2, main = "Number of Breakups By Age of Relationship (Years)", xlab = "Relationship Age (Years)", ylab = "Number of Breakups", col = "grey")

hist(y2, main = "Number of Breakups By Age of Relationship (Years)", xlab = "Relationship Age (Years)", ylab = "Number of Breakups", xlim = c(0, 10), breaks = 30, col = "grey", ylim = c(0,60)) 

#shows that nearly all breakups occur within first 2 years  of marriage 


# 5 - age difference 

ageDelta = abs(rawData$age - rawData$partner_age)
median(ageDelta, na.rm = T) 
mean(ageDelta, na.rm = T)# 3 years

par(mfrow = c(2, 1))
hist(heteromales$age, breaks = 30, xlim = c(18, 90), main = "Age Distribution of Heterosexual Men", xlab = "Age (Years)", ylim = c(0, 100))
legend("topright", legend = "Mean", lty = "dashed", lwd = 3)

abline(v = mean(heteromales$age), lty = 2, lwd = 3)
hist(heteroFemales$age, breaks = 30, xlim = c(18, 90), ylim =c(0, 100), main = "Age Distribution of Heterosexual Women", xlab = "Age (Years)", col = "white")
abline(v = mean(heteroFemales$age), lty = 2, lwd = 3)
legend("topright", legend = "Mean", lty = "dashed", lwd = 3)


#6 - common background effect on breaking up. consider religion, education level, hometown  

newtab = NULL
rawData$isSameReligion = rawData$religion == rawData$partner_religion

#mosaicplot(rawData$isSameReligion ~ rawData$breakup)
#mosaicplot(rawData$same_hometown ~ rawData$breakup)

newtab = table(rawData$isSameReligion, rawData$breakup)
newtab
newtab = newtab[,-2]
rownames(newtab) = c("Different Religion", "Same Religion")
colnames(newtab) = c("Broke Up", "Stayed Together")
newtab = prop.table(newtab, 1)*100
#newtab = t(newtab)
#newtab = prop.table(newtab,1)
newtab
bwtheme = standard.theme("pdf", color=FALSE)
barchart(newtab, auto.key = T, stack = F, par.settings=bwtheme, main = "Breakups By Religion Dynamic", xlab = "Proportion (%)")
?barchart

#mosaicplot(rawData$isSameEDU ~ rawData$breakup)
#mosaicplot(rawData$breakup ~ rawData$same_hometown)


#legend("top", legend = c("Same Religion", "Stayed Together"), fill = c("black", "white"))

#sameReligion = subset(rawData, religion == partner_religion)
#diffReligion = subset(rawData, religion != partner_religion)


hometownTAB = NULL
hometownTAB = table(rawData$same_hometown, rawData$breakup)
hometownTAB = hometownTAB[,-2]
hometownTAB
rownames(hometownTAB) = c("Different Hometown", "Same Hometown")
colnames(hometownTAB) = c("Broke Up", "Stayed Together")
hometownTAB = prop.table(hometownTAB, 1) * 100

bwtheme = standard.theme("pdf", color=FALSE)
barchart(hometownTAB[,1], stack = F, par.settings=bwtheme, auto.key = T, main = "Breakups By Hometown Dynamic", xlab = "Proportion Broke Up (%)", xlim = c(0, 25))



# years edu 

married = subset(rawData, married == T)
nrow(married) / nrow(n_relations)

rawData$isSameEDU = NULL
rawData$isSameEDU = rawData$partner == T & ((rawData$years_edu == rawData$partner_years_edu) | ((rawData$years_edu == rawData$partner_years_edu + 1) | (rawData$years_edu == rawData$partner_years_edu - 1)) | ((rawData$years_edu == rawData$partner_years_edu + 2) | (rawData$years_edu == rawData$partner_years_edu - 2)) | ((rawData$years_edu == rawData$partner_years_edu + 3) | (rawData$years_edu == rawData$partner_years_edu - 3)))

tabEDU = NULL

median(rawData$age)

tabEDU = table(rawData$isSameEDU, rawData$breakup)
tabEDU = tabEDU[,-2]
rownames(tabEDU) = c("Different Education Level", "Same Education Level")
colnames(tabEDU) = c("Broke Up", "Stayed Together")
tabEDU = prop.table(tabEDU, 1) * 100
tabEDU

barchart(tabEDU, auto.key = T, stack = F, main = "Breakup Rate By Education Dynamic", par.settings=bwtheme, xlab = "Proportion (%)", xlim = c(0, 100))



#7 relationship quality 

realBreakups = rawData$breakup == "yes"
relationshipRate = rawData$relationship_quality

#breakupTab = table(realBreakups)
# levels(relationshipRate) = c("Very Bad", "Bad", "Fair", "Good", "Excellent")
# tab = table(relationshipRate, realBreakups)
# realBreakups
# tab = prop.table(tab, 2)
# head(tab)
# barplot(tab, main = "Breakup Rate By Self-Reported Relationship Quality", beside = T)

head(tab)
tab = table(rawData$breakup, rawData$relationship_quality)
tab = tab[-2,]
tab = prop.table(tab, 2)
tab = tab * 100
tab
#barplot(tab, main = "Breakup Rate By Relationship Quality", ylab = "Breakup Rate (%)", beside = T, col = c("black", "white"), xlab = "Self-Reported Relationship Quality", ylim = c(0, 100))

barplot(tab[1,], main = "Breakup Rate By Relationship Quality", ylab = "Breakup Rate (%)", beside = T, xlab = "Self-Reported Relationship Quality", ylim = c(0,70))


axis(2, at = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90), labels = F)
legend("top", legend = c("Broke Up", "Stayed Together"), fill = c("black", "white"))

?barchart

#mosaicplot


#clearly, yes. self reported relationship quality is inversely correlated with breakups. the higher one's opinion of their relationship, the less likely they were to break up. Negative Correlation coefficient. 


boxplot(children ~ relationship_quality, rawData, main = "Number of Children By Relationship Quality", xlab = "Self Reported Relationship Quality", ylab = "Number of Children")


tab_PA = table(rawData$breakup, rawData$parental_approval)
tab_PA= tab_PA[-2,]
tab_PA
tab_PA = prop.table(tab_PA, 2)
tab_PA = tab_PA * 100
barplot(tab_PA, main = "Breakup Rate By Parental Approval", beside = T, col = c("black", "white"), xlab = "Parental Approval", ylab = "Proportion (%)", lwd = 1, ylim= c(0, 90))
axis(2, at = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90), labels = F)
legend("top", legend = c("Broke Up", "Stayed Together"), fill = c("black", "white"), cex = 0.8) 

## 8 - how couples meet 

meeting = subset(rawData, partner == T)
meeting = prop.table(table(meeting$met_at)) *100
meetingprop = prop.table(meeting)
meetingprop
meeting = meeting[-4]
meeting = sort(meeting)
meeting

par(mar=c(5,13,4,1))
barplot(meeting, horiz = T, las = 1, main = "How All Couples Meet", xlab = "Proportion (%)", xlim = c(0, 16))
title(ylab = "Meeting Place", line = 11.5)

tab = NULL
rawData$isOld = rawData$age > 45
tab = table(rawData$met_at, rawData$isOld)

#sort by "young" couple data - for a better graph
df = data.frame(young = tab[,1], old = tab[,2])

df = df[order(df$young), ]
df = as.matrix(t(df))

par(mar=c(5,13,4,1))
barplot(df, beside = T, horiz = T, las = 1, main = "How Different Age Couples Meet", col = c("black", "white"), xlab = "Count")
#axis(1, at = c(2.5, 7.5, 12.5), las  =1, labels = F)
legend(locator(1), legend = c("Young <45 Years", "Old 45+ Years "), fill = c("black", "white"), cex = .8)
#axis(1, at = c(25, 75, 125, 175, 225, 275), label = F)
title(ylab = "Meeting Place", line = 11.5)


# 9 dating someone opposite gender attraction: 


straightPeople = subset(rawData, gender_attraction == "opposite gender only" | gender_attraction == "mostly opposite")
lgbtq = subset(rawData, gender_attraction == "only same gender" | gender_attraction == "same gender mostly") 

nrow(straightPeople)
nrow(lgbtq)

# isolate relationships opposite gender attraction 
straight_oppRelations = subset(straightPeople, gender == partner_gender)
prop1 = (nrow(straight_oppRelations) / nrow(straightPeople))* 100 # 8 unexpected relations. less than 1/3 of lgbtq. 
nrow(straight_oppRelations)

lgbtq_oppRelations = subset(lgbtq, gender != partner_gender)
prop2 = (nrow(lgbtq_oppRelations) / nrow(lgbtq)) * 100 # 25 unexpected relations !! more than 3x that of straights!!! says something about society 
nrow(lgbtq_oppRelations)


numbers = c(prop1, prop2)
barplot(numbers, names.arg = c("Opposite Gender", "Same Gender"), ylab = "Proportion (%)", ylim = c(0, 6), main = "Unexpected Relationships Based on Gender Attraction", xlab = "Gender Attraction")

barplot()

 
lgbtq_oppBreakups = subset(lgbtq_oppRelations, breakup == "yes")
lgbtq_oppBreakupRate = (nrow(lgbtq_oppBreakups) / nrow(lgbtq_oppRelations)) * 100
lgbtq_oppBreakupRate

straight_oppBreakups = subset(straight_oppRelations, breakup == "yes")
straight_oppBreakupRate = (nrow(straight_oppBreakups) / nrow(straight_oppRelations)) * 100
straight_oppBreakupRate

nrow(straight_oppBreakups)
nrow(lgbtq_oppBreakups)

oppBreakupRate = ( nrow(lgbtq_oppBreakups) + nrow(straight_oppBreakups) ) / (nrow(lgbtq_oppRelations) + nrow(straight_oppRelations))
oppBreakupRate * 100


#10 - age diff btwn heterosexuals and homosexuals 

## own question 1

heteros = subset(rawData, gender_attraction == "opposite gender only" | gender_attraction == "opposite gender mostly" )
nrow(heteros)

heteroageDelta = abs(heteros$age - heteros$partner_age)
mean(heteroageDelta, na.rm = T)# 4.310 years
median(heteroageDelta, na.rm = T)

sameGender = subset(rawData, gender_attraction == "only same gender" | gender_attraction == "same gender mostly" )
nrow(sameGender)
sameGenderDelta = abs(sameGender$age - sameGender$partner_age)
mean(sameGenderDelta, na.rm = T) 
median(sameGenderDelta, na.rm = T)

par(mfrow = c(1, 2))
hist(heteroageDelta, xlim = c(0, 40), breaks = 30, main = "Age Differences Among Heterosexual Couples", xlab = "Age Difference (Years)", freq = F, ylim = c(0, 0.25))
axis(1, at = c(5, 10, 15, 25, 30, 35), labels = F)
hist(sameGenderDelta, xlim = c(0, 40), breaks = 30, main = "Age Differences Among Homosexual Couples", xlab = "Age Difference (Years)", freq = F, ylim = c(0, 0.25))
axis(1, at = c(5, 10, 15, 25, 30, 35), labels = F)



partnered = subset(rawData, partner == T) 
nrow(partnered) 

# 11

par(mfrow = c(1, 2))


bi = subset(rawData, gender_attraction == "both genders equally") 
nrow(bi)
heteroTab = prop.table(table(heteros$met_online))*100
sameGTab = prop.table(table(sameGender$met_online))*100
bi = prop.table(table(bi$met_online))*100


bi
bisexuals
heteroTab
sameGTab


bigtab = rbind(sameGTab, bi, heteroTab)
rownames(bigtab) = c("Same Gender", "Bisexual", "Heterosexual")
colnames(bigtab) = c("Met Offline","Met Online")
bigtab
21.47/6.35 # same gender attraction is more than as likely 3x to meet their partners online


barchart(bigtab[,2], stack = F, auto.key = T, col = "grey", main = "Meeting Online By Gender Attraction", xlab = "Proportion Met Online (%)", ylab = "Gender Attraction", xlim = c(0, 25))

#12

#compare breakup rates of those who met online vs offline
sub = subset(rawData, partner == T & breakup != "partner deceased")
subTAB = prop.table(table(sub$met_online, sub$breakup), 1) * 100
subTAB = subTAB[,-2]
colnames(subTAB) = c("Broke Up", "Stayed Together")
rownames(subTAB) = c("Offline", "Online")
subTAB

barchart(subTAB[,1], stack = F, col = "grey", main = "Breakup Rate By Whether Couple Met Online", xlab = "Breakup Rate (%)", ylab = "How Couple Met", xlim = c(0,40))


38/17


