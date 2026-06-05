# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis   
**Database**: `SQL_Project_P1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `SQL_Project_P1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE SQL_Project_P1


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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Retrive all the columns where sales were made on '2022-11-05'**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Find all the transactions for clothing category and quantity sold is more than 3 in the month of Nov-2022.**:
```sql
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
```

3. **Find total sale for each category.**:
```sql
SELECT 
	category,
	SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY category;
```

4. **Find average age of customers who puchased item from beauty category.**:
```sql
SELECT 
	ROUND(AVG(age), 2) AS avg_age
FROM retail_sales 
WHERE category = 'Beauty';
```

5. **Find all transactions where total_sale is greater than 1000**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Find the total number of transactions made by each gender in each category.**:
```sql
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
```

7. ** Find and calculate the average sale for ech month. Also find out best selling month in each year.**:
```sql
WITH monthly_sales AS
(
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

```

8. **Find top 5 customers based on highest total sales. **:
```sql
SELECT TOP 5
	customer_id,
	SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
```

9. **Find the number of unique customers who purchased items from the each category.**:
```sql
SELECT
	category,
	COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
```

10. **Create each shift and number of orders (example Morning <=12, Afternoon between 12 & 17, Evening > 17).**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## Author - Ganesh Goyal

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Lets Connect

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/ganesh-goyal13/)

Thank you for your support, and I look forward to connecting with you!
