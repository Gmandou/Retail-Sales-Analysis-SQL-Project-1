# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis
**Database**: `sql_project_1`


This project uses SQL to explore, clean, and analyze a retail sales dataset. It covers setting up the database, checking the data for issues, and running a series of queries to answer business questions about revenue, profit, and customer behavior.

## Objectives

1. **Set up the database**: create and populate a `retail_sales` table from the raw sales data.
2. **Clean the data**: check every column for missing values and remove incomplete records.
3. **Explore the data**: get a basic sense of row count, unique customers, and product categories.
4. **Answer business questions**: use SQL to pull out patterns in revenue, profit, and customer behavior.

## Project Structure

### 1. Database Setup

The database `sql_project_1` was created, and a `retail_sales` table was set up to hold transaction-level sales data — transaction ID, date and time of sale, customer details, product category, quantity, pricing, cost, and total sale amount.

```sql
CREATE DATABASE sql_project_1;

CREATE TABLE retail_sales (
    transactions_id INT,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Row count**: total number of sales records.
- **Customer count**: number of unique customers.
- **Category count**: distinct product categories present.
- **Null check**: every column was checked for missing values, and incomplete records were removed so they wouldn't distort the aggregate results.

```sql
SELECT COUNT(transactions_id) AS total_sales FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE
    transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR
    customer_id IS NULL OR gender IS NULL OR age IS NULL OR
    category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR
    cogs IS NULL OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE
    transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR
    customer_id IS NULL OR gender IS NULL OR age IS NULL OR
    category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR
    cogs IS NULL OR total_sale IS NULL;
```

### 3. Data Analysis & Findings

The following queries were written to answer specific business questions:

**1. Which product categories generate the highest total sales revenue?**

```sql
SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;
```

**2. Which product categories generate the highest profit?**

```sql
SELECT category, ROUND(SUM(total_sale - cogs)::numeric, 2) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;
```

**3. What is the average sale amount?**

```sql
SELECT ROUND(AVG(total_sale)::numeric, 2) AS average_sale
FROM retail_sales;
```

**4. Which customer age groups contribute the most revenue?**

```sql
SELECT age, ROUND(SUM(total_sale)::numeric, 2) AS total_revenue
FROM retail_sales
GROUP BY age
ORDER BY total_revenue DESC;
```

**5. Which age groups purchase the highest quantities of products?**

```sql
SELECT age, SUM(quantity) AS total_quantity
FROM retail_sales
GROUP BY age
ORDER BY total_quantity DESC;
```

**6. What's the average sale per month, and which month performed best each year?**

```sql
SELECT year, month, avg_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) AS t1
WHERE rank = 1;
```

**7. Who are the top 5 customers based on total sales?**

```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**8. What's the average age of customers who purchased from the 'Beauty' category?**

```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

**9. How many unique customers purchased from each category?**

```sql
SELECT category, COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM retail_sales
GROUP BY category;
```

**10. Which 'Clothing' transactions had a quantity of 4 or more in November 2022?**

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
    AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND quantity >= 4;
```

## Findings

*(Replace these with your real numbers once you run the queries in DataGrip — a couple of prompts for what to look for below.)*

- **Revenue leader**: which category came out on top in query 1, and by how much compared to the next category?
- **Profit vs. revenue**: does the highest-revenue category from query 1 match the highest-profit category from query 2 — or does margin tell a different story?
- **Age and spend**: which age group(s) stood out in queries 4 and 5 — do the same ages that spend the most also buy the most units, or are they different groups?
- **Seasonality**: which month(s) came out on top in query 6, and any plausible reason (holidays, promotions)?
- **Customer concentration**: from query 7, how much of total revenue do your top 5 customers represent?

## Reports

- **Sales summary**: total sales, average sale amount, and category-level performance.
- **Customer insights**: top-spending customers and unique customer counts per category.
- **Trend analysis**: monthly sales averages and the best-performing month per year.

## Conclusion

This project walks through the core SQL workflow a data analyst uses day to day: setting up a database, cleaning messy data, and translating raw transactions into answers to real business questions — which categories perform best, who the highest-value customers are, and when sales peak.

## How to Use

1. Clone this repository.
2. Run the setup section of [`sql_query_p1.sql`](./sql_query_p1.sql) to create the database and `retail_sales` table.
3. Import the sales data into the table.
4. Run the analysis queries to reproduce the findings.

## Author

This project is part of my data analytics portfolio, built to practice SQL for exploratory analysis and business reporting.
