
# Assignment 3 - Stanford's How Couples Meet and Stay Together

Publish your report and code to GitHub by Wednesday __May 4th, 11:55pm__. Hand
in a __printed copy__ of your report in class on May 5th.

Save your report, including graphics, as a PDF file called `report.pdf`. Save
your commented code as an R script called `code.R`. 

Start early and ask questions! The material covered in lecture is only a
starting point for completing this assignment.

## Description

Stanford's How Couples Meet and Stay Together (HCMST) study ([source][HCMST])
gives a detailed look at how Americans meet their romantic partners. The study
tracked the relationship status of more than 3000 couples from 2009 to 2015.

[HCMST]: http://data.stanford.edu/hcmst

The study was administered through a series of surveys. The initial "main"
survey collected detailed information on each survey subject and their partner.
Subjects that were not in a romantic relationship at the time of the main
survey were disqualified. Subjects that were in a romantic relationship were
sent follow up surveys in annual "waves" for 5 years, to check if they'd broken
up.

For this assignment, you'll explore `hcmst.rds`, a subset of the original HCMST
data set. All subjects (people who participated) were kept, but the number of
variables was reduced to 49 from approximately 500. A description of each
variable is given in the "Data Documentation" section at the end of this
document.

Your task is to __write a 5-10 page report__ (including graphics, but excluding
code) that answers the questions below. The report should include a _short_
introduction that describes the data set. For each question, give a detailed
written answer and __use graphics__ based on the data as evidence to
support your claims. The questions are deliberately open-ended and you should
aim to answer them as completely as possible; multiple strategies are possible
for each. Your report will be graded according to the [class rubric][rubric].

[rubric]: https://github.com/2016-ucdavis-sts98/notes/blob/master/rubric.pdf

1. Give examples of 3 categorical variables, 3 ordinal variables, and 3
   numerical variables in the data set. Are any of the categorical or ordinal
   variables binned?

2. What's the demographic breakdown of the survey subjects? Are there any
   biases? Do you think the subjects are representative of the United States as
   a whole?

3. What proportion of the survey subjects eventually broke up? What proportion
   eventually got married? Among unmarried subjects, did any get married and
   later break up? If so, do these subjects have anything else in common?

4. Is there a connection between the age of couples (both subject and partner)
   and whether they break up? Is there a connection between the age of the
   relationship and whether they break up?

5. What's the typical age difference between partners? Among heterosexual
   couples, is one gender more likely to be older?

6. Does common background between partners seem to be related to whether they
   break up? At a minimum, consider religion, education level, and hometown.

7. Is self-reported relationship quality relevant for determining whether a
   couple will break up? What about parental approval? Is there a connection
   between relationship quality and number of children?

8. How do couples meet? Is there a difference between how young and old
   couples meet?

9. Were any of the survey subjects dating someone from the gender they're less
   attracted to? Did more of these couples break up compared to other couples?

10. Come up with 3 questions about how couples meet and stay together that can
    be answered with the data. State each question clearly, explain why the
    question is interesting (and to whom?), and give a detailed answer.

See the [R graphics guide][r-graphics] for a list of relevant graphics
functions and guidelines. Other helpful R functions include `levels`, `table`,
`$`, `subset`, `[`, and `colors`.

[r-graphics]: https://github.com/2016-ucdavis-sts98/notes/blob/master/graphics_guide.md

## Data Documentation

Each row in the data set corresponds to a single survey subject. The main
survey was sent to many people who didn't have romantic partners; they were
removed from the study and did not receive the wave surveys.

The variables included are:

Variable             | Description
-------------------- | -----------
id                   | case id number
survey_wt            | case weight marker (for computing weighted statistics)
survey_date          | date subject took main survey as YYYYMM
survey_src           | survey source
income               | income category for subject's household
children             | children in subject's household
glb                  | whether subject reported being gay, lesbian, or bisexual
gender_attraction    | which gender subject is most attracted to
division             | US census division where subject lives
metro                | whether subject lives in a metro area
dist_hometown        | distance from subject's household to hometown
house_type           | subject's type of house
renter               | whether subject is a renter
age                  | subject's age in years
gender               | subject's gender
race                 | subject's race
years_edu            | subject's years educated
religion             | subject's religion
politic              | subject's political affiliation
relatives_monthly    | number of relatives subject sees each month
partner              | whether subject has a romantic partner
partner_deceased     | whether partner was deceased at main survey date
partner_same_sex     | whether partner has same sex
partner_age          | partner's age
partner_gender       | partner's gender
partner_race         | partner's race
partner_years_edu    | partner's years educated
partner_religion     | partner's religion
partner_politic      | partner's political affiliation
years_met            | years since subject and partner met
years_romantic       | years since subject and partner became romantic
years_live_together  | years since subject and partner began living together
years_relationship   | years since subject and partner began relationship
married              | whether subject is married to partner
parental_approval    | whether subject's parents approve of partner
relationship_quality | subject's reported relationship quality
live_together        | whether subject lives with partner
greater_income       | whether subject or partner has greater income
same_high_school     | whether subject and partner attended same high school
same_college         | whether subject and partner attended same college
same_hometown        | whether subject and partner have same hometown
met_online           | whether subject and partner met online
met_online_how       | how subject and partner met online, if applicable
met_at               | where subject and partner met
met_through          | who introduced subject and partner
degrees_separation   | degrees of separation between subject and partner
breakup              | whether subject and partner broke eventually up
breakup_who          | whether subject or partner wanted break up more
got_married          | whether subject and partner eventually got married

A full description of the study, the specific survey questions used, and the
original variables is posted on the [HCMST website][HCMST].
