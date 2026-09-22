								/* Assignment # 07 */
/*7.1 - Assign a sequential row number to each product ordered by list_price descending. Then assign a second row number 
partitioned by category_id, resetting within each category*/
SELECT * FROM production.products;

SELECT
	product_id,
	product_name,
	category_id,
	list_price,

	ROW_NUMBER() OVER (
		ORDER BY list_price DESC
	) AS Row_num,

	ROW_NUMBER() OVER (
		PARTITION BY category_id
		ORDER BY list_price DESC
	) AS category_row_num

FROM production.products;

/*7.2 - Write a query that returns each product with its RANK() and DENSE_RANK() by list_price descending within its category. Show a 
product where the two rankings differ*/

/*to show a product where two rankings differ, the first idea is use to WHERE clause but in this case we can not use WHERE
clause in Window functions, that is why we make a CTE and then use another query to get the required results*/

WITH ranked_products AS 
(						
	SELECT
		product_id,
		product_name,
		category_id,
		list_price,
		RANK() OVER (
			PARTITION BY category_id
			ORDER BY list_price DESC
		)AS Rank_row,

		DENSE_RANK() OVER (
			PARTITION BY category_id
			ORDER BY list_price DESC
		) AS Dense_row
	FROM production.products
)
SELECT
	*
FROM ranked_products
WHERE Rank_row <> Dense_row;

/*7.3 - Use LAG() to calculate the month-over-month revenue change for each store. Show the current month revenue, the previous month 
revenue, and the difference*/
WITH monthly_revenue AS
(
	SELECT
		o.store_id,
		YEAR(o.order_date) AS order_year,
		MONTH(o.order_date) AS order_month,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
	FROM sales.orders AS o
	INNER JOIN sales.order_items AS oi
		ON oi.order_id = o.order_id
	GROUP BY
		o.store_id,
		YEAR(o.order_date),
		MONTH(o.order_date)
),
revenue_with_previous AS 
(
	SELECT
		store_id,
		order_year,
		order_month,
		revenue,
		
		LAG(revenue) OVER 
		(
			PARTITION BY store_id
			ORDER BY order_year, order_month
		) AS previous_month_revenue

	FROM monthly_revenue
)

SELECT
	store_id,
	order_year,
	order_month,
	revenue AS current_month_revenue,
	previous_month_revenue,
	revenue - previous_month_revenue AS revenue_difference

FROM revenue_with_previous
ORDER BY
	store_id,
	order_year,
	order_month;

/*7.4 - Use NTILE(5) to divide all products into five price bands. Return the product name, price, and band number*/
SELECT
	product_name,
	list_price,

	NTILE(5) OVER
	(ORDER BY list_price) AS price_quartile

FROM production.products
ORDER BY list_price;

/*7.5 - Write a query that shows each order with a running total of revenue ordered by order_date. Use ROWS BETWEEN UNBOUNDED PRECEDING 
AND CURRENT ROW*/
SELECT * FROM sales.orders;
SELECT * FROM sales.order_items;


SELECT
	o.order_id,
	o.order_date,
	SUM(quantity * list_price * (1 - discount)) OVER 
	(
		ORDER BY o.order_id, o.order_date
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS running_total_revenue
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
	ON o.order_id = oi.order_id
ORDER BY
	o.order_id,
	o.order_date;

WITH order_revenue AS
(
    SELECT
        o.order_id,
        o.order_date,

        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        ) AS revenue

    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id

    GROUP BY
        o.order_id,
        o.order_date
)

SELECT
    order_id,
    order_date,
    revenue,

    SUM(revenue) OVER (
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_total_revenue

FROM order_revenue

ORDER BY
    order_date,
    order_id;

/*7.6 - Think About It: Why does LAST_VALUE() require RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING to return the actual 
last value in the partition, while FIRST_VALUE() works correctly with the default frame? What is the default window frame when ORDER BY 
is specified, and how does that explain the behavior?*/

/*Answer - When ORDER BY is specified, the default window frame is generally RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW. Therefore, 
FIRST_VALUE() works because the first row of the partition is always included in the frame. However, LAST_VALUE() only sees rows up to the 
current row, so its "last" value is the last value in the current frame, often the current row itself. To return the actual last value of 
the entire partition, the frame must be extended through UNBOUNDED FOLLOWING: RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING*/

