SELECT *
FROM superstore;

-- FIRST CREATE A DUPLICATE IN ORDER TO PRESERVE THE ORIGINAL DATA
CREATE TABLE superstore_staging
LIKE superstore;

INSERT INTO superstore_staging
SELECT *
FROM superstore;

SELECT *
FROM superstore_staging;

-- THE NEXT PROCESS WILL BE TO REMOVE DUPLICATES BUT IN THIS DATA WE HAVE A UNIQUE COLUMN(ROW_ID) THAT ENSURES THERE ARE NO DUPLICATES BUT WE WILL CHECK FOR DUPLICATES ANYWAYS
WITH CTE_1 AS 
(
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY Row_ID, Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Customer_Name, Segment, Country, City, State, 
Postal_Code, Region, Product_ID, Category, Sub_Category, Product_Name, Sales, Quantity, Discount, Profit) AS Row_num
FROM superstore_staging
)
SELECT *
FROM CTE_1
WHERE Row_num > 1;

-- WE THEREFORE SEE THAT THERE ARE NO DUPLICATES
-- NEXT WE CHECK TO SEE IF WE HAVE TO SUBJECT THE DATA FOR CLEANING
SELECT *
FROM superstore_staging;
-- NOT MUCH CLEANING REQUIRED BUT WE SHOULD CHANGE THE DATA TYPES OF SHIP_DATE AND ORDER_DATE TO BE DATA TYPE 'DATE'

SELECT Order_Date, STR_TO_DATE(Order_Date, '%m/%d/%Y')
FROM superstore_staging;

UPDATE superstore_staging
SET Order_Date = STR_TO_DATE(Order_Date, '%m/%d/%Y');

SELECT *
FROM superstore_staging;

UPDATE superstore_staging
SET Ship_Date = STR_TO_DATE(Ship_Date, '%m/%d/%Y');

ALTER TABLE superstore_staging
MODIFY COLUMN Order_Date DATE;

ALTER TABLE superstore_staging
MODIFY COLUMN Ship_Date DATE;

-- NOW WE GO FOR EXPLORATORY ANALYSIS, WE ANALYSE THE DATA TO CLEARLY SHOW INTERESTING INSIGHTS THAT WE MIGHT VISUALIZE
-- FIRST (BECAUSE I'LL NEED IT) I WANT TO GET THE YEAR FROM THE ORDER DATE
WITH CTE_2 AS
( 
SELECT *, SUBSTRING(Order_Date, 1,4) AS `Order_Year`
FROM superstore_staging
)
UPDATE superstore_staging
INNER JOIN CTE_2 
	ON superstore_staging.Row_ID = CTE_2.Row_ID
SET superstore_staging.Order_ID = CTE_2.Order_Year;

SELECT *
FROM superstore_staging;

ALTER TABLE superstore_staging
CHANGE Order_ID Order_Year INT;

-- EXPLORATORY ANALYSIS
-- 1) YEARS WITH THE MOST SALES
SELECT Order_Year, COUNT(Order_Year)
FROM superstore_staging
GROUP BY Order_Year
ORDER BY 2 DESC;

SELECT *
FROM superstore_staging;

-- 2) WHAT IS THE PREFERRED SHIP MODE 
SELECT Ship_Mode, COUNT(*)
FROM superstore_staging
GROUP BY Ship_Mode
ORDER BY 2 DESC;

-- SINCE THERE'S ONLY ONE COUNTRY(UNITED STATES) IN THE COUNTRY COLUMN WE DECIDE TO DROP THAT COLUMN IN ORDER TO SAVE SPACE AND REDUCE PROCESSING TIME
ALTER TABLE superstore_staging
DROP COLUMN COUNTRY;

-- 3) COMPARE SHIP MODE AND CITY TO SEE WHAT TYPE OF SHIP MODE PEOPLE IN CALIFORNIA USE
SELECT Ship_Mode, City, State
FROM superstore_staging
WHERE State LIKE 'Calif%'
GROUP BY Ship_Mode, City, State
ORDER BY 1 ASC;

-- 4) COMPARE SHIP MODE TO SEGMENT
SELECT Ship_Mode, Segment, COUNT(*)
FROM superstore_staging
GROUP BY Ship_Mode, Segment
ORDER BY 3 DESC;

-- 5) FIRST FIND MOST REGION THEN COMPARE SHIP MODE TO REGION
SELECT DISTINCT Region, COUNT(*)
FROM superstore_staging
GROUP BY Region
ORDER BY 2 DESC;

SELECT Ship_Mode, Region, COUNT(*)
FROM superstore_staging
GROUP BY Ship_Mode, Region
ORDER BY 3 DESC;

-- 6) TOP 10 CUSTOMERS (MIGHT REWARD THEM WITH 2K)
SELECT Customer_Name, COUNT(*)
FROM superstore_staging
GROUP BY Customer_Name
ORDER BY 2 DESC
LIMIT 10;

-- 7) MOST CATEGORIES & COMPARE SHIP MODE TO CATEGORY
SELECT Category, COUNT(*)
FROM superstore_staging
GROUP BY Category
ORDER BY 2 DESC;

SELECT Ship_Mode, Category, COUNT(*)
FROM superstore_staging
GROUP BY Ship_Mode, Category
ORDER BY 3 DESC;

-- 8) MOST SUB_CATEGORIES & COMPARE SHIP MODE TO SUB_CATEGORY
SELECT Sub_Category, COUNT(*)
FROM superstore_staging
GROUP BY Sub_Category
ORDER BY 2 DESC;

SELECT Ship_Mode, Sub_Category, COUNT(*)
FROM superstore_staging
GROUP BY Ship_Mode, Sub_Category
ORDER BY 3 DESC;

-- 9) CATEGORY & SUB_CATEGORY
SELECT Category, Sub_Category, COUNT(*)
FROM superstore_staging
GROUP BY Category, Sub_Category
ORDER BY 3 DESC;

SELECT *
FROM superstore_staging;

-- 10) COST PRICE FOR EACH PRODUCT SOLD & COST PRICE FOR EVERY one PRODUCT SOLD
-- 10a)
SELECT Product_Name, Sales, Profit, Sales - Profit AS Cost
FROM superstore_staging
ORDER BY 4 DESC
LIMIT 20;

-- 10b)
SELECT Product_Name, Sales, Profit, Quantity, (Sales - Profit) / Quantity AS Cost_for_one
FROM superstore_staging
ORDER BY 5 DESC
LIMIT 20;

