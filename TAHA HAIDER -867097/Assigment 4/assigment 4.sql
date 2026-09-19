
USE BikeStores;
GO

/* =========================================================
   SELF JOIN
   ========================================================= */

-- Task 41: List each staff member alongside their manager's full name.
-- Top-level staff (manager_id IS NULL) must still appear.
SELECT
    s.staff_id,
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id
ORDER BY s.staff_id;
GO


-- Task 42: Find pairs of products from the same brand
-- that have the exact same list price.
-- p1.product_id < p2.product_id prevents duplicate/reversed pairs.
SELECT
    b.brand_name,
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    p1.list_price
FROM production.products AS p1
JOIN production.products AS p2
    ON p1.brand_id = p2.brand_id
   AND p1.list_price = p2.list_price
   AND p1.product_id < p2.product_id
JOIN production.brands AS b
    ON p1.brand_id = b.brand_id
ORDER BY b.brand_name, p1.list_price;
GO


/* =========================================================
   CROSS JOIN
   ========================================================= */

-- Task 45: Every possible combination of brand and category.
SELECT
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c
ORDER BY b.brand_name, c.category_name;
GO


-- Task 46: Brand-category combinations that have NO products.
SELECT
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c
LEFT JOIN production.products AS p
    ON p.brand_id = b.brand_id
   AND p.category_id = c.category_id
WHERE p.product_id IS NULL
ORDER BY b.brand_name, c.category_name;
GO


/* =========================================================
   RIGHT JOIN
   ========================================================= */

-- Task 49: All brands and the products that belong to them.
-- RIGHT JOIN ensures ALL brands appear, even without products.
SELECT
    b.brand_name,
    p.product_id,
    p.product_name,
    p.list_price
FROM production.products AS p
RIGHT JOIN production.brands AS b
    ON p.brand_id = b.brand_id
ORDER BY b.brand_name, p.product_name;
GO


-- Task 50: All stores and the orders placed at each store.
-- RIGHT JOIN ensures stores with zero orders still appear.
SELECT
    s.store_id,
    s.store_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM sales.orders AS o
RIGHT JOIN sales.stores AS s
    ON o.store_id = s.store_id
ORDER BY s.store_id, o.order_id;
GO


/* =========================================================
   LEFT ANTI JOIN
   LEFT JOIN + WHERE IS NULL
   ========================================================= */

-- Task 53: Customers who have NEVER placed an order.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;
GO


-- Task 54: Products that are NOT currently in stock at ANY store.
SELECT
    p.product_id,
    p.product_name,
    p.list_price
FROM production.products AS p
LEFT JOIN production.stocks AS s
    ON s.product_id = p.product_id
WHERE s.store_id IS NULL
ORDER BY p.product_id;
GO


-- Task 56: Products that have NEVER been ordered.
SELECT
    p.product_id,
    p.product_name,
    p.list_price
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON oi.product_id = p.product_id
WHERE oi.order_id IS NULL
ORDER BY p.product_id;
GO


-- Task 59: Categories where NO product has a list price above 2000.
-- First, find categories that DO have a product above 2000.
-- Then LEFT JOIN categories to that result and keep NULLs.
SELECT
    c.category_id,
    c.category_name
FROM production.categories AS c
LEFT JOIN (
    SELECT DISTINCT
        category_id
    FROM production.products
    WHERE list_price > 2000
) AS expensive_categories
    ON c.category_id = expensive_categories.category_id
WHERE expensive_categories.category_id IS NULL
ORDER BY c.category_id;
GO


-- Task 60: Customers who placed orders but NEVER ordered
-- any product from the brand 'Trek'.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
JOIN sales.orders AS o
    ON o.customer_id = c.customer_id
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders AS o2
    JOIN sales.order_items AS oi
        ON oi.order_id = o2.order_id
    JOIN production.products AS p
        ON p.product_id = oi.product_id
    JOIN production.brands AS b
        ON b.brand_id = p.brand_id
    WHERE o2.customer_id = c.customer_id
      AND b.brand_name = 'Trek'
)
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY c.customer_id;
GO
