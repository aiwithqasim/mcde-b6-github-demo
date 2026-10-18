
--Task 53: Find all customers who have NEVER placed an order.
--Hint: LEFT JOIN sales.customers with sales.orders, then filter WHERE order_id IS NULL.

SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--Task 54: Find all products that are NOT currently in stock at ANY store.
--Hint: LEFT JOIN production.products with production.stocks, filter WHERE store_id IS NULL.

SELECT
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN production.stocks AS s
    ON p.product_id = s.product_id
WHERE s.store_id IS NULL;

--Task 56: Find all products that have never been ordered.
--Hint: LEFT JOIN production.products with sales.order_items, filter WHERE order_id IS NULL.

SELECT
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;


--Task 59: Find categories where no product has a list price above 2000.
--Hint: LEFT anti-join categories against a subquery of categories that DO have products above 2000.

SELECT
    c.category_id,
    c.category_name
FROM production.categories AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM production.products AS p
    WHERE p.category_id = c.category_id
      AND p.list_price > 2000
);


--Task 60: Find customers who placed orders but never ordered any product from the brand 'Trek'.
--Hint: This combines a regular join (customers who ordered) with a left anti pattern (never ordered Trek).

SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
WHERE EXISTS (
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
)
AND NOT EXISTS (
    SELECT 1
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    INNER JOIN production.products AS p
        ON oi.product_id = p.product_id
    INNER JOIN production.brands AS b
        ON p.brand_id = b.brand_id
    WHERE o.customer_id = c.customer_id
      AND b.brand_name = 'Trek'
);