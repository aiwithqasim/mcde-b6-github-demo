--Task 1 — Build the Sales Detail Dataset (6 marks)
--Management needs a detailed sales dataset for analysis. Return one row per order item containing:
--order_id and order_date
--Include only completed orders (order_status = 4). Sort the result from newest order to oldest.
--order_id and order_date
--customer full name
--store name
--staff full name
--product name
--category name
--brand name
--quantity, list_price, discount
--calculated net_line_revenue


SELECT
 o.order_id,
 o.order_date,
 c.first_name+ ' ' +c.last_name AS customer_name,
 st.store_name,
 sf.first_name+' '+ sf.last_name AS staff_name,
 p.product_name,
 cat.category_name,
 b.brand_name,
 oi.quantity,
  oi.list_price,
 oi.discount,
 oi.quantity * oi.list_price * (1 - oi.discount) AS net_line_revenue

FROM sales.orders as o
INNER JOIN sales.customers as c
  ON o.customer_id = c.customer_id
INNER JOIN sales.stores as st
  ON o.store_id = st.store_id
INNER JOIN sales.staffs as sf
   ON o.staff_id = sf.staff_id
INNER JOIN sales.order_items as oi
  ON o.order_id = oi.order_id
INNER JOIN production.products as p
  ON oi.product_id = p.product_id
INNER JOIN production.categories as cat
  ON p.category_id = cat.category_id
INNER JOIN production.brands as b
  ON p.brand_id = b.brand_id
WHERE o.order_status = 4
ORDER BY
 o.order_date DESC,
 o.order_id DESC;

--Question 2
--Task 2 — Store Performance Summary (5 marks)
--Create a store-level performance report for completed orders showing:
--store name
--number of distinct orders
--total units sold
--total net revenue
--average order value
--Return one row per store and order the stores from highest to lowest total net revenue.


SELECT
  st.store_name,
  COUNT(DISTINCT o.order_id) AS total_orders,
  SUM(oi.quantity) AS total_units_sold,
  SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_net_revenue,
  SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / COUNT(DISTINCT o.order_id) AS average_order_value

FROM sales.stores AS st
INNER JOIN sales.orders AS o
  ON st.store_id = o.store_id
INNER JOIN sales.order_items AS oi
  ON o.order_id = oi.order_id
WHERE o.order_status = 4
GROUP BY
st.store_id,
st.store_name
ORDER BY
  total_net_revenue DESC;


--Task 3 — High-Value Customers (5 marks)
--Management wants to identify high-value customers. 
--Return customers whose total completed-order spending is greater than 
--the average total spending of customers who have completed orders.
--Show customer_id, customer name, completed order count, and total spending. 
--Order the result by total spending descending.

WITH CustomerSpending AS
(
  SELECT
    c.customer_id,
    c.first_name+ ' '+ c.last_name as customer_name,
    COUNT(DISTINCT o.order_id) as completed_order_count,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spending
    FROM sales.customers as c
    INNER JOIN sales.orders as o
    on c.customer_id = o.customer_id
    INNER JOIN sales.order_items as oi
    on o.order_id = oi.order_id
    WHERE o.order_status = 4
    GROUP BY
      c.customer_id,
      c.first_name,
      c.last_name)
SELECT
  customer_id,
  customer_name,
  completed_order_count,
  total_spending
FROM CustomerSpending
WHERE total_spending >
(SELECT AVG(total_spending)   FROM CustomerSpending)
ORDER BY
total_spending;



--Task 4 — Inventory Risk Report (5 marks)
--Operations wants to identify inventory risk.
--Return products where the stock quantity is below 5 in at least one store.
--Show product name, store name, current quantity, category name, and brand name.
--Products with zero stock should appear first, followed by the lowest remaining quantities.

SELECT
    p.product_name,
    s.store_name,
    st.quantity,
    cat.category_name,
    b.brand_name
FROM production.stocks st
JOIN production.products p
  on st.product_id = p.product_id
JOIN sales.stores s
  on st.store_id = s.store_id
JOIN production.categories cat
  on p.category_id = cat.category_id
JOIN production.brands b
  on p.brand_id = b.brand_id
WHERE st.quantity < 5
ORDER BY st.quantity;


