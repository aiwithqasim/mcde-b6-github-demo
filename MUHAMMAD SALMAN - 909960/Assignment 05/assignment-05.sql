--5.1 - Correlated Subquery for Products Above Brand Average

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


--5.2 - Orders Placed by Customers in NY or CA Using IN

SELECT 
    o.order_id,
    o.customer_id,
    o.order_date,
    o.store_id
FROM sales.orders o
WHERE o.customer_id IN (
    SELECT c.customer_id
    FROM sales.customers c
    WHERE c.state IN ('NY', 'CA')
);

--5.3 - The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:

SELECT customer_id 
FROM sales.customers
WHERE customer_id NOT IN (
    SELECT customer_id 
    FROM sales.orders 
    WHERE customer_id IS NOT NULL
);


--5.4 - Using a derived table in FROM, write a query that finds the average number of items per order across all orders.

SELECT 
    AVG(items_per_order * 1.0) AS avg_items_per_order
FROM (
    SELECT 
        order_id,
        SUM(quantity) AS items_per_order
    FROM sales.order_items
    GROUP BY order_id
) AS order_item_counts;


--5.5 - Rewrite the EXISTS example from section 8.6 using IN instead. Which version is safer and why?
SELECT customer_id, first_name, last_name
FROM sales.customers
WHERE customer_id IN (
    SELECT customer_id 
    FROM sales.orders
);



--5.6 - Use CROSS APPLY to return the top 3 most recent orders for each customer.
--Show customer_id, first_name, order_id, and order_date.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    recent_orders.order_id,
    recent_orders.order_date
FROM sales.customers c
CROSS APPLY (
    SELECT TOP 3 
        o.order_id,
        o.order_date
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
    ORDER BY o.order_date DESC, o.order_id DESC
) AS recent_orders;


--5.7 - Think About It: = ANY (subquery) is functionally identical to IN (subquery).
--Given that, when would you choose ANY over IN, and when would you choose ALL? 
--What business question naturally maps to ALL that cannot be expressed cleanly with IN?

SELECT product_name, list_price
FROM production.products
WHERE list_price > ALL (
    SELECT p.list_price
    FROM production.products p
    JOIN production.categories c ON p.category_id = c.category_id
    WHERE c.category_name = 'Children Bicycles'
);


When to use ANY instead of IN:
IN only checks if something is equal to (=) a value in a list. ANY lets you use other math symbols like <, >, or <=.

Use ANY when you want to compare a value to at least one item in a list. For example: "Find items cheaper than at least one item in Category X" (price < ANY (...)). You can't do that with IN.

When to use ALL:
Use ALL when your condition has to be true for every single item in the list, not just one.

Real-world question for ALL:
"Which products cost more than every single bike in the 'Children Bicycles' category?"