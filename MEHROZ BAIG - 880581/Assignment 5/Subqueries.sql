--Chapter 5: Subqueries -
--Exercise 5.1
SELECT 
    p1.product_name,
    p1.list_price,
    p1.brand_id
FROM production.products p1
WHERE p1.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.brand_id = p1.brand_id
);


--Exercise 5.2
SELECT 
    order_id, 
    customer_id, 
    order_date,
    store_id,
    staff_id
FROM sales.orders
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE state IN ('NY', 'CA') 
);


--Exercise 5.3
SELECT customer_id FROM sales.customers WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders);
Solution 1 (Fixing the NOT IN):
SELECT customer_id 
FROM sales.customers
WHERE customer_id NOT IN (
    SELECT customer_id 
    FROM sales.orders
    WHERE customer_id IS NOT NULL
);


--Solution 2 (Using NOT EXISTS - Generally Preferred):
SELECT customer_id 
FROM sales.customers c
WHERE NOT EXISTS (
    SELECT 1 
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
);


--Exercise 5.4
SELECT 
    AVG(CAST(item_count AS FLOAT)) AS avg_items_per_order
FROM (
    SELECT 
        order_id, 
        SUM(quantity) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_item_counts;


--Exercise 5.5
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


--Exercise 5.6
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
    ORDER BY order_date DESC
) AS o;
