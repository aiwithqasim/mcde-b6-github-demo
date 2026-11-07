--Self Join


--Task 41: List each staff member alongside their manager's full name. If a staff member has no manager (top-level), still show them with NULL for manager name.

SELECT 
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id;



--Task 42: Find pairs of products from the same brand that have the exact same list price. Show both product names and the brand name.

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



--Task 45: Generate a list of every possible combination of brand and category. Show brand name and category name.
--Hint: This is useful when you want to find which brand-category combos have no products.

SELECT 
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c;



--Task 46: Using the result of a CROSS JOIN between brands and categories, find brand-category combinations that have NO products (LEFT JOIN the cross join result against products and filter for NULLs).

SELECT 
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c
LEFT JOIN production.products AS p
    ON p.brand_id = b.brand_id
    AND p.category_id = c.category_id
WHERE p.product_id IS NULL;



--Task 49: List all brands and the products that belong to them. Ensure ALL brands appear, even if they have no products. Use a RIGHT JOIN (products RIGHT JOIN brands).

SELECT 
    b.brand_name,
    p.product_name
FROM production.products AS p
RIGHT JOIN production.brands AS b
    ON p.brand_id = b.brand_id;



--Task 50: Show all stores and the orders placed at each store. Use a RIGHT JOIN so that stores with zero orders still appear.

SELECT 
    s.store_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM sales.orders AS o
RIGHT JOIN sales.stores AS s
    ON o.store_id = s.store_id;



--Task 53: Find all customers who have NEVER placed an order.
--Hint: LEFT JOIN sales.customers with sales.orders, then filter WHERE order_id IS NULL.

SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name
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
    AND s.quantity > 0
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
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) AS high_price_categories
    ON c.category_id = high_price_categories.category_id
WHERE high_price_categories.category_id IS NULL;



--Task 60: Find customers who placed orders but never ordered any product from the brand 'Trek'.
--Hint: This combines a regular join (customers who ordered) with a left anti pattern (never ordered Trek).

SELECT DISTINCT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT DISTINCT
        o2.customer_id
    FROM sales.orders AS o2
    INNER JOIN sales.order_items AS oi
        ON o2.order_id = oi.order_id
    INNER JOIN production.products AS p
        ON oi.product_id = p.product_id
    INNER JOIN production.brands AS b
        ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) AS trek_customers
    ON c.customer_id = trek_customers.customer_id
WHERE trek_customers.customer_id IS NULL;