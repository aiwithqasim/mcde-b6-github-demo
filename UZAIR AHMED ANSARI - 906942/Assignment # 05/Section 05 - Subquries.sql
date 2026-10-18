                                    ---------- Assignment # 05 ----------
                                      ---------- Sub Queries ----------

--5.1 - Write a query using a scalar subquery that returns all products with a list_price above the average price in their brand. 
--Use a correlated subquery in WHERE.

SELECT
    p1.Product_name,
    p1.list_price,
    p1.brand_id
FROM production.products AS p1
WHERE list_price > (
    SELECT
        AVG(list_price)
    FROM production.products AS p2
    WHERE p2.brand_id = p1.brand_id
)
ORDER BY 
    brand_id,
    list_price;

SELECT AVG(list_price) FROM production.products WHERE brand_id = 1;



--5.2 - Write a query using IN that returns all orders placed by customers living in New York or California?
SELECT
    order_id,
    customer_id,
    order_date,
    store_id,
    staff_id
FROM sales.orders
WHERE customer_id IN 
(
    SELECT
        customer_id
    FROM sales.customers
    WHERE state IN ('NY','CA')
);


--5.3 - The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:

SELECT customer_id 
FROM sales.customers AS c
WHERE NOT EXISTS 
(
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
);

--5.4 - Using a derived table in FROM, write a query that finds the average number of items per order across all orders?
SELECT * FROM sales.order_items;
SELECT * FROM sales.orders;

SELECT
    AVG(order_summary.item_count) Avg_item_per_order 
FROM (
SELECT
    order_id,
    COUNT (order_id) AS item_count
FROM sales.order_items
GROUP BY order_id
) AS order_summary;

--5.5 - Rewrite the EXISTS example from section 8.6 using IN instead. Which version is safer and why?
-- Customers who placed at least one order in 2017

SELECT * FROM sales.customers;
SELECT * FROM sales.orders;

--Actual query with EXISTS clause
SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM sales.customers c
WHERE EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
      AND YEAR(o.order_date) = 2017
);

--Re-write the query with IN clause
SElECT
    customer_id,
    first_name,
    last_name
FROM sales.customers AS c
WHERE customer_id IN
(
    SELECT
        customer_id
    FROM sales.orders AS o
    WHERE YEAR(order_date) = 2017
);
/*For this particular query, both are generally fine if sales.orders.customer_id cannot contain problematic NULL values.
But as a general SQL rule:

EXISTS is safer when you are doing existence checking. Especially when you're dealing with: NOT IN versus NOT EXISTS.
The major problem is NULL Trap */

--5.6 - Use CROSS APPLY to return the top 3 most recent orders for each customer. Show customer_id, first_name, order_id, and order_date?
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date
FROM sales.customers AS c
CROSS APPLY (
    SELECT TOP 3
    ord.order_id,
    ord.order_date
FROM sales.orders AS ord
WHERE c.customer_id = ord.customer_id
ORDER BY ord.order_date DESC
)o;


--5.7 - Think About It: = ANY (subquery) is functionally identical to IN (subquery). Given that, when would you choose ANY over IN, 
--and when would you choose ALL? What business question naturally maps to ALL that cannot be expressed cleanly with IN?

/*= ANY (subquery) is functionally equivalent to IN (subquery) because both check whether a value matches at least one value returned 
by the subquery. In practice, IN is generally clearer when checking membership in a set, while ANY is useful when making comparisons 
such as > ANY or < ANY. ALL is used when a comparison must be true for every value returned by the subquery. A natural business question 
for ALL would be: "Which products have a price higher than every product in a particular category?" This cannot be expressed cleanly
with IN because IN checks equality/membership, whereas ALL allows us to express a universal comparison against an entire set of values*/




