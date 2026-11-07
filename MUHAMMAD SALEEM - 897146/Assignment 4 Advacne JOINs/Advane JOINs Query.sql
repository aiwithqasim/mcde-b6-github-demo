--Assignment Section Advance JOINs

use bikestores;

-- Task 41: Self Join


SELECT
    s.staff_id,
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs s
LEFT JOIN sales.staffs m
ON s.manager_id = m.staff_id;


-- Task 42: Self Join


SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    b.brand_name,
    p1.list_price
FROM production.products p1
JOIN production.products p2
    ON p1.brand_id = p2.brand_id
   AND p1.list_price = p2.list_price
   AND p1.product_id < p2.product_id
JOIN production.brands b
    ON p1.brand_id = b.brand_id;


-- Task 45: Cross Join


SELECT
    b.brand_name,
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c;


-- Task 46: Cross Join + Left Join


SELECT
    b.brand_name,
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c
LEFT JOIN production.products p
ON p.brand_id = b.brand_id
AND p.category_id = c.category_id
WHERE p.product_id IS NULL;



-- Task 49: Right Join



SELECT
    b.brand_name,
    p.product_name
FROM production.products p
RIGHT JOIN production.brands b
ON p.brand_id = b.brand_id;




-- Task 50: Right Joi


SELECT
    s.store_name,
    o.order_id,
    o.order_date
FROM sales.orders o
RIGHT JOIN sales.stores s
ON o.store_id = s.store_id;

-- Task 53: Left Anti Join



SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers c
LEFT JOIN sales.orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Task 54: Left Anti Join



SELECT
    p.product_id,
    p.product_name
FROM production.products p
LEFT JOIN production.stocks s
ON p.product_id = s.product_id
WHERE s.store_id IS NULL;


-- Task 56: Left Anti Join



SELECT
    p.product_id,
    p.product_name
FROM production.products p
LEFT JOIN sales.order_items oi
ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;



-- Task 59: Left Anti Join


SELECT
    c.category_name
FROM production.categories c
LEFT JOIN
(
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) p
ON c.category_id = p.category_id
WHERE p.category_id IS NULL;

-- Task 60: Customers who placed orders



SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers c
JOIN sales.orders o
    ON c.customer_id = o.customer_id
WHERE c.customer_id NOT IN
(
    SELECT DISTINCT o.customer_id
    FROM sales.orders o
    JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    JOIN production.products p
        ON oi.product_id = p.product_id
    JOIN production.brands b
        ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
);