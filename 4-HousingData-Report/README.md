
# Assignment 4 - Craigslist Apartments Data

Publish your report and code to GitHub by Thursday __May 19th, 11:55pm__. Hand
in a __printed copy__ of your report in class or office hours by May 20th.

Save your report, including graphics, as a PDF file called `report.pdf`. Save
your commented code as an R script called `code.R`. 

Start early and ask questions! The material covered in lecture is only a
starting point for completing this assignment.

## Description

[Craigslist][] is a website that allows people to post classified
advertisements for free. These posts span a variety of subjects, including job
postings, housing rentals, and item sales. Craigslist started in the San
Francisco Bay Area and now serves 570 cities worldwide. Posts are grouped by
city to make relevant ads easy to find.

[Craigslist]: https://www.craigslist.org/

For this assignment, you'll examine `cl_apartments.csv`, a data set based on
recent Craigslist posts for apartment rentals in California. Craigslist has few
rules about how posts should be formatted, so this data set is very messy. In
addition, some of the included variables were computed from the original post
text and may not be accurate! Therefore it's important to __be on the lookout
for errors__ and suspicious results when analyzing the data set.

The data set must be downloaded separately as a compressed zip file. After
downloading the zip file, it must be decompressed with your computer's built-in
zip program before the data can be used in R.

[DATA DOWNLOAD](http://anson.ucdavis.edu/~nulle/cl_apartments.zip)

Your task is to __write a 5-10 page report__ (including graphics, but excluding
code) that satisfies the prompts below. The report should include a _short_
introduction that describes the data set _in your own words_. For each
question, give a detailed written answer and __use a variety of graphics__
based on the data as evidence to support your claims. The questions are
deliberately open-ended and you should aim to answer them as completely as
possible; multiple approaches are possible for each. Your report will be graded
according to the [class rubric][rubric].

[rubric]: https://github.com/2016-ucdavis-sts98/notes/blob/master/rubric.pdf

1. Identify 3 anomalies in the data set. Each should be based on a different
   variable or set of variables. Explain why each anomaly is unusual and how it
   might affect your analysis of the data. Discuss and implement a strategy for
   dealing with each. What are the benefits and drawbacks of your strategies?

2. Is there a relationship between apartment size and price? Be careful to
   account for the effects of other variables such as geographical area.
   Discuss whether variables not present in the data set could make it
   difficult to see a relationship.

3. Approximately how much does rent increase for an additional bedroom? Does
   this amount depend on the total number of bedrooms? Does this amount include
   the cost of an additional bathroom? How can you tell?

4. How far in advance of an apartment becoming available for rent is a post
   typically made? Explore the distribution of this time span and discuss
   whether it varies by region.

5. Do apartments in similar geographical areas tend to have similar prices? If
   so, are there any exceptions? If not, do you see any other patterns? Use
   maps to justify your answer.

6. Do highly-populated areas tend to have smaller apartments? If you're
   unfamiliar with California's cities, it may help to consult [this
   page][CA Cities].

[CA Cities]: https://en.wikipedia.org/wiki/List_of_cities_and_towns_in_California

7. Come up with 3 questions about the apartments data. State each question
   clearly, explain why the question is interesting (and to whom?), and give a
   detailed answer.


## Data Documentation

Each row in the data set corresponds to a single Craigslist post. The posts
were downloaded on May 1st, 2016 from four California regional Craigslist
sites: San Diego, Los Angeles, Sacramento, and San Francisco Bay Area. The San
Francisco Bay Area site is divided into North Bay (San Rafael), East Bay
(Oakland), South Bay (San Jose), Peninsula (San Mateo), and San Francisco. As a
result, the data set includes approximately five times more posts from the San
Francisco Bay Area than any one of the other regions.

The included variables are:

Variable     | Description
------------ | -----------
title        | original title of the post
text         | original text of the post
date_posted  | date and time the post was made
date_updated | date and time the post was updated, or NA if not updated
deleted      | whether the post was deleted
craigslist   | craigslist site where the post was made
latitude     | latitude of the apartment
longitude    | longitude of the apartment
city         | posted city for the apartment
price        | monthly rent for the apartment, in dollars
date         | date the apartment will become available for rent
sqft         | size of the apartment, in square feet
bedrooms     | number of bedrooms (0 means a studio apartment)
bathrooms    | number of bathrooms (0.5 means a toilet with no bath)
pets         | best guess about pet policy
laundry      | best guess about laundry
parking      | best guess about parking policy
shp_place    | place (city or named rural area)
shp_city     | city
shp_urban    | census-designated urban area
shp_county   | county
shp_state    | state

The `pets`, `laundry`, and `parking` variables are based on the text of the
post. These are automatically-generated guesses and may be inaccurate.

The `shp_` variables are based on the posted latitude and longitude, using
regions defined by the US Census Bureau. These are accurate _provided the
posted latitude and longitude were accurate._
