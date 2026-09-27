--Q5.1) Write a query using a scalar subquery that returns all products with a list_price above the average price in their brand. Use a correlated subquery in WHERE.
SELECT 
    p1.product_id,
    p1.product_name,
    p1.brand_id,
    p1.list_price
FROM production.products AS p1
WHERE p1.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products AS p2
    WHERE p2.brand_id = p1.brand_id
);

--Q5.2) Write a query using IN that returns all orders placed by customers living in New York or California.
SELECT 
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status
FROM sales.orders AS o
WHERE o.customer_id IN (
    SELECT c.customer_id
    FROM sales.customers AS c
    WHERE c.state IN ('NY', 'CA')
);

--Q5.3) The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:
SELECT 
    c.customer_id
FROM sales.customers AS c
WHERE c.customer_id NOT IN (
    SELECT o.customer_id 
    FROM sales.orders AS o
    WHERE o.customer_id IS NOT NULL
);

--Q5.4) Using a derived table in FROM, write a query that finds the average number of items per order across all orders.
SELECT 
    AVG(order_counts.total_items * 1.0) AS avg_items_per_order
FROM (
    SELECT 
        oi.order_id,
        SUM(oi.quantity) AS total_items
    FROM sales.order_items AS oi
    GROUP BY oi.order_id
) AS order_counts;

--Q5.5) Rewrite the EXISTS example from section 8.6 using IN instead. Which version is safer and why?
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
WHERE c.customer_id IN (
    SELECT o.customer_id
    FROM sales.orders AS o
);

/*
Explanation (Safer Version & Why):
EXISTS is safer than IN.

Reason:
1. NULL Handling: When using NOT IN, if the subquery returns even a single NULL value, the entire query yields zero rows (NULL trap). NOT EXISTS handles NULL values predictably without unexpected empty result sets.
2. Performance & Optimization: EXISTS stops evaluating as soon as it finds the first matching record (short-circuit execution), whereas IN can be less efficient if subquery results are large and not properly indexed or deduplicated.
*/

--Q5.6) Use CROSS APPLY to return the top 3 most recent orders for each customer. Show customer_id, first_name, order_id, and order_date.
SELECT 
    c.customer_id,
    c.first_name,
    recent_orders.order_id,
    recent_orders.order_date
FROM sales.customers AS c
CROSS APPLY (
    SELECT TOP (3)
        o.order_id,
        o.order_date
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
    ORDER BY o.order_date DESC, o.order_id DESC
) AS recent_orders;

--Q5.7) Think About It: = ANY (subquery) is functionally identical to IN (subquery). Given that, when would you choose ANY over IN, and when would you choose ALL? What business question naturally maps to ALL that cannot be expressed cleanly with IN?
/*
Answer:

1. When to choose ANY over IN:
   - Use `IN` for equality checks (`= ANY`).
   - Use `ANY` when you need comparison operators other than equality, such as `>`, `<`, `>=`, or `<=`.
     Example: `WHERE list_price > ANY (SELECT list_price FROM ...)` finds products priced higher than AT LEAST ONE item in the subquery.

2. When to choose ALL:
   - Use `ALL` when a condition must hold true against EVERY single record returned by the subquery.

3. Business Question mapping to ALL (that cannot be expressed cleanly with IN):
   - Question: "Find all products that are more expensive than ALL products in the 'Children Bicycles' category."
   - SQL Query:
     SELECT product_name, list_price
     FROM production.products
     WHERE list_price > ALL (
         SELECT p.list_price
         FROM production.products AS p
         INNER JOIN production.categories AS c ON p.category_id = c.category_id
         WHERE c.category_name = 'Children Bicycles'
     );
   - Why IN fails here: `IN` only checks for membership/equality within a set, whereas `> ALL` tests a universal maximum threshold across the subquery result set.
*/