-- Problem Statement

-- The objective of this project is to analyze electronic sales transaction data to uncover patterns in revenue generation, customer purchasing behavior, and product performance. 
-- The analysis aims to identify key factors influencing sales and customer engagement.


-- Project Goal
-- The goal of this analysis is to generate actionable insights that help the business:

-- Improve sales strategy
-- Optimize marketing targeting
-- Enhance inventory planning
-- Identify opportunities for upselling and cross-selling



-- Database Creation

CREATE DATABASE electronic_sales;
USE electronic_sales;

-- Table Creation

CREATE TABLE sales (
customer_id INT,
age INT,
gender VARCHAR(10),
loyalty_member VARCHAR(10),
product_type VARCHAR(50),
sku VARCHAR(50),
rating DECIMAL(2,1),
order_status VARCHAR(20),
payment_method VARCHAR(20),
total_price DECIMAL(10,2),
unit_price DECIMAL(10,2),
quantity INT,
purchase_date DATE,
shipping_type VARCHAR(20),
addons_purchased TEXT,
addon_total DECIMAL(10,2)
);

select * from sales;

-- Data Cleaning

SELECT *
FROM sales
WHERE product_type IS NULL
OR total_price IS NULL;

UPDATE sales
SET addons_purchased = 'None'
WHERE addons_purchased IS NULL;

-- Data Quality Checks
-- You only checked NULL values. Add queries like:

SELECT COUNT(*) FROM sales;
SELECT COUNT(DISTINCT customer_id) FROM sales;
SELECT COUNT(DISTINCT sku) FROM sales;
-- Exploratory Data Analysis (EDA)

SELECT COUNT(*) AS total_orders
FROM sales;

-- Total Revenue
SELECT SUM(total_price) AS total_revenue
FROM sales
WHERE order_status = 'Completed';

-- Average Order Value

SELECT AVG(total_price) AS avg_order_value
FROM sales;

-- Sales Analysis
-- Revenue by Product Type

SELECT product_type,
SUM(total_price) AS revenue
FROM sales
GROUP BY product_type
ORDER BY revenue DESC;

-- Top 10 Selling Products
SELECT sku,
SUM(quantity) AS units_sold
FROM sales
GROUP BY sku
ORDER BY units_sold DESC
LIMIT 10;

-- Customer Analysis
-- Revenue by Gender

SELECT gender,
SUM(total_price) AS revenue
FROM sales
GROUP BY gender;

SELECT gender, COUNT(*) AS count_val
FROM sales
WHERE gender IS NOT NULL 
AND gender != '#N/A'
GROUP BY gender
ORDER BY count_val DESC
LIMIT 1;

UPDATE sales
SET gender = (
    SELECT gender
    FROM (
        SELECT gender
        FROM sales
        WHERE gender IS NOT NULL 
        AND gender != '#N/A'
        GROUP BY gender
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS mode_gender
)
WHERE gender = '#N/A' OR gender IS NULL;

SELECT gender, SUM(total_price) AS total_sales
FROM sales
GROUP BY gender;

-- Revenue by Loyalty Members

SELECT loyalty_member,
SUM(total_price) AS revenue
FROM sales
GROUP BY loyalty_member;

-- Payment Method Analysis

SELECT payment_method,
COUNT(*) AS total_orders,
SUM(total_price) AS revenue
FROM sales
GROUP BY payment_method
ORDER BY revenue DESC;

-- Shipping Preference

SELECT shipping_type,
COUNT(*) AS total_orders
FROM sales
GROUP BY shipping_type;

-- Monthly Sales Trend

SELECT
DATE_FORMAT(purchase_date,'%Y-%m') AS month,
SUM(total_price) AS revenue
FROM sales
GROUP BY month
ORDER BY month;

-- Add-on Sales Analysis

SELECT SUM(addon_total) AS addon_revenue
FROM sales;

-- Add-on Purchase Frequency

SELECT addons_purchased,
COUNT(*) AS frequency
FROM sales
GROUP BY addons_purchased
ORDER BY frequency DESC;

-- Customer Rating Analysis

SELECT product_type,
AVG(rating) AS avg_rating
FROM sales
GROUP BY product_type
ORDER BY avg_rating DESC;

-- Order Status Analysis

SELECT order_status,
COUNT(*) AS total_orders
FROM sales
GROUP BY order_status;

-- Business KPIs ::
-- Average order quantity


SELECT AVG(quantity) FROM sales;

-- Revenue per customer
SELECT customer_id,
SUM(total_price) AS customer_revenue
FROM sales
GROUP BY customer_id
ORDER BY customer_revenue DESC
LIMIT 10;


-- Insights ::
-- Few product categories contribute the majority of total revenue.
-- Loyalty members spend more compared to non-loyal customers.
-- Products with higher ratings tend to have higher sales.
-- Add-on purchases increase the overall order value.
-- Sales show peaks in certain months indicating seasonal demand.
-- Most customers purchase only 1–2 items per order.
-- A small group of customers generates a large portion of revenue.

-- Suggestions ::
-- Focus marketing campaigns on top-performing product categories.
-- Promote loyalty programs to increase repeat purchases.
-- Provide discounts or cashback on popular digital payment methods.
-- Highlight highly rated products in promotions and recommendations.
-- Use cross-selling strategies to promote add-on products.
-- Increase inventory and marketing during peak sales months.
-- Introduce bundle offers to increase average order value.
-- Offer personalized deals to retain high-value customers.