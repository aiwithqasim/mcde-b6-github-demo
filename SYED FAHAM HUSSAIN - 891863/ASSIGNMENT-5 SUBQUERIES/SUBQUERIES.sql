-----SUBQUERIES-----
--TASK 1
--Write a query using a scalar subquery that returns all products with a list_price 
--above the average price in their brand. Use a correlated subquery in WHERE.

SELECT
     p1.product_id,
     p1.product_name,
     p1.list_price,
     p1.brand_id
FROM production.products AS p1 WHERE list_price > (
  SELECT 
        AVG(list_price) 
FROM production.products AS p2
WHERE p1.brand_id = p2.brand_id
);

--TASK 2
--Write a query using IN that returns all orders placed by customers living in New York or California.

SELECT
    o.order_id,
    o.customer_id
FROM sales.orders AS o  WHERE customer_id IN (
SELECT 
    c.customer_id
FROM sales.customers AS c
WHERE state IN ('NY', 'CA')
);

--TASK 3
--The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:
--SELECT customer_id FROM sales.customers
--WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders);

SELECT customer_id FROM sales.customers
WHERE customer_id NOT IN (
SELECT customer_id FROM sales.orders
WHERE customer_id IS NOT NULL
);

--TASK 4
--Using a derived table in FROM, write a query that finds the average number of items per order across all orders.

SELECT
     AVG(total_items) AS avg_total_itmes
FROM (
SELECT
     o1.order_id,
     SUM(o1.quantity) AS total_items
FROM sales.order_items AS o1
GROUP BY order_id
) AS orders_items

--TASK 5
--Rewrite the EXISTS example from section 8.6 using IN instead. Which version is safer and why?

--I DON'T UNDERSTAND THE QUESTION


--TASK 6
--Use CROSS APPLY to return the top 3 most recent orders for each customer. 
--Show customer_id, first_name, order_id, and order_date.

SELECT 
     c.customer_id,
     c.first_name,
     o.order_id,
     o.order_date
FROM sales.customers AS c CROSS APPLY (
SELECT TOP (3)
     o.order_id,
     o.order_date
FROM sales.orders AS o
WHERE o.order_id = c.customer_id
ORDER BY o.order_id ASC, order_date DESC
) AS o;

--TASK 7
--Think About It: = ANY (subquery) is functionally identical to IN (subquery). Given that, when would you choose ANY over IN,
--and when would you choose ALL? What business question naturally maps to ALL that cannot be expressed cleanly with IN?
   
--I DON'T UNDERSTAND THE QUESTION ALSO