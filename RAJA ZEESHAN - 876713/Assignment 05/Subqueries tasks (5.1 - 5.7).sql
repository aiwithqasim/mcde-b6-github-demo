-- =====================================================
-- Chapter 5: Subqueries (The Data Foundry Exercises) (tasks-5.1 to 5.7)
-- =====================================================


-- 5.1 - Write a query using a scalar subquery that returns all products with a list_price above the average price in their brand. Use a correlated subquery in WHERE.

SELECT 
    p1.product_id,
    p1.product_name,
    p1.brand_id,
    p1.list_price
FROM production.products p1
WHERE p1.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.brand_id = p1.brand_id
);

-- 5.2 - Write a query using IN that returns all orders placed by customers living in New York or California.

SELECT 
    order_id,
    customer_id,
    order_date,
    order_status
FROM sales.orders
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE state IN ('NY', 'CA')
);


-- 5.3: Fix NULL trap in NOT IN

SELECT customer_id 
FROM sales.customers
WHERE customer_id NOT IN (
    SELECT customer_id 
    FROM sales.orders 
    WHERE customer_id IS NOT NULL
);


-- 5.4 - Using a derived table in FROM, write a query that finds the average number of items per order across all orders.

SELECT 
    AVG(1.0 * total_items) AS average_items_per_order
FROM (
    SELECT 
        order_id,
        SUM(quantity) AS total_items
    FROM sales.order_items
    GROUP BY order_id
) AS order_item_counts;


-- 5.5 - Rewrite the EXISTS example from section 8.6 using IN instead. Which version is safer and why?

SELECT customer_id, first_name, last_name
FROM sales.customers
WHERE customer_id IN (
    SELECT customer_id 
    FROM sales.orders
);

/*
Explanation for 5.5:
EXISTS is safer than IN because:
1. NULL Handling: If a subquery contains NULL values, NOT IN can return zero rows due to 3-valued logic (NULL Trap), whereas EXISTS handles boolean evaluation safely per row.
2. Performance: EXISTS stops evaluation as soon as it finds the first matching row, whereas IN evaluates the full result set.
*/


-- 5.6 - Use CROSS APPLY to return the top 3 most recent orders for each customer. Show customer_id, first_name, order_id, and order_date.

SELECT 
    c.customer_id,
    c.first_name,
    o.order_id,
    o.order_date
FROM sales.customers c
CROSS APPLY (
    SELECT TOP 3 
        order_id, 
        order_date
    FROM sales.orders
    WHERE customer_id = c.customer_id
    ORDER BY order_date DESC, order_id DESC
) o;


-- 5.7 - Think About It: = ANY (subquery) is functionally identical to IN (subquery). 
-- Given that, when would you choose ANY over IN, and when would you ch--oose ALL? 
-- What business question naturally maps to ALL that cannot be expressed cleanly with IN?
-- 5.7: Think About It (= ANY vs IN vs ALL) :

SELECT product_id, product_name, list_price
FROM production.products
WHERE list_price > ALL (
    SELECT list_price 
    FROM production.products 
    WHERE brand_id = 1
);

/*
Explanation for 5.7:
1. ANY vs IN: '= ANY' is functionally identical to 'IN'. However, ANY is useful when paired with inequality comparison operators like '> ANY' or '< ANY'.
2. When to choose ALL: Use 'ALL' when a comparison condition must be TRUE for every single value returned by the subquery.
3. Business Context: "Find all products whose price is strictly higher than ALL products in Brand 1.
" This cannot be written cleanly with IN because IN only checks for set membership/equality, whereas ALL enables universal range comparison.
*/