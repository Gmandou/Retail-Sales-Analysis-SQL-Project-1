-- SQL Retail Sales Analysis
CREATE DATABASE sql_project_1;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales(
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

CREATE TABLE customers(
    customer_id INT,
    signup_date DATE,
    region VARCHAR(10)

);


SELECT * FROM retail_sales
LIMIT 10;

SELECT * FROM customers
LIMIT 10;

SELECT
    COUNT(*)
FROM retail_sales;

-- Data cleaning
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
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

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
           total_sale IS NULL
;

-- Join queries
SELECT c.customer_id,  c.region, SUM(r.total_sale) AS total_sales
FROM retail_sales r
INNER JOIN customers c
    ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.region
ORDER BY total_sales DESC
LIMIT 10;


-- Data exploration

-- How many sales we have?
SELECT  COUNT(transactions_id) AS total_sales
FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales
 ;

-- What categories do we have
SELECT DISTINCT category
FROM retail_sales
;

--Data Analysis & Business Key Problems
-- 1. Which product categories generate the highest total sales revenue?

-- 2. Which product categories generate the highest profit?

-- 3. What is the average sale amount?

-- 4. Which customer age groups contribute the most revenue?

-- 5. Which age groups purchase the highest quantities of products?




-- Results

-- 1. Which product categories generate the highest total sales revenue
SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category
ORDER BY  total_sales DESC;

-- 2. Which product categories generate the highest profit?
SELECT category, ROUND(SUM(total_sale - cogs)::numeric, 2) as total_profit
FROM retail_sales
GROUP BY category
ORDER BY  total_profit DESC;

-- 3. What is the average sale amount?
SELECT ROUND(AVG(total_sale)::numeric, 2) AS average_sale
FROM retail_sales;

-- 4. Which customer age groups contribute the most revenue?
SELECT age, round(SUM(total_sale)::numeric,2) AS total_revenue
FROM retail_sales
GROUP BY age
ORDER BY  total_revenue
;

-- 5. Which age groups purchase the highest quantities of products?
SELECT age, SUM(quantity) AS total_quantity
FROM retail_sales
GROUP BY age
ORDER BY  total_quantity DESC ;

-- 6 Calculate the average sale for each month. (Find out best selling month in each year)
WITH monthly_avg AS (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
            ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
)

SELECT year, month, avg_sale
FROM monthly_avg
WHERE rank = 1;

-- 7 Who is top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5 ;

-- 8 What is the average age of customers who purchased items from the 'Beauty' category?
SELECT ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 9 find the number of unique customers who purchased items from each category
SELECT category, COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

-- 10 Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT  * FROM retail_sales
WHERE category = 'Clothing'
  AND
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND
    quantity >= 4;

-- 11. What is the total revenue and customer count for each region?
SELECT c.region, COUNT(DISTINCT r.customer_id) AS num_customers, SUM(r.total_sale) AS total_revenue
FROM retail_sales r
    INNER JOIN customers c
    ON r.customer_id = c.customer_id
GROUP BY c.region
ORDER BY total_revenue DESC;

-- 12. Are there any customers who have never made a purchase?
SELECT c.customer_id, c.region, COALESCE(SUM(r.total_sale), 0) AS total_sales
FROM customers c
    LEFT JOIN retail_sales r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.region
ORDER BY total_sales ASC
LIMIT 10;

-- Project ended



