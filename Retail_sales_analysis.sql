-- SQL Retail Sales Analysis - P1

-- Create Table 
CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR (15),
				age INT,
				category VARCHAR (25),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);

SELECT TOP 10 * FROM retail_sales;

--
SELECT 
	COUNT (*)
FROM retail_sales;


-- Data Cleaning
SELECT * 
FROM retail_sales
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
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

--Data Cleaning
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
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT (*) AS total_sale From retail_sales;

-- How many unique customers we have?
SELECT COUNT (DISTINCT customer_id) AS total_customers From retail_sales;

-- How many unique categories we have?
SELECT DISTINCT category From retail_sales;

-- Data Analysis, Key Business Problems & Answers

-- 1. Retrive all the columns where sales were made on '2022-11-05'

SELECT *
FROM retail_sales
where sale_date = '2022-11-05';

-- 2. Find all the transactions for clothing category and quantity sold is more than 10 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE 
	category = 'clothing'
	AND 
	quantity >= 3 
	AND
	sale_date >= '2022-11-01' 
	AND 
	sale_date <= '2022-11-30'
ORDER BY sale_date ;

-- 3. Find total sale for each category
SELECT 
	category,
	SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY category;

-- 4. Find average age of customers who puchased item from beauty category.

SELECT 
	ROUND(AVG(age), 2) AS avg_age
FROM retail_sales 
WHERE category = 'Beauty';

-- 5. Find all transactions where total_sale is greater than 1000

SELECT *
FROM retail_sales
WHERE total_sale >= 1000;

-- 6. Find the total number of transactions made by each gender in each category.

SELECT 
	gender,
	category,
	COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY
	category,
	gender
ORDER BY 
	category;

-- 7. Find and calculate the average sale for ech month. Also find out best selling month in each year.

WITH monthly_sales AS (
    SELECT
        YEAR(sale_date) AS sales_year,
        MONTH(sale_date) AS sales_month,
        AVG(total_sale) AS avg_sale
    FROM retail_sales
    GROUP BY
        YEAR(sale_date),
        MONTH(sale_date)
)
SELECT
    sales_year,
    sales_month,
    avg_sale
FROM (
    SELECT *,
           RANK() OVER (
               PARTITION BY sales_year
               ORDER BY avg_sale DESC
           ) AS sales_rank
    FROM monthly_sales
) ranked_sales
WHERE sales_rank = 1
ORDER BY sales_year;


-- 8. Find top 5 customers based on highest total sales.

SELECT TOP 5
	customer_id,
	SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC

-- 9. Find the number of unique customers who purchased items from the each category.

SELECT
	category,
	COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category

-- 10. Create each shift and number of orders (example Morning <=12, Afternoon between 12 & 17, Evening > 17).

WITH hourly_sales
AS 
(
SELECT *,
	CASE 
		WHEN DATEPART(HOUR, sale_time) < 12  THEN 'Morning'
		WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17  THEN 'Afternoon'
		ELSE 'Evening'
	END as shifts
FROM retail_sales
)
SELECT 
	shifts,
	COUNT(*) as total_orders
FROM hourly_sales
GROUP BY shifts; 

-- End of project