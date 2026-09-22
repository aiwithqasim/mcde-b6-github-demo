--Joins
--1.  (Easy)  List every order with the customer's full name, store name, and the full name of the staff member who handled it.
SELECT
o.order_id,
c.first_name + ' ' + c.last_name AS customer_full_name,
s.store_name,
st.first_name + ' ' + st.last_name AS staff_full_name
FROM sales.customers c
JOIN sales.orders o
ON c.customer_id = o.customer_id
JOIN sales.staffs st
ON o.staff_id = st.staff_id
JOIN sales.stores s
ON  st.store_id = s.store_id;

--2.  (Easy)  Show each product with its brand name and category name. Include products even if they have no brand or category assigned.
SELECT 
p.product_id,
p.product_name,
b.brand_name,
c.category_name
FROM production.products p
LEFT JOIN production.brands b
ON p.brand_id = b.brand_id
LEFT JOIN production.categories c
ON p.category_id = c.category_id;

--3.  (Medium)  Find all customers who have never placed an order. Return their name, city, and email.
SELECT
c.first_name + ' ' + c.last_name AS customer_full_name,
c.city,
c.email,
o.order_id
FROM sales.customers c
LEFT JOIN sales.orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--GROUP BY
--4.  (Easy)  Calculate total revenue per store. Revenue = quantity * list_price * (1 - discount). Sort from highest to lowest.
SELECT 
s.store_name,
SUM(oi.quantity * oi.list_price * ( 1-oi.discount)) AS Revenue_per_store
FROM sales.orders o
JOIN sales.order_items oi
ON o.order_id = oi.order_id
JOIN sales.stores s
ON o.store_id = s.store_id
GROUP BY s.store_name 
ORDER BY Revenue_per_store DESC;

--5.  (Medium)  For each brand, show the number of products, the average list price,
--and the highest list price. Only include brands with more than 5 products.
SELECT
b.brand_name,
COUNT(p.product_id) AS product_count,
AVG(p.list_price) AS avg_price,
MAX(p.list_price) AS max_price
FROM production.brands b
JOIN production.products p
ON p.brand_id = b.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 5;

--6.  (Medium)  Show the number of orders and total revenue per month for the year 2017, ordered chronologically.
SELECT
MONTH(o.order_date) AS order_month,
COUNT(DISTINCT o.order_id) AS num_of_order,
SUM(oi.quantity * oi.list_price * ( 1-oi.discount)) AS Revenue_per_month
FROM sales.orders o
JOIN sales.order_items oi
ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY MONTH(o.order_date)
ORDER BY MONTH(o.order_date)ASC;

--7.  (Medium)  Find all products priced above the average list price of their own category.
--Hint: Use a correlated subquery.
SELECT
p1.product_id,
p1.product_name,
p1.category_id,
p1.list_price
FROM production.products p1
WHERE p1.list_price > (
  SELECT AVG(p2.list_price)
  FROM production.products p2
  WHERE p1.category_id = p2.category_id
);

--8.  (Medium)  List the customers who have placed more orders than the average number of orders per customer.
SELECT
c.customer_id,
c.first_name + ' ' + c.last_name AS customer_name,
COUNT(o.order_id) AS order_count
FROM sales.customers c
JOIN sales.orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name
HAVING COUNT(o.order_id) >(
  SELECT AVG(order_count)
  FROM
  (
     SELECT customer_id,
     COUNT(order_id) AS order_count
     FROM sales.orders
     GROUP BY customer_id
  ) AS customer_order
);    

--CTEs
--9.  (Hard)  Using a CTE, calculate each customer's total spend, then return the top 10 customers with their spend and rank.
--Add a second CTE that labels each customer as "High" (above the overall average spend) or "Regular".


WITH customer_spend AS (
 SELECT
 c.customer_id,
 c.first_name + ' ' + c.last_name AS customer_name,
 SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS Total_spend
 FROM sales.customers c
 JOIN sales.orders o
 ON c.customer_id = o.customer_id
 JOIN sales.order_items oi
 ON o.order_id = oi.order_id
 GROUP BY c.customer_id,c.first_name,c.last_name
),

customer_label AS (
SELECT
cs.customer_id,
cs.customer_name,
cs.Total_spend,
CASE WHEN Total_spend > (SELECT AVG(Total_spend) FROM customer_spend )
THEN 'High'
ELSE 'Regular'
END AS spend_label
FROM customer_spend cs
),
ranked_customers AS (
SELECT *,
RANK() OVER (ORDER BY Total_spend DESC) AS spend_rank
FROM customer_label
)
SELECT TOP 10 * 
FROM ranked_customers
ORDER BY Total_spend DESC;

--10.  (Hard)  Using CTEs, find the best-selling product (by quantity) in each category, 
--and show how much of that product's stock is currently available across all stores.
--Hint: Use ROW_NUMBER() or RANK() partitioned by category, then join to production.stocks.
WITH product_sales AS
(
    SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    SUM(oi.quantity) AS total_quantity
    FROM production.products p
    JOIN sales.order_items oi
    ON p.product_id = oi.product_id
    GROUP BY p.product_id,p.product_name,p.category_id
),

ranked_products AS
(
    SELECT *,
        ROW_NUMBER() OVER
        (
            PARTITION BY category_id
            ORDER BY total_quantity DESC
        ) AS rn
    FROM product_sales
)

SELECT
rp.product_id,
rp.product_name,
rp.category_id,
rp.total_quantity,
SUM(s.quantity) AS total_stock
FROM ranked_products rp
JOIN production.stocks s
ON rp.product_id = s.product_id
WHERE rp.rn = 1
GROUP BY rp.product_id, rp.product_name, rp.category_id, rp.total_quantity;

--•Rewrite Q8 using a CTE instead of a subquery and compare readability.
WITH customer_orders AS
(
  SELECT
  customer_id,
  COUNT(order_id) AS order_count
  FROM sales.orders
  GROUP BY customer_id
)
SELECT
c.customer_id,
c.first_name + ' ' + c.last_name AS customer_name,
co.order_count
FROM sales.customers c
JOIN customer_orders co
ON c.customer_id = co.customer_id
WHERE co.order_count >
(
  SELECT AVG(order_count)
  FROM customer_orders
);
--CTE is generally easier to read

--•For Q4, add a column showing each store's percentage share of total company revenue.
WITH store_revenue AS
(
  SELECT
   s.store_id,
   s.store_name,
   SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
   FROM sales.stores s
   JOIN sales.orders o
   ON s.store_id = o.store_id
   JOIN sales.order_items oi
   ON o.order_id = oi.order_id
   GROUP BY s.store_id, s.store_name
)
SELECT
store_id,
store_name,
revenue,
revenue * 100.0 / (SELECT SUM(revenue) FROM store_revenue) AS percentage_share
FROM store_revenue;

