                                    --//////////////--
                                    -- ASSIGNMENT 4 --    
                                    --//////////////--

                                      use bikestores;     
     
                               -- SELF JOIN (Tasks 41-42)

-- TASK 41: List each staff member alongside their manager's full name. If a staff member has no manager (top-level), still show them with NULL for manager name.

SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name
FROM sales.staffs s
LEFT JOIN sales.staffs m ON s.manager_id = m.staff_id;

-- TASK 42: Find pairs of products from the same brand that have the exact same list price. Show both product names and the brand name.

SELECT 
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    b.brand_name
FROM production.products p1
INNER JOIN production.products p2 
    ON p1.brand_id = p2.brand_id 
    AND p1.list_price = p2.list_price
    AND p1.product_id < p2.product_id
INNER JOIN production.brands b ON p1.brand_id = b.brand_id
ORDER BY b.brand_name;


                                      -- CROSS JOIN (Tasks 45-46)

-- TASK 45: Generate a list of every possible combination of brand and category. Show brand name and category name.

SELECT 
    b.brand_name,
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c
ORDER BY b.brand_name, c.category_name;

-- TASK 46: Using the result of a CROSS JOIN between brands and categories, find brand-category combinations that have NO products.

SELECT 
    b.brand_name,
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c
LEFT JOIN production.products p 
    ON b.brand_id = p.brand_id 
    AND c.category_id = p.category_id
WHERE p.product_id IS NULL
ORDER BY b.brand_name, c.category_name;


                                      -- RIGHT JOIN (Tasks 49-50)

-- TASK 49: List all brands and the products that belong to them. Ensure ALL brands appear, even if they have no products. Use a RIGHT JOIN.

SELECT 
    b.brand_name,
    p.product_name,
    p.list_price
FROM production.products p
RIGHT JOIN production.brands b ON p.brand_id = b.brand_id
ORDER BY b.brand_name;

-- TASK 50: Show all stores and the orders placed at each store. Use a RIGHT JOIN so that stores with zero orders still appear.

SELECT 
    st.store_name,
    o.order_id,
    o.order_date
FROM sales.orders o
RIGHT JOIN sales.stores st ON o.store_id = st.store_id
ORDER BY st.store_name;


                             -- LEFT ANTI JOIN (Tasks 53, 54, 56, 59, 60)

-- TASK 53: Find all customers who have NEVER placed an order.

SELECT 
    c.first_name,
    c.last_name,
    c.email
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- TASK 54: Find all products that are NOT currently in stock at ANY store.

SELECT 
    p.product_name,
    p.list_price
FROM production.products p
LEFT JOIN production.stocks s ON p.product_id = s.product_id
WHERE s.store_id IS NULL;

-- TASK 56: Find all products that have never been ordered.

SELECT 
    p.product_name,
    p.list_price
FROM production.products p
LEFT JOIN sales.order_items oi ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

-- TASK 59: Find categories where no product has a list price above 2000.

SELECT DISTINCT c.category_name
FROM production.categories c
LEFT JOIN production.products p 
    ON c.category_id = p.category_id 
    AND p.list_price > 2000
WHERE p.product_id IS NULL;

-- TASK 60: Find customers who placed orders but never ordered any product from the brand 'Trek'.

SELECT DISTINCT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email
FROM sales.customers c
INNER JOIN sales.orders o ON c.customer_id = o.customer_id
LEFT JOIN sales.order_items oi ON o.order_id = oi.order_id
LEFT JOIN production.products p ON oi.product_id = p.product_id
LEFT JOIN production.brands b ON p.brand_id = b.brand_id 
    AND b.brand_name = 'Trek'
WHERE b.brand_id IS NULL;