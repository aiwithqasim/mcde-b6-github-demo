						--Assignment 5
						--SUB QUERY QUESTION
USE BikeStores
GO
--5.1 - Write a query using a scalar subquery that returns all products with a list_price above the 
--average price in their brand.Use a correlated subquery in WHERE.
SELECT 
    p1.product_id,
    p1.product_name,
    p1.brand_id,
    p1.list_price
FROM production.products p1
WHERE p1.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.brand_id = p1.brand_id  -- ye line isko Correlated banati hai
)
ORDER BY p1.brand_id, p1.list_price DESC;
--5.1 END


--5.2 - Write a query using IN that returns all orders placed by customers living in New York or California.
SELECT 
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status
FROM sales.orders o
WHERE o.customer_id IN (
    SELECT c.customer_id
    FROM sales.customers c
    WHERE c.state IN ('NY', 'CA')
)
ORDER BY o.order_date;
--5.2 END


--5.3 - The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:
SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS full_name
FROM sales.customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
);
--5.3 END


--5.4 - Using a derived table in FROM, write a query that finds the average number of items per order 
--across all orders.
SELECT 
    AVG(item_count) AS avg_items_per_order
FROM (
    SELECT 
        order_id, 
        COUNT(*) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS OrderCounts;
--5.4 END  using  SUM(quantity) is also possible

--5.6 - Use CROSS APPLY to return the top 3 most recent orders for each customer. Show customer_id,
--first_name, order_id, and order_date.
SELECT 
    c.customer_id,
    c.first_name,
    recent_order.order_id,
    recent_order.order_date
FROM
    sales.customers c
CROSS APPLY (
    SELECT TOP 3 
        o.order_id,
        o.order_date 
    FROM
        sales.orders o 
    WHERE c.customer_id = o.customer_id
    ORDER BY o.order_date DESC
) AS recent_order;
--5.6 END


--5.7 - Think About It: = ANY (subquery) is functionally identical to IN (subquery). Given that, when would 
--you choose ANY over IN, and when would you choose ALL? What business question naturally maps to ALL that
--cannot be expressed cleanly with IN?


--5.7 END

