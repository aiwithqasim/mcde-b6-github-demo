--7.1 - Assign a sequential row number to each product ordered by list_price descending.
--Then assign a second row number partitioned by category_id, resetting within each category.

SELECT 
product_name, 
category_id, 
list_price, 
ROW_NUMBER() OVER (
ORDER BY list_price DESC ) AS overall_row_number, 
ROW_NUMBER() OVER ( 
PARTITION BY category_id ORDER BY list_price DESC ) AS category_row_number 
FROM production.products;


--7.2 - Write a query that returns each product with its RANK() and DENSE_RANK() by list_price descending within its category. 
--Show a product where the two rankings differ.

SELECT 
product_name, category_id, list_price, 
RANK() OVER ( 
PARTITION BY category_id ORDER BY list_price DESC ) AS price_rank, 
DENSE_RANK() OVER ( 
PARTITION BY category_id ORDER BY list_price DESC ) AS price_dense_rank 
FROM production.products ORDER BY category_id, list_price DESC;

--7.3 - Use LAG() to calculate the month-over-month revenue change for each store.
-- Show the current month revenue, the previous month revenue, and the difference.

WITH monthly_sales AS ( 
SELECT o.store_id, 
YEAR(o.order_date) AS sales_year, 
MONTH(o.order_date) AS sales_month, 
SUM( oi.quantity * oi.list_price * (1 - oi.discount) ) AS monthly_revenue 
FROM sales.orders o 
JOIN sales.order_items oi 
ON o.order_id = oi.order_id 
WHERE o.order_status = 4 
GROUP BY o.store_id, 
YEAR(o.order_date), 
MONTH(o.order_date) ) 
SELECT store_id, 
sales_year, 
sales_month, 
monthly_revenue, 
LAG(monthly_revenue) OVER ( 
PARTITION BY store_id ORDER BY sales_year, sales_month ) AS previous_month_revenue,
monthly_revenue - LAG(monthly_revenue) OVER ( 
PARTITION BY store_id 
ORDER BY sales_year, 
sales_month ) AS revenue_change 
FROM monthly_sales 
ORDER BY store_id, sales_year, sales_month;

--7.4 - Use NTILE(5) to divide all products into five price bands.
--Return the product name, price, and band number.

SELECT 
product_name, 
list_price, 
NTILE(5) OVER ( 
ORDER BY list_price DESC ) AS price_band 
FROM production.products 
ORDER BY list_price DESC;



--7.5 - Write a query that shows each order with a running total of revenue ordered by order_date. 
--Use ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.

SELECT 
o.order_id, 
o.order_date, 
SUM( oi.quantity * oi.list_price * (1 - oi.discount) ) AS order_revenue,
SUM( oi.quantity * oi.list_price * (1 - oi.discount) ) 
OVER ( ORDER BY o.order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS running_total 
FROM sales.orders o 
JOIN sales.order_items oi 
ON o.order_id = oi.order_id 
WHERE o.order_status = 4 
GROUP BY o.order_id, o.order_date 
ORDER BY o .order_date;