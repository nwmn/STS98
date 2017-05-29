
# Assignment 5 - Health Inspection Data

Publish to GitHub by Thursday __June 2nd, 11:55pm__. Hand in one printed copy
for the whole group in class or office hours by June 3rd.

Your group assignment can be found [here](groups.md).

__Start immediately__ and ask questions! Useful R functions: `levels()`,
`melt()`, `merge()`, `grep()`, `table()`

## Introduction

Health inspectors conduct routine surprise inspections at restaurants
throughout the United States to ensure the safety of consumers. If minor
health code violations are found, the restaurant is given a few days to correct
them and a follow-up inspection is scheduled. If major violations are found,
the restaurant may be temporarily or permanently closed.

Health inspections are typically managed by county or city governments. Public
records are kept for every inspection. Most counties make these available for
free online. Unfortunately, there's no official standard for how health
inspection records should be organized, so it can be difficult to combine and
analyze data from multiple counties.

[Yelp][] developed the [local inspector value-entry specification][LIVES]
(LIVES) as a common standard for health inspection records. The LIVES format
splits the records across three or more CSV files with specific columns.

In this assignment, your group will explore health inspection records for three
counties in Northern California: Alameda, San Francisco, and Yolo. Most of
the records have been converted to the LIVES format to aid analysis. See the
link above for a full description of the format. The `feed_info` file has been
omitted for all counties since it isn't particularly relevant.

Nonetheless, there are some differences in formatting between counties. You may
have to do some light data cleaning to standardize the columns before analysis.
Moreover, the city of Berkeley manages its health inspections separately from
the rest of Alameda county and does not yet use the LIVES format. Part 1 will
have you convert the Berkeley data to something similar to the LIVES format.

[Yelp]: http://www.yelp.com/
[LIVES]: http://www.yelp.com/healthscores

The goal of this assignment is to produce a high-quality report on a research
question about the health inspection data. Don't let the word "research"
intimidate you! All this means is that your group will choose a specific
question to investigate in detail.


## Part 1 - Cleaning The Berkeley Data

The file `berkeley.csv` contains the most recently published records for
Berkeley. Each row corresponds to one inspection. Columns are used to indicate
which violations were found.

1.  The Berkeley data doesn't include a "score" column for the inspections.
    Compute a score for each inspection using the formula

        score = 100 - 4 * (# of minor violations) - 8 * (# of major violations)

    which is similar to the formula used in San Francisco.

2. Use the reshape2 package to reshape the Berkeley data so that each row
   corresponds to one violation. Name the new column "violation".

3. Commit your R script for cleaning the Berkeley data as `berkeley.R`. Save
   the cleaned data with `saveRDS()` and commit it as `berkeley.rds`.


## Part 2 - Research Question

Come up with a research question about the health inspection data. Your
question should be broad enough that you can come up with multiple strategies
for investigation or follow up questions. Although there is no written work for
this step, it is very important and you should __spend some time together
brainstorming__ and discussing. Consider:

* Why is the question interesting?

* Do you have the data necessary to answer the question in detail?

* How deep is the question? Are there multiple aspects to investigate?

* How can different aspects of the question be divided up among the group? Lay
  this out ahead of time.

Keep in mind that the data can be viewed from many different perspectives. For
instance, your question does not necessarily need to concern health inspections
and could simply use the data as a listing of restaurants. However, you must
use data from all three counties (including Berkeley). Questions about a
specific region or city can be expanded by making comparisons with other
regions or cities.

It is okay and encouraged to supplement the health inspection data with other
data sets. For example, you might want to use census data or the shapefiles
that were provided with Assignment 4.

Feel free to consult Nick or the TAs if you're unsure whether your group's
question is appropriate.


## Part 3 - Analysis

Write a 4-8 page report (including graphics, but excluding code) with the
following components:

* An introduction which includes a brief description of the data and explains
  your research question. Justify why your question is interesting and outline
  how you plan to investigate.

* An analysis which examines several different aspects of the question or
  examines the question from several different angles. Every group member must
  contribute to the analysis. __Use a variety of graphics__ based on the data
  as evidence to support your claims. This should be the longest component of
  your report.

* A conclusion which synthesizes your analysis into a coherent answer to your
  research question. Explain the practical meaning and limitations of your
  answer. Also discuss how your answer could be expanded on if you had
  additional time and data.

Since the work will be divided among your group, it's a good idea to meet after
assembling the report to proofread for problems with organization and flow. The
report _should not_ read like 3 separate reports. The report will be graded
according to the [class rubric][rubric], with consideration of the group
evaluation forms.

Save your report, including graphics, as a PDF file called `report.pdf`. Save
your R script for analyzing the data as `analysis.R`. 


[rubric]: https://github.com/2016-ucdavis-sts98/notes/blob/master/rubric.pdf

## Part 4 - Group Evaluation

After completing part 1-3, individually and privately fill out the Assignment
5 group evaluation form. The form will be posted to Piazza on June 2nd and may
be completed any time __before June 6th__. The form will ask you to summarize
the contributions each group member made to the assignment and take at most 30
minutes to fill out.
