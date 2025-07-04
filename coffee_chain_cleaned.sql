CREATE DATABASE IF NOT EXISTS coffee_chain_cleaned;
USE coffee_chain_cleaned;

CREATE TABLE coffee_chain_cleaned (
    order_id INT,
    customer_id INT,
    order_date DATE,
    customer_name VARCHAR(100),
    region VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    product_id INT,
    quantity INT,
    product_name VARCHAR(100),
    category VARCHAR(100),
    price DECIMAL(10,2),
    total DECIMAL(10,2),
    year INT,
    month INT,
    day INT
);

SELECT region, SUM(total) AS revenue
FROM coffee_chain_cleaned
GROUP BY region
ORDER BY revenue DESC;

SELECT customer_name, SUM(total) AS total_spent
FROM coffee_chain_cleaned
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 5;

SELECT year, month, SUM(total) AS monthly_revenue
FROM coffee_chain_cleaned
GROUP BY year, month
ORDER BY year, month;

SELECT gender, COUNT(order_id) AS total_orders, SUM(total) AS total_revenue, AVG(total) AS avg_order_value
FROM coffee_chain_cleaned
GROUP BY gender;

SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(total) AS total_revenue,
    ROUND(SUM(total) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM coffee_chain_cleaned;

SELECT 
    customer_name,
    COUNT(order_id) AS order_count,
    SUM(total) AS total_spent,
    CASE
        WHEN SUM(total) >= 100 THEN 'High Spender'
        WHEN SUM(total) >= 50 THEN 'Medium Spender'
        ELSE 'Low Spender'
    END AS customer_segment
FROM coffee_chain_cleaned
GROUP BY customer_name
ORDER BY total_spent DESC;

SELECT 
    CONCAT(year, '-', LPAD(month, 2, '0')) AS month_label,
    SUM(total) AS monthly_revenue
FROM coffee_chain_cleaned
GROUP BY year, month
ORDER BY year, month;

SELECT 
    product_name,
    category,
    SUM(quantity) AS units_sold,
    SUM(total) AS revenue
FROM coffee_chain_cleaned
GROUP BY product_name, category
ORDER BY revenue DESC
LIMIT 5;

SELECT 
    region,
    COUNT(order_id) AS order_count,
    SUM(total) AS revenue,
    ROUND(SUM(total) / COUNT(order_id), 2) AS avg_order_value
FROM coffee_chain_cleaned
GROUP BY region
ORDER BY revenue DESC;

SELECT 
    category,
    SUM(total) AS revenue,
    ROUND(SUM(total) * 100 / (SELECT SUM(total) FROM coffee_chain_cleaned), 2) AS percentage
FROM coffee_chain_cleaned
GROUP BY category
ORDER BY revenue DESC;

SELECT 
    customer_type,
    COUNT(*) AS num_customers
FROM (
    SELECT 
        customer_name,
        CASE
            WHEN COUNT(order_id) = 1 THEN 'One-Time'
            ELSE 'Repeat'
        END AS customer_type
    FROM coffee_chain_cleaned
    GROUP BY customer_name
) AS t
GROUP BY customer_type;

CREATE VIEW customer_metrics AS
SELECT 
    customer_name,
    gender,
    region,
    age,
    COUNT(order_id) AS total_orders,
    SUM(total) AS total_spent,
    AVG(total) AS avg_order_value
FROM coffee_chain_cleaned
GROUP BY customer_name, gender, region, age;


