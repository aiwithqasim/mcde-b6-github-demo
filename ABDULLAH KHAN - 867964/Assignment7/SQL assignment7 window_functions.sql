--									ASSIGNMENT 7 WINDOW FUNCTION
USE BikeStores
GO
-- 7.1 - Assign a sequential row number to each product ordered by list_price descending. Then assign a 
--second row number partitioned by category_id, resetting within each category.
select
product_id,
product_name,
category_id,
list_price,
ROW_NUMBER() over(ORDER BY list_price DESC ,product_id) AS over_all_row_no,
ROW_NUMBER() over(PARTITION BY category_id ORDER BY list_price DESC, product_id) AS Category_row_no
from
production.products
order by list_price DESC ,product_id;
-- 7.1 END


-- 7.2 - Write a query that returns each product with its RANK() and DENSE_RANK() by list_price descending
--within its category. Show a product where the two rankings differ.
select * from (
select
product_id,
product_name,
category_id,
list_price,
RANK() over(partition by category_id order by list_price DESC) AS rnk,
DENSE_RANK() over(partition by category_id order by list_price DESC) AS dns_rnk
from
production.products
) AS t
where rnk <> dns_rnk
order by list_price DESC;
-- 7.2 END


-- 7.3 - Use LAG() to calculate the month-over-month revenue change for each store. Show the current month
--revenue, the previous month revenue, and the difference.
WITH monthly_revenue AS (
    SELECT 
        o.store_id,
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS current_month_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.store_id, YEAR(o.order_date), MONTH(o.order_date)
)
SELECT
    store_id,
    order_year,
    order_month,
    current_month_revenue,
    LAG(current_month_revenue) OVER (PARTITION BY store_id ORDER BY order_year, order_month) AS previous_month_revenue,
    current_month_revenue - LAG(current_month_revenue) OVER (PARTITION BY store_id ORDER BY order_year, order_month) AS revenue_difference
FROM monthly_revenue
ORDER BY store_id, order_year, order_month;
-- 7.3 END


-- 7.4 - Use NTILE(5) to divide all products into five price bands. Return the product name, price, and
--band number.
select
product_name,
list_price,
ntile(5) over(order by list_price ASC) AS band_number
from 
production.products
order by list_price ASC
-- 7.4 END


-- 7.5 - Write a query that shows each order with a running total of revenue ordered by order_date. Use
--ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.
-- 7.5 Running Total
WITH OrderRevenue AS (
    SELECT 
        o.order_id,
        o.order_date,
       SUM (oi.quantity * oi.list_price * (1 - oi.discount)) AS order_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.order_date
)
SELECT
    order_id,
    order_date,
    order_revenue,
    SUM(order_revenue) OVER (ORDER BY order_date, order_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM OrderRevenue
ORDER BY order_date;
-- 7.5 END


/* 7.6 - Think About It: Why does LAST_VALUE() require RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
to return the actual last value in the partition, while FIRST_VALUE() works correctly with the default
frame? What is the default window frame when ORDER BY is specified, and how does that explain the behavior?

 /*Answer 7.6:

In SQL, when ORDER BY is used inside OVER(), the default window frame becomes:
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

It means for each row, the window includes rows from the beginning of the partition to the current row.

FIRST_VALUE() works correctly with this default frame because it requires the first row of the partition, 
and the first row is always present in the default frame which starts from UNBOUNDED PRECEDING.

On the other hand, LAST_VALUE() with the default frame returns an incorrect result. Since the frame ends
at CURRENT ROW, it only sees rows up to the current row and considers the current row itself as the 
last value. It cannot see the remaining rows in the partition.

Therefore, to make LAST_VALUE() return the actual last value of the entire partition, we must override the
default frame and use:

RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

This extends the frame from the first row to the last row of the partition, allowing LAST_VALUE() to access
and return the true last value.*/

-- 7.6 END