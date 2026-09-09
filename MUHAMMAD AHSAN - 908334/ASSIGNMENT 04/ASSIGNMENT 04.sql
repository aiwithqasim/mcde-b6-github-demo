
--SELF JOIN--

-- List each staff member alongside their manager's full name. If a staff member has no manager (top-level), 
--still show them with NULL for manager name.

SELECT
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs s
LEFT JOIN sales.staffs m
    ON s.manager_id = m.staff_id;

--Find pairs of products from the same brand that have the exact same list price,
--Show both product names and the brand name.
SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    b.brand_name
FROM production.products p1
JOIN production.products p2
    ON p1.brand_id = p2.brand_id
    AND p1.list_price = p2.list_price
    AND p1.product_id < p2.product_id
JOIN production.brands b
    ON p1.brand_id = b.brand_id;

--CROSS JOIN--

--Generate a list of every possible combination of brand and category. Show brand name and category name.
SELECT
    b.brand_name,
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c;

 --Using the result of a CROSS JOIN between brands and categories, --find brand-category combinations that have NO products 
 --(LEFT JOIN the cross join result against products and filter for NULLs).
 SELECT
    b.brand_name,
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c
LEFT JOIN production.products p
    ON b.brand_id = p.brand_id
    AND c.category_id = p.category_id
WHERE p.product_id IS NULL;


--RIGHT JOIN--

--List all brands and the products that belong to them. Ensure ALL brands appear, even if they have no products. 
--Use a RIGHT JOIN (products RIGHT JOIN brands).
SELECT
    b.brand_name,
    p.product_name
FROM production.products p
RIGHT JOIN production.brands b
    ON p.brand_id = b.brand_id;

--Show all stores and the orders placed at each store. Use a RIGHT JOIN so that stores with zero orders still appear.
SELECT
    s.store_name,
    o.order_id
FROM sales.orders o
RIGHT JOIN sales.stores s
    ON o.store_id = s.store_id;


--Left Anti Join (LEFT JOIN + WHERE IS NULL)--

--Find all customers who have NEVER placed an order.
--Hint: LEFT JOIN sales.customers with sales.orders, then filter WHERE order_id IS NULL.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers c
LEFT JOIN sales.orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--Find all products that are NOT currently in stock at ANY store.
--Hint: LEFT JOIN production.products with production.stocks, filter WHERE store_id IS NULL.
SELECT
    p.product_id,
    p.product_name
FROM production.products p
LEFT JOIN production.stocks s
    ON p.product_id = s.product_id
WHERE s.store_id IS NULL;

--Find all products that have never been ordered.
SELECT
    p.product_id,
    p.product_name
FROM production.products p
LEFT JOIN sales.order_items oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

--Find categories where no product has a list price above 2000.
SELECT
    c.category_id,
    c.category_name
FROM production.categories c
WHERE NOT EXISTS (
    SELECT 1
    FROM production.products p
    WHERE p.category_id = c.category_id
      AND p.list_price > 2000
);

--Find customers who placed orders but never ordered any product from the brand 'Trek'.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers c
WHERE EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
)
AND NOT EXISTS (
    SELECT 1
    FROM sales.orders o
    JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    JOIN production.products p
        ON oi.product_id = p.product_id
    JOIN production.brands b
        ON p.brand_id = b.brand_id
    WHERE o.customer_id = c.customer_id
      AND b.brand_name = 'Trek'
);