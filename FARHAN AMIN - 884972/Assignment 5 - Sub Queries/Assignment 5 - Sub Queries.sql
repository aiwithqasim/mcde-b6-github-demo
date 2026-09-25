--5.1 - Write a query using a scalar subquery that returns all products 
--with a list_price above the average price in their brand. 
--Use a correlated subquery in WHERE. 
use BikeStores;
go
SELECT p1.product_name, p1.brand_id, p1.list_price
FROM production.products p1
WHERE p1.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.brand_id = p1.brand_id
);

--5.2 - Write a query using IN that returns all orders placed by customers 
--living in New York or California.

select o.* from sales.orders AS o
WHERE o.customer_id IN
(
select c.customer_id
from sales.customers AS c
WHERE state IN ('NY', 'CA')
);

--5.3 - The following query is meant to find customers who never ordered, 
--but has a NULL trap. Fix it:

--SELECT customer_id FROM sales.customers
--WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders);

--Method 1: NOT EXISTS
SELECT c.customer_id 
FROM sales.customers AS c
WHERE NOT EXISTS (
SELECT 1 
FROM sales.orders AS o
WHERE o.customer_id = c.customer_id 
);

--Method 2: NOT IN
SELECT c.customer_id 
FROM sales.customers AS c
WHERE c.customer_id NOT IN (
SELECT o.customer_id
FROM sales.orders AS o
WHERE o.customer_id IS NOT NULL
);

--5.4 - Using a derived table in FROM, write a query that finds average
--number of items per order across all orders

select 
AVG(total_items) AS average_items_per_order
from (
select COUNT(*) AS total_items
from sales.order_items AS oi
group by oi.order_id
) AS order_counts;

--5.5 - Rewrite the EXISTS example from section 5.6 using IN instead.
-- which version is safer and why?

-- Customers who placed at least one order in 2017

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city
FROM sales.customers c
WHERE customer_id IN 
(
    SELECT o.customer_id
    FROM sales.orders o
    WHERE YEAR(o.order_date) = 2017
);
--EXISTS is generally considered safer and better practice for two 
--major reasons: handling NULL values and consistent performance.

--5.6 - Use CROSS APPLY to return the top 3 most recent orders for each customer.
--Show customer_id, first_name, order_id and order_date

    SELECT 
    c.customer_id, 
    c.first_name, 
    o.order_id, 
    o.order_date
FROM 
    sales.customers c
CROSS APPLY 
    (
        SELECT TOP 3 
            so.order_id, 
            so.order_date
        FROM 
            sales.orders AS so
        WHERE 
            so.customer_id = c.customer_id
        ORDER BY 
            so.order_date DESC, 
            so.order_id DESC 
    ) o;

--5.7 -  Think about it: = ANY (subquery) is functionally identical to IN (subquery)
--Given that when would you choose ANY over IN, and when would you choose ALL?
--What business question naturally maps to ALL that cannot be expressed cleanly
--with IN?

--(1) - ANY over IN: When we need to perform inequality comparisons using operators 
--other than equals

--(2) - We choose ALL when a condition must be true against every single value
--returned by subquery

--(3) - Business questions that require finding values that are 'greater or less than
--all other values' maps naturally to ALL. These cannot be cleanly expressed with IN
--because IN only checks for an exact match within the list. 

