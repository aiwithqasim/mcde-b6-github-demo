--7.1 - Assign a sequential row number to each product order by
--list_price desceding. Then assign a second row number partitioned
--by category_id, resetting within each category

SELECT 
    product_id,
    product_name,
    category_id,
    list_price,
    ROW_NUMBER() OVER(ORDER BY list_price DESC) AS overall_row_num,
    ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price DESC) AS category_row_num
FROM 
    production.products;


--7.2 - Write a query that returns each product with its RANK() and DENSE_RANK() by 
--list_price descending wihtin its category. Show a product where the two ranksings differ

WITH RankedProducts AS (
    SELECT 
        category_id,
        product_name,
        list_price,
        RANK() OVER (
            PARTITION BY category_id 
            ORDER BY list_price DESC
        ) AS product_rank,
        DENSE_RANK() OVER (
            PARTITION BY category_id 
            ORDER BY list_price DESC
        ) AS product_dense_rank
    FROM 
        production.products
)
SELECT 
    category_id,
    product_name,
    list_price,
    product_rank,
    product_dense_rank
FROM 
    RankedProducts
WHERE 
    product_rank <> product_dense_rank;

--7.3 - Use LAG() to calculate the month-over-month revenue change for each store. 
--Show the current month revenue, the previous month revenue, and the difference.

WITH MonthlyStoreRevenue AS (
    SELECT 
        o.store_id,
        CONVERT(VARCHAR(7), o.order_date, 120) AS revenue_month,
        SUM(i.quantity * i.list_price * (1 - i.discount)) AS current_month_revenue
    FROM 
        sales.orders o
    JOIN 
        sales.order_items i ON o.order_id = i.order_id
    GROUP BY 
        o.store_id,
        CONVERT(VARCHAR(7), o.order_date, 120)
)
SELECT 
    store_id,
    revenue_month,
    current_month_revenue AS current_month_revenue,
    LAG(current_month_revenue, 1, 0) OVER (PARTITION BY store_id ORDER BY revenue_month)
     AS previous_month_revenue,
   COALESCE((current_month_revenue - LAG(current_month_revenue, 1) OVER (PARTITION BY store_id 
    ORDER BY revenue_month)), 0) AS revenue_difference
FROM 
    MonthlyStoreRevenue
ORDER BY 
    store_id, 
    revenue_month;


--7.4 - Use NTILE(5) to divide all products into five price bands. Return product name, 
--price and band number

SELECT 
    product_name,
    list_price AS price,
    NTILE(5) OVER (ORDER BY list_price) AS band_number
FROM 
    production.products
ORDER BY 
    band_number, 
    list_price;


--7.5 - Write a query that shows each order with a running total of revenue 
--ordered by order_date. Use ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

With CTE_total_revenue AS
(
select 
order_id,
SUM(quantity * list_price * (1-discount)) AS total_revenue
FROM sales.order_items
group by order_id
)
select 
o.order_id,o.order_date, CTE.total_revenue,
SUM(CTE.total_revenue) OVER (order by o.order_date ROWS BETWEEN 
UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_revenue 
from CTE_total_revenue AS CTE
inner join sales.orders AS o
ON CTE.order_id = o.order_id
group by o.order_id, o.order_date, CTE.total_revenue;


--7.6 - Think About It: Why does LAST_VALUE() require RANGE BETWEEN 
--UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING to return the actual last value 
--in the partition, while FIRST_VALUE() works correctly with the default frame? 
--What is the default window frame when ORDER BY is specified, and how does 
--that explain the behavior?


--What is the Default Window Frame?
--When we specify an ORDER BY clause inside OVER() but do not explicitly 
--define a ROWS or RANGE frame, SQL automatically applies this hidden default:
--\[\textbf{RANGE\ BETWEEN\ UNBOUNDED\ PRECEDING\ AND\ CURRENT\ ROW}\]
--This means the window starts at the very first row of the partition 
--and dynamically grows, stopping exactly at the current 
--row (or the last duplicate/peer value of the current row).

--Behavior: 
--To visualize this, imagine a partition with 3 rows ordered by a 
--date: [A, B, C].Why FIRST_VALUE() Works Perfectly As SQL processes 
--each row using the default frame (UNBOUNDED PRECEDING AND CURRENT ROW):
--At Row 1: The window contains [A]. The first value is A.
--At Row 2: The window expands to [A, B].The first value is still A.
--At Row 3: The window expands to [A, B, C]. 
--The first value is still A. Because the start of the window is anchored at 
--UNBOUNDED PRECEDING, the first row never changes. FIRST_VALUE() always sees it.

--Why LAST_VALUE() Fails (Without Explicit Framing) Using the exact same 
--default frame (UNBOUNDED PRECEDING AND CURRENT ROW):
--At Row 1: The window is [A]. The last value in this window is A.
--At Row 2: The window expands to [A, B]. The last value in this window is now B
--.At Row 3: The window expands to [A, B, C]. The last value in this window is now C.
--Because the window frame ends at the current row, 
--LAST_VALUE() can never look ahead to see the actual end of the entire 
--partition. It is trapped by the moving boundary.