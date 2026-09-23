/*===========================================================================================================================================
7.1 - Assign a sequential row number to each product ordered by list_price descending. 
Then assign a second row number partitioned by category_id, resetting within each category.	
===========================================================================================================================================*/
SELECT 
	ROW_NUMBER() OVER(
		ORDER BY list_price DESC) AS row_no,
	ROW_NUMBER() OVER(
		PARTITION BY category_id
		ORDER BY list_price) AS second_row_no,
	product_id,
	product_name
FROM production.products;

/*===========================================================================================================================================
7.2 - Write a query that returns each product with its RANK() and DENSE_RANK() by list_price descending
within its category. Show a product where the two rankings differ.	
===========================================================================================================================================*/
WITH Ranked_products AS(
	SELECT 
		product_id,
		product_name,
		RANK() OVER(PARTITION BY category_id ORDER BY list_price DESC) AS RN,
		DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price DESC) AS DRN
	FROM production.products)

SELECT 
	product_id,
	product_name,
	RN,
	DRN
FROM Ranked_products
WHERE RN <> DRN;

/*===========================================================================================================================================
7.3 - Use LAG() to calculate the month-over-month revenue change for each store. Show the current month revenue,
the previous month revenue, and the difference.
===========================================================================================================================================*/
WITH MonthlyRevenue AS (
	SELECT
		s.store_id,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS current_month_revenue,
		MONTH(o.order_date) AS month_no,
		DATENAME(MONTH, o.order_date) AS month_name,
		YEAR(o.order_date) AS year
	FROM sales.stores s
	INNER JOIN sales.orders o
		ON s.store_id = o.store_id
	INNER JOIN sales.order_items oi
		ON o.order_id = oi.order_id
	GROUP BY s.store_id,
			MONTH(o.order_date), 
			DATENAME(MONTH, o.order_date), 
			YEAR(o.order_date)
	-- ORDER BY store_id, month_no, year	(CTE MN NHI CHALTA ORDER BY)
)

SELECT 
	store_id,
	month_no,
	month_name,
	year,
	current_month_revenue,
	LAG(current_month_revenue,1,0) OVER(PARTITION BY store_id ORDER BY year, month_no) AS prev_month_revenue,
	current_month_revenue - LAG(current_month_revenue,1,0) OVER(PARTITION BY store_id ORDER BY year, month_no) AS difference
FROM MonthlyRevenue
ORDER BY store_id, year, month_no;

/*===========================================================================================================================================
7.4 - Use NTILE(5) to divide all products into five price bands. Return the product name,
price, and band number.
=========================================================================================================================================== */
SELECT
	product_name,
	list_price,
	NTILE(5) OVER(ORDER BY list_price) AS band_no
FROM production.products;

/*===========================================================================================================================================
7.5 - Write a query that shows each order with a running total of revenue ordered by order_date.
Use ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.
===========================================================================================================================================*/
WITH TotalCalc AS (
	SELECT 
		o.order_id,
		o.order_date,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS order_revenue
	FROM sales.order_items oi
	INNER JOIN sales.orders o
		ON oi.order_id = o.order_id
	GROUP BY o.order_id, o.order_date
)
SELECT
	order_id,
	order_date,
	order_revenue,
	SUM(order_revenue) OVER(ORDER BY order_date) AS running_total
FROM TotalCalc;

/*=========================================================================================================================================== 
7.6 - Think About It: Why does LAST_VALUE() require RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING to return the actual last
value in the partition, while FIRST_VALUE() works correctly with the default frame? What is the default window frame when ORDER BY is 
specified, and how does that explain the behavior?
===========================================================================================================================================*/
-- ANSWER WITH EXPLANATION:
/*
Default Frame: RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW is automatically applied when ORDER BY is used.

Why FIRST_VALUE() Works: The starting point is UNBOUNDED PRECEDING (the first row of the partition), which stays fixed as the window expands.
So it always points to the first row.

Why LAST_VALUE() Fails: The frame ends at CURRENT ROW. Because of this, LAST_VALUE() only looks up to the current row and returns that row's
own value instead of evaluating the full partition.

The Fix: Extending the boundary using UNBOUNDED FOLLOWING forces SQL to include all remaining rows in the partition, allowing LAST_VALUE() 
to reach the actual end.
*/