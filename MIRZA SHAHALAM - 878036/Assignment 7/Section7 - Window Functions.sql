-- 7.1 - Assign a sequential row number to each product ordered by list_price descending. Then assign a second row
-- number partitioned by category_id, resetting within each category.

SELECT
	product_id,
	product_name,
	category_id,
	list_price,
ROW_NUMBER() over(ORDER BY list_price DESC) as row_num_all,
ROW_NUMBER() over(PARTITION BY category_id ORDER BY list_price DESC) as row_num_cat
FROM production.products

-- 7.2 - Write a query that returns each product with its RANK() and DENSE_RANK() by list_price descending within
-- its category. Show a product where the two rankings differ.

SELECT
	product_id,
	product_name,
	list_price,
	category_id,
RANK() over(PARTITION BY category_id ORDER BY list_price DESC) as rank_,
DENSE_RANK() over(PARTITION BY category_id ORDER BY list_price DESC) as dense_rank_
FROM production.products

-- 7.3 - Use LAG() to calculate the month-over-month revenue change for each store. Show the current month revenue,
-- the previous month revenue, and the difference.

WITH monthly_revenue as (
	SELECT	
		o.store_id,
		YEAR(o.order_date) as order_year,
		MONTH(o.order_date) as order_month,
		SUM(oi.quantity * oi.list_price * (1-oi.discount)) as current_month_revenue
	FROM sales.orders as o
	INNER JOIN sales.order_items as oi
		ON o.order_id = oi.order_id
	GROUP BY
		o.store_id,
		YEAR(o.order_date),
		MONTH(o.order_date)
)
SELECT
	store_id,
	order_year,
	order_month,
	current_month_revenue,
LAG(current_month_revenue) over(PARTITION BY store_id ORDER BY order_year, order_month) as previous_month_revenue,
current_month_revenue - LAG(current_month_revenue) over(PARTITION BY store_id ORDER BY order_year, order_month) as revenue_difference
FROM monthly_revenue
ORDER BY
	store_id,
	order_year,
	order_month

-- 7.4 - Use NTILE(5) to divide all products into five price bands. Return the product name, price, and band number.

SELECT
	product_name,
	list_price,
	NTILE(5) over(ORDER BY list_price) as band_number
FROM production.products
ORDER BY list_price

-- 7.5 - Write a query that shows each order with a running total of revenue ordered by order_date.
-- Use ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.

SELECT
	o.order_id,
	o.order_date,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as order_revenue,
	SUM(SUM(oi.quantity * oi.list_price * (1 - oi.discount))) over(
		ORDER BY o.order_date, o.order_id
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) as running_total_revenue
FROM sales.orders as o
INNER JOIN sales.order_items as oi
	ON o.order_id = oi.order_id
GROUP BY
	o.order_id,
	o.order_date
ORDER BY
	o.order_date,
	o.order_id

-- 7.6 - Think About It: Why does LAST_VALUE() require RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
-- to return the actual last value in the partition, while FIRST_VALUE() works correctly with the default frame?
-- What is the default window frame when ORDER BY is specified, and how does that explain the behavior?

-- Ans: Because with ORDER BY, the default frame is RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW,
-- so FIRST_VALUE() can see the first row of the partition, while LAST_VALUE() only sees up to the current row
-- and therefore needs RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING to see the actual last row.