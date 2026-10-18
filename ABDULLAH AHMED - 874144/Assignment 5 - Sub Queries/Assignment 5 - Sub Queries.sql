/* 
    5.1 - Write a query using a scalar subquery that returns all products with a list_price
       above the average price in their brand. Use a correlated subquery in WHERE.*/

SELECT 
    p.product_name,
    p.brand_id,
    p.list_price
FROM production.products AS p
WHERE p.list_price > 
(
    SELECT AVG(p2.list_price)
    FROM production.products AS p2
    WHERE p2.brand_id = p.brand_id
) 


/*
  5.2 - Write a query using IN that returns all orders placed by customers living in New York 
        or California. */

SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_id,
    c.state
    FROM sales.customers AS c
    INNER JOIN sales.orders AS o 
            ON c.customer_id = o.customer_id
    WHERE c.state IN ('NY', 'CA');
    

    /*
      5.3 - The following query is meant to find customers who never ordered, but has a NULL trap. 
            Fix it:
          SELECT customer_id FROM sales.customers
          WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders); */

SELECT customer_id
FROM sales.customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM sales.orders 
    WHERE customer_id IS NOT NULL
);
  

/*
  5.4 - Using a derived table in FROM, write a query that finds the average number of items per order 
        across all orders.  */

SELECT AVG(order_count) AS avg_items_per_order
FROM (
    SELECT 
    order_id, 
    COUNT(*) AS order_count
    FROM sales.order_items
GROUP BY order_id
) AS order_totals


/*
 5.5 - Rewrite the EXISTS example from section 8.6 using IN instead. Which version is safer and why? */
   
-- Customers who placed at least one order in 2017

SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM sales.customers 
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.orders 
    WHERE YEAR(order_date) = 2017
);   
-- the exist version is safer because EXISTS checks whether a matching row exists and does not suffer 
--  from the NULL trap of NOT IN


/* 
 5.6 - Use CROSS APPLY to return the top 3 most recent orders for each customer. Show customer_id, 
       first_name, order_id, and order_date.  */

SELECT c.customer_id,
       c.first_name,
       o.order_id,
       o.order_date
FROM sales.customers AS c  
CROSS APPLY (
    SELECT TOP 3
    order_id,
    order_date
    FROM sales.orders AS o  
    WHERE o.customer_id = c.customer_id
    ORDER BY o.order_date DESC
) AS o 
ORDER BY c.customer_id, o.order_date DESC;


/*
 5.7 - Think About It: = ANY (subquery) is functionally identical to IN (subquery). Given that, 
       when would you choose ANY over IN, and when would you choose ALL? What business question 
       naturally maps to ALL that cannot be expressed cleanly with IN?  */

-- IN → when checking if a value exists in a list.
-- ANY → when comparing with at least one value.
-- ALL → when the condition must be true for every value.