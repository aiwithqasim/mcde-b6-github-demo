
---Self Join  (Tasks 41–44)---
--TASK NO: 41 [List each staff member alongside their manager's full name. If a staff member has no manager (top-level), still show them with NULL for manager name]

SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name
FROM sales.staffs s
LEFT JOIN sales.staffs m ON s.manager_id = m.staff_id;

--TASK NO: 42 [Find pairs of products from the same brand that have the exact same list price. Show both product names and the brand name]

SELECT 
    b.brand_name,
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    p1.list_price
FROM production.products p1
JOIN production.products p2 
    ON p1.brand_id = p2.brand_id 
   AND p1.list_price = p2.list_price 
   AND p1.product_id < p2.product_id
JOIN production.brands b ON p1.brand_id = b.brand_id;

--TASK NO: 43 [Find all pairs of customers who live in the same city and state. Avoid duplicates (don't show A-B and B-A both)] 

SELECT 
    c1.city,
    c1.state,
    CONCAT(c1.first_name, ' ', c1.last_name) AS customer_1,
    CONCAT(c2.first_name, ' ', c2.last_name) AS customer_2
FROM sales.customers c1
JOIN sales.customers c2 
    ON c1.city = c2.city 
   AND c1.state = c2.state 
   AND c1.customer_id < c2.customer_id;

--TASK NO: 44 [List staff members who were hired at the same store as their manager]

SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    s.store_id
FROM sales.staffs s
JOIN sales.staffs m ON s.manager_id = m.staff_id
WHERE s.store_id = m.store_id;

---Cross Join  (Tasks 45–48)---
--TASK NO: 45 [Generate a list of every possible combination of brand and category. Show brand name and category name]

SELECT 
    b.brand_name, 
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c;

--TASK NO: 46 [Using the result of a CROSS JOIN between brands and categories, find brand-category combinations that have NO products (LEFT JOIN the cross join result against products and filter for NULLs)]

SELECT 
    b.brand_name, 
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c
LEFT JOIN production.products p 
    ON b.brand_id = p.brand_id 
   AND c.category_id = p.category_id
WHERE p.product_id IS NULL;

--TASK NO: 47 [Generate a report showing every store paired with every product, along with the stock quantity. If a store doesn't carry a product, show 0]

SELECT 
    st.store_name,
    p.product_name,
    COALESCE(s.quantity, 0) AS stock_quantity
FROM sales.stores st
CROSS JOIN production.products p
LEFT JOIN production.stocks s 
    ON st.store_id = s.store_id 
   AND p.product_id = s.product_id;

--TASK NO: 48 [Create all possible staff-store assignments (every staff paired with every store), then show which ones are the actual current assignments]

SELECT 
    CONCAT(stf.first_name, ' ', stf.last_name) AS staff_name,
    str.store_name,
    CASE 
        WHEN stf.store_id = str.store_id THEN 'Actual Assignment'
        ELSE 'Not Assigned'
    END AS assignment_status
FROM sales.staffs stf
CROSS JOIN sales.stores str;

---Right Join (Tasks 49–52)---
--TASK NO: 49 [List all brands and the products that belong to them. Ensure ALL brands appear, even if they have no products. Use a RIGHT JOIN (products RIGHT JOIN brands)]

SELECT 
    b.brand_name, 
    p.product_name
FROM production.products p
RIGHT JOIN production.brands b ON p.brand_id = b.brand_id;

--TASK NO: 50 [Show all stores and the orders placed at each store. Use a RIGHT JOIN so that stores with zero orders still appear]

SELECT 
    s.store_name, 
    o.order_id
FROM sales.orders o
RIGHT JOIN sales.stores s ON o.store_id = s.store_id;

--TASK NO:51 [List all categories with their product count. Use a RIGHT JOIN to ensure categories with no products show a count of 0]

SELECT 
    c.category_name, 
    COUNT(p.product_id) AS total_products
FROM production.products p
RIGHT JOIN production.categories c ON p.category_id = c.category_id
GROUP BY c.category_name, c.category_id;

--TASK NO:52 [Show all staff members and the orders they handled. Use a RIGHT JOIN on orders RIGHT JOIN staffs, so staff who handled zero orders still appear]

SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    COUNT(o.order_id) AS total_orders
FROM sales.orders o
RIGHT JOIN sales.staffs s ON o.staff_id = s.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name;

---Left Anti Join (LEFT JOIN + WHERE IS NULL) (Tasks 53–60)---
--TASK NO:53 [Find all customers who have NEVER placed an order]

SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--TASK NO:54 [Find all products that are NOT currently in stock at ANY store]

SELECT 
    p.product_id, 
    p.product_name
FROM production.products p
LEFT JOIN production.stocks s ON p.product_id = s.product_id
WHERE s.store_id IS NULL;

--TASK NO:55 [Find brands that have NO products in the database]

SELECT 
    b.brand_id, 
    b.brand_name
FROM production.brands b
LEFT JOIN production.products p ON b.brand_id = p.brand_id
WHERE p.product_id IS NULL;

--TASK NO:56 [Find all products that have never been ordered]

SELECT 
    p.product_id, 
    p.product_name
FROM production.products p
LEFT JOIN sales.order_items oi ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

--TASK NO:57 [Find stores that have never had any staff assigned to them]

SELECT 
    s.store_id, 
    s.store_name
FROM sales.stores s
LEFT JOIN sales.staffs st ON s.store_id = st.store_id
WHERE st.staff_id IS NULL;

--TASK NO:58 [Find staff members who have never handled a single order]

SELECT 
    st.staff_id, 
    CONCAT(st.first_name, ' ', st.last_name) AS staff_name
FROM sales.staffs st
LEFT JOIN sales.orders o ON st.staff_id = o.staff_id
WHERE o.order_id IS NULL;

--TASK NO:59 [Find categories where no product has a list price above 2000]

SELECT 
    c.category_id, 
    c.category_name
FROM production.categories c
LEFT JOIN (
    SELECT DISTINCT category_id 
    FROM production.products 
    WHERE list_price > 2000
) p_expensive ON c.category_id = p_expensive.category_id
WHERE p_expensive.category_id IS NULL;

--TASK NO:60 [Find customers who placed orders but never ordered any product from the brand 'Trek']

SELECT DISTINCT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT DISTINCT o2.customer_id
    FROM sales.orders o2
    JOIN sales.order_items oi ON o2.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.brands b ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) trek_buyers ON c.customer_id = trek_buyers.customer_id
WHERE trek_buyers.customer_id IS NULL;