--Task 5 — Top Products Within Each Category (6 marks)
--For each product category, identify the top 3 products by total net revenue from completed orders.
--Return category name, product name, total units sold, total net revenue, 
--and the product's position within its category. 
--Tied products must receive the same position and the next position should not contain gaps.
WITH product_sales AS
(
  SELECT
    cat.category_name,
    p.product_name,
    SUM(oi.quantity) as total_units_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as total_net_revenue,
    p.category_id
    FROM production.products p
    JOIN production.categories cat
      on p.category_id = cat.category_id
    JOIN sales.order_items oi
      on p.product_id = oi.product_id
    JOIN sales.orders o
      on oi.order_id = o.order_id
    WHERE o.order_status = 4
    GROUP BY
     cat.category_name,
     p.category_id,
     p.product_name
),
ranked_products AS
(
  SELECT
    category_name,
    product_name,
    total_units_sold,
    total_net_revenue,
    DENSE_RANK() OVER
    (PARTITION BY category_id ORDER BY total_net_revenue DESC) as product_position
    FROM product_sales
)
SELECT
    category_name,
    product_name,
    total_units_sold,
    total_net_revenue,
    product_position
FROM ranked_products
WHERE product_position <= 3
ORDER BY
    category_name,
    product_position;


--Task 6 — Monthly Sales Trend (6 marks)
--Create a monthly sales trend for completed orders.
--For each calendar month return:year,month,total net revenue,previous month's total net revenue
--revenue change from the previous month
--The first month may have NULL for the previous-month comparison. Sort chronologically.
WITH monthly_sales AS
(
  SELECT
    YEAR(o.order_date) as order_year,
     MONTH(o.order_date) as order_month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
    FROM sales.orders o
    JOIN sales.order_items oi
        on o.order_id = oi.order_id
    WHERE o.order_status = 4
    GROUP BY
      YEAR(o.order_date),
      MONTH(o.order_date)
)
SELECT
    order_year,
    order_month,
    total_revenue,
    LAG(total_revenue) OVER
    (
        ORDER BY order_year, order_month
    ) as previous_month_revenue,
    total_revenue -
    LAG(total_revenue) OVER
    (
        ORDER BY order_year, order_month
    ) as revenue_change

FROM monthly_sales
ORDER BY
    order_year,
    order_month;

--Task 7 — Reusable Reporting View (4 marks)
--Create a view named sales.vw_customer_sales_summary that returns one row per customer and includes:
--customer_id, customer full name ,total number of completed orders,total units purchased
--total net revenue ,,most recent completed order date
--Customers with no completed orders must still be represented where possible, 
--with appropriate zero/NULL values.

CREATE VIEW sales.vw_customer_sales_summary
AS
SELECT
  c.customer_id,
  c.first_name+' '+c.last_name as customer_name,
    COUNT(DISTINCT o.order_id) as total_completed_orders,
    ISNULL(SUM(oi.quantity), 0)as total_units_purchased,
    ISNULL(SUM( oi.quantity * oi.list_price * (1 - oi.discount)),0) as total_net_revenue,
    MAX(o.order_date) as most_recent_order_date

FROM sales.customers c

LEFT JOIN sales.orders o
    on c.customer_id = o.customer_id
    AND o.order_status = 4

LEFT JOIN sales.order_items oi
    on o.order_id = oi.order_id

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name;

SELECT *
FROM sales.vw_customer_sales_summary;


--Task 8 — Safe Data Modification (4 marks)
--A customer with customer_id = 1 has requested that their phone number be changed to '(999) 555-0101'.




--Task 9 — Store Sales Procedure (6 marks)
--Create a stored procedure named sales.usp_store_sales_report with these input parameters:
--@store_id
--@start_date
--@end_date






---Q10Task 10 — Management Insight Query (3 marks)
--Write one additional SQL query that you believe would provide useful insight to BikeStores management using at least three tables.
--Below the query, add a SQL comment of no more than three lines explaining:
--1. the business question,
--2. what the result measures, and
--3. why management should care about it.


SELECT
s.store_name,
st.first_name+ ' '+st.last_name as staff_name,
  COUNT(DISTINCT o.order_id) as total_orders,
  SUM(oi.quantity) as total_units_sold,
  SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
FROM sales.staffs st
JOIN sales.stores s
    on st.store_id = s.store_id
JOIN sales.orders o
    on st.staff_id = o.staff_id
JOIN sales.order_items oi
    on o.order_id = oi.order_id
WHERE o.order_status = 4
GROUP BY
    s.store_name,
    st.first_name,
    st.last_name
ORDER BY total_revenue DESC;