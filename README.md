The dataset is a record of sales in stores of a major company in the United States. 
It consists of information about different customers and their various information that are required in purchasing products.
The data was analysed indepthly with SQL to uncover insights and trends about the data and it was also visualized using Microsoft PowerBI to clearly see these trends in graphical representations.

In SQL I cleaned the data before giving analysis and I did that by:
  i) First I created a new empty table and copied all the data from the original table to the new table. I did this in order to preserve the data in the original table and not alter it.
  ii) In the new table (which is what I worked with throughout the analysis) I searched for duplicates in the data by selecting all the columns in the data and also selecting a new custom column using the "ROW_NUMBER", partitioning it by each of the rows. Then I set a condition to return data where "ROW_NUMBER" is greater than 1, since there is no such data there is therefore no duplicates in the data.
  iii) There's not much to clean in the data since the data is cleaned up so I just changed the data types of "Order_Date" and "Ship_Date" from Text to Date.
      Then I did exploratory analysis:
  i) I created a new column to pull the Year from "Order_Date" and I updated it to the actual table using a CTE and joining it on the main table (since a CTE is a table too). I did this to get the highest sales per year.
  ii) I also got the preferred ship mode customers used
  ii) I decided to drop the "Country" column since there are all United states in the data and then I Compared the ship mode and cities in the state of California to see the preferred ship mode by customers in California.
  iii) I compared Ship mode to Segment
  iv) I analysed the most customers per region and I compared it to ship mode to see their preference
  v) I found the top 10 customers by number of orders (They might be given a bonus in the future)
  vi) I analysed the most customers per category and I compared it to ship mode to see their preference
  vii) I analysed the most customers per sub_category and I compared it to ship mode to see their preference
  viii) I compared sub_categories to their various categories.
  ix) I calculated the cost price of each product by subtracting the profit from the sales
  x) Some products had multiple quantities ordered so I calculated the cost price of every one quantity of each product by subtracting the profit from the sales and the dividing the result by the quantities

In POWERBI I visualized most of the insights I analysed in SQL some of which are:
  i) I visualized preferred ship mode in a stacked bar chart
  ii) I visualized highest sales per year in a line chart
  iii) I graphically exposed preferred ship mode in California with a stacked column chart
  iv) I visualized Ship mode per segment in a line and stacked column chart
  v) I visualized most sales per Region with a donut chart
  vi) I represented the top 10 customers by number of products ordered in a table
  vii) I represented the sales per category in a pie chart
  viii) I visualized ship mode per region in a line and stacked column chart
  ix) I represented ship mode per category in a stacked bar chart
  x) I visualized categories and their sub categories using drill down in a stacked column chart
  xi) In a table I exposed the product name, sales, profit and i wrote a DAX to calculate the cost price for each product by subracting the profit from the sales


In this way i derived from insightful information from the data that can be used to increase sales.

  
