-- Retail Sales Analysis SQL Project

-- 1. Database Setup
-- Database Creation: The project starts by creating a database named `retail_sales`.
-- Table Creation: A table named `retail_sales` is created to store the sales data. The table structure includes columns for 
-- transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.


CREATE TABLE retail_sales(
transactions_id	INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender	VARCHAR(25),
age	INT,
category VARCHAR(25),
quantiy	INT,
price_per_unit FLOAT,	
cogs FLOAT,
total_sale FLOAT
);

SELECT * FROM retail_sales;

-- 2. Data Cleaning &   


COPY retail_sales
FROM 'E:/project dataset/dsl/Retail-Sales-Analysis-SQL-Project--P1-main/Retail-Sales-Analysis-SQL-Project--P1-main/Retail Sales Analysis .csv'
DELIMITER E'\t'
CSV HEADER;

SELECT * FROM retail_sales
LIMIT 10;

-- Record Count: Determine the total number of records in the dataset.

SELECT count(*) FROM retail_sales

-- Null Value Check: Check for any null values in the dataset and delete records with missing data.

SELECT * FROM retail_sales
WHERE 
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
	 age IS NULL
	 OR
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL ;

-- Detete tHe NULL values in dataset

DELETE FROM retail_sales
WHERE 
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL ;

SELECT count(*) FROM retail_sales

-- Update the NULL values in age column with 30 in  dataset

UPDATE retail_sales
SET age = 30
WHERE age IS NULL

-- 3. Data  Exploration  

-- How many sales we have ?
SELECT count(*) as total_sales FROM retail_sales

-- Customer Count: Find out how many unique customers are in the dataset.
SELECT count(DISTINCT customer_id) FROM retail_sales

-- Category Count: Identify all unique product categories in the dataset.
SELECT DISTINCT category FROM retail_sales



-- 4. Data Analysis & Business key Problems and Answers

--My Analysis & Finding

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.
-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- 8. Write a SQL query to find the top 5 customers based on the highest total sales 
-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.
-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

-- Answers 

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05':

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05' ;

-- 2. Write a SQL query to retrieve all transactions where the category is 
--    'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

SELECT * FROM retail_sales
WHERE
    category = 'Clothing' 
	AND 
	quantiy > 3 
	AND
	TO_CHAR(sale_date ,'YYYY-MM' ) = '2022-11';

-- 3. Write a SQL query to calculate the total sales (total_sale) and total orders for each category.

SELECT  category , SUM(total_sale) , COUNT(*) as total_orders FROM retail_sales
GROUP BY 1 ;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age)) FROM retail_sales
WHERE
    category = 'Beauty'
	
-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000 ;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT  COUNT(total_sale) , category , gender  FROM retail_sales
GROUP BY 2 , 3
ORDER BY 1;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

ALTER TABLE retail_sales
ADD COLUMN sale_year INT , 
ADD COLUMN sale_month INT  


UPDATE retail_sales 
SET sale_year = EXTRACT(YEAR FROM sale_date) ,
    sale_month  = EXTRACT(MONTH FROM sale_date) ;


SELECT sale_year , 
       sale_month , 
       AVG_sale
FROM (

SELECT  sale_year , 
        sale_month , 
        ROUND(AVG(total_sale)) as AVG_sale ,
		RANK() OVER(PARTITION BY sale_year ORDER BY ROUND(AVG(total_sale)) DESC ) as rank
FROM retail_sales
GROUP BY sale_year , sale_month

 ) as table1
WHERE rank = 1;
 
	

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT *  FROM retail_sales
LIMIT 5;

SELECT  customer_id , 
       SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5 ;


-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT  COUNT(DISTINCT customer_id ) as unique_customers  , category
FROM retail_sales
GROUP BY category

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale as(
SELECT  CASE
     WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	 ELSE  'Evening'
	 END as shift
FROM retail_sales
)
SELECT shift ,  COUNT(*) AS no_of_orders
FROM hourly_sale
GROUP BY shift


                 -- END of Project --


