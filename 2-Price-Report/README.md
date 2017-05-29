
# Assignment 2 - Food Prices

Publish to GitHub by Thursday __April 14th, 11:55pm__.

Save your report as a PDF file called `report.pdf`. Save your commented code as
an R script called `code.R`. Start early so that you can get help on Piazza and
in office hours.

---

The US Department of Agriculture estimates retail food prices every quarter (3
months) across 35 areas of the US. The estimates are recorded in the USDA's
Quarterly Food-at-home Price Database ([source][USDA Food]).

[USDA Food]: http://www.ers.usda.gov/data-products/quarterly-food-at-home-price-database.aspx

For this assignment, you'll explore `usda_prices.rds`, which is based on that
data. Each row corresponds to a specific year, quarter, location, and food
group. The columns are:

Column        | Description
------------- | -----------
year          | The year for the price estimate.
quarter       | The quarter for the price estimate.
date          | The last day of the quarter for the price estimate.
food          | The food group for the price estimate.
price         | The price estimate for 100 grams of the food.
market        | The specific location for the estimate.
major_cities  | The major cities nearby the market, or `NA` if there aren't any.
region        | The US Census region for the market.
division      | The US Census division for the market.

US Census regions and divisions are shown on [this map][US Census Map].

[US Census Map]: http://www2.census.gov/geo/pdfs/maps-data/maps/reference/us_regdiv.pdf

Helpful R commands: `length`, `levels`, `table`, `$`, `subset`, `[`, `[[`,
`plot`, `boxplot`, `lines`, `legend`, `readRDS`, `range`, `which.max`,
`which.min`

1. What range of years does the data set cover? Are any years in the range
   missing?

2. How many different food groups are included? Does each have the same number
   of price estimates?

3. Which market had the cheapest yogurt in the first quarter of 2010? Does the
   fat content of the yogurt make a difference?

4. Which market had the most expensive yogurt in the first quarter of 2010?
   Are you surprised? Why or why not? What might cause this?

5. For San Francisco, make a line plot of date versus orange vegetable price.
   Use a solid line for canned and a dashed line for fresh/frozen. Make sure
   both lines are within the limits of the plot, and that the plot has a
   title, labels, and legend.

   Is it cheaper to buy canned or fresh/frozen orange vegetables? For which
   is the price more stable?

6. One gallon of milk is approximately 3600 grams, so you can multiply the
   price estimate for 100 grams of regular fat milk by 36 to get a price
   estimate for one gallon. Make a boxplot of date versus milk price per
   gallon. Make sure the plot has a title and labels.

   Do you notice a trend in the price of milk over time? A few quarters have
   unusually high milk prices. What might explain this? Think carefully and
   consider what was happening in the world.

7. The "west coast" is the West region excluding the Mountain division. The
   "east coast" is the Northeast region combined with the South Atlantic
   division. Which coast had a higher mean ice cream price for 2005 through
   2010? Which had a higher median? Which had more variability?

