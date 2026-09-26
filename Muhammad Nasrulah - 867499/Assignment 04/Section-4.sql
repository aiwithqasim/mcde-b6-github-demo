--Self Join
-- List each staff member alongside their manager's full name
SELECT
    e.first_name + ' ' + e.last_name AS staff_member,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs AS e
LEFT JOIN sales.staffs AS m
    ON e.manager_id = m.staff_id;

-- Find pairs of products from the same brand with the exact same list price
SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    b.brand_name,
    p1.list_price
FROM production.products AS p1
INNER JOIN production.products AS p2
    ON p1.brand_id = p2.brand_id
    AND p1.list_price = p2.list_price
    AND p1.product_id < p2.product_id
INNER JOIN production.brands AS b
    ON p1.brand_id = b.brand_id;


--Cross Join
-- Generate every possible combination of brand and category
SELECT
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c;


-- Find brand-category combinations that have no products
SELECT
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c
LEFT JOIN production.products AS p
    ON b.brand_id = p.brand_id
    AND c.category_id = p.category_id
WHERE p.product_id IS NULL;

--Right Join
-- List all brands and the products that belong to them
SELECT
    b.brand_name,
    p.product_name
FROM production.products AS p
RIGHT JOIN production.brands AS b
    ON p.brand_id = b.brand_id;

-- Show all stores and the orders placed at each store
SELECT
    s.store_name,
    o.order_id,
    o.order_date
FROM sales.orders AS o
RIGHT JOIN sales.stores AS s
    ON o.store_id = s.store_id;

-- Left Anti Join
-- Find all customers who have never placed an order
SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Find all products that are not currently in stock at any store
SELECT
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN production.stocks AS s
    ON p.product_id = s.product_id
WHERE s.store_id IS NULL;


-- Find all products that have never been ordered
SELECT
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

-- Find categories where no product has a list price above 2000
SELECT
    c.category_id,
    c.category_name
FROM production.categories AS c
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) AS high_price
    ON c.category_id = high_price.category_id
WHERE high_price.category_id IS NULL;


-- Find customers who placed orders but never ordered any product from the brand Trek
SELECT DISTINCT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders AS o2
    INNER JOIN sales.order_items AS oi
        ON o2.order_id = oi.order_id
    INNER JOIN production.products AS p
        ON oi.product_id = p.product_id
    INNER JOIN production.brands AS b
        ON p.brand_id = b.brand_id
    WHERE o2.customer_id = c.customer_id
      AND b.brand_name = 'Trek'
);