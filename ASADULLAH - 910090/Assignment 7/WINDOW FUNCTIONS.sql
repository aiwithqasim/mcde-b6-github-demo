--Task 7.1
SELECT product_id,
       product_name,
       category_id,
       list_price,
       ROW_NUMBER() OVER (ORDER BY list_price DESC) AS overall_row_number,
       ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS category_row_number
FROM   production.products;

-- Task 7.2
WITH     MonthlyRevenue
AS       (SELECT   o.store_id,
                   FORMAT(o.order_date, 'yyyy-MM') AS order_month,
                   SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
          FROM     sales.orders AS o
                   INNER JOIN
                   sales.order_items AS oi
                   ON o.order_id = oi.order_id
          GROUP BY o.store_id, FORMAT(o.order_date, 'yyyy-MM'))
SELECT   store_id,
         order_month,
         revenue AS current_month_revenue,
         LAG(revenue) OVER (PARTITION BY store_id ORDER BY order_month) AS previous_month_revenue,
         revenue - LAG(revenue) OVER (PARTITION BY store_id ORDER BY order_month) AS revenue_diffrence
FROM     MonthlyRevenue
ORDER BY store_id, order_month;

-- Task 7.4
SELECT   product_name,
         list_price,
         NTILE(5) OVER (ORDER BY list_price) AS price_band
FROM     production.products
ORDER BY list_price;

-- Task 7.5
SELECT   oi.order_id,
         so.order_date,
         oi.quantity,
         oi.list_price,
         oi.quantity * list_price AS revenue,
         SUM(quantity * list_price) OVER (ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_revenue
FROM     sales.order_items AS oi
         INNER JOIN
         sales.orders AS so
         ON oi.order_id = so.order_id
ORDER BY order_date;


-- Task 7.6
-- Think About It: 
-- Why does LAST_VALUE() require RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING 
-- to return the actual last value in the partition, 
-- while FIRST_VALUE() works correctly with the default frame? 
-- What is the default window frame when ORDER BY is specified, 
-- and how does that explain the behavior?
-- THINKING:
-- FIRST_VALUE() works with the default frame because the frame starts from the first 
-- row of the partition, so the first value is always included.
-- LAST_VALUE() needs UNBOUNDED FOLLOWING because the default frame only goes up to 
--- the current row. Therefore, without it, LAST_VALUE() usually returns the current 
-- row's value instead of the actual last value.