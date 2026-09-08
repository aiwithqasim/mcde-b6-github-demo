


-- ASSIGNMENT 4----------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------
--Self Join
----------------------------------------------------------------------------------------------------------------------


--Task 41: List each staff member alongside their manager's full name. If a staff member has no manager (top-level), still show them with NULL for manager name.

SELECT 
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs s
LEFT JOIN sales.staffs m
    ON s.manager_id = m.staff_id;


--Task 42: Find pairs of products from the same brand that have the exact same list price. Show both product names and the brand name.

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

--Task 43: Find all pairs of customers who live in the same city and state. Avoid duplicates (don't show A-B and B-A both).

SELECT 
    c1.first_name + ' ' + c1.last_name AS customer_1,
    c2.first_name + ' ' + c2.last_name AS customer_2,
    c1.city,
    c1.state
FROM sales.customers c1
JOIN sales.customers c2
    ON c1.city = c2.city
    AND c1.state = c2.state
    AND c1.customer_id < c2.customer_id;

--Task 44: List staff members who were hired at the same store as their manager.

SELECT 
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs s
JOIN sales.staffs m
    ON s.manager_id = m.staff_id
WHERE s.store_id = m.store_id;


----------------------------------------------------------------------------------------------------------------------
--Cross Join
----------------------------------------------------------------------------------------------------------------------

--Task 45: Generate a list of every possible combination of brand and category. Show brand name and category name.
--Hint: This is useful when you want to find which brand-category combos have no products.

SELECT 
    b.brand_name,
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c;

--Task 46: Using the result of a CROSS JOIN between brands and categories, find brand-category combinations that have NO products (LEFT JOIN the cross join result against products and filter for NULLs).

SELECT 
    b.brand_name,
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c
LEFT JOIN production.products p
    ON p.brand_id = b.brand_id
    AND p.category_id = c.category_id
WHERE p.product_id IS NULL;


--Task 47: Generate a report showing every store paired with every product, along with the stock quantity. If a store doesn't carry a product, show 0.
--Hint: CROSS JOIN stores with products, then LEFT JOIN with production.stocks.

SELECT 
    s.store_name,
    p.product_name,
    ISNULL(st.quantity, 0) AS stock_quantity
FROM sales.stores s
CROSS JOIN production.products p
LEFT JOIN production.stocks st
    ON s.store_id = st.store_id
    AND p.product_id = st.product_id;

--Task 48: Create all possible staff-store assignments (every staff paired with every store), then show which ones are the actual current assignments.

SELECT 
    st.first_name + ' ' + st.last_name AS staff_name,
    s.store_name,
    a.staff_id AS actual_assignment
FROM sales.staffs st
CROSS JOIN sales.stores s
LEFT JOIN sales.staffs a
    ON st.staff_id = a.staff_id
    AND s.store_id = a.store_id;

---------------------------------------------------------------------------------------------------------------------
--Right Join
----------------------------------------------------------------------------------------------------------------------

--Task 49: List all brands and the products that belong to them. Ensure ALL brands appear, even if they have no products. Use a RIGHT JOIN (products RIGHT JOIN brands).

SELECT 
    b.brand_name,
    p.product_name
FROM production.products p
RIGHT JOIN production.brands b
    ON p.brand_id = b.brand_id;

--Task 50: Show all stores and the orders placed at each store. Use a RIGHT JOIN so that stores with zero orders still appear.

SELECT 
    s.store_name,
    o.order_id,
    o.order_date
FROM sales.orders o
RIGHT JOIN sales.stores s
    ON o.store_id = s.store_id;


--Task 51: List all categories with their product count. Use a RIGHT JOIN to ensure categories with no products show a count of 0.

SELECT 
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM production.products p
RIGHT JOIN production.categories c
    ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name;

--Task 52: Show all staff members and the orders they handled. Use a RIGHT JOIN on orders RIGHT JOIN staffs, so staff who handled zero orders still appear.

SELECT 
    s.first_name + ' ' + s.last_name AS staff_name,
    o.order_id,
    o.order_date
FROM sales.orders o
RIGHT JOIN sales.staffs s
    ON o.staff_id = s.staff_id;

----------------------------------------------------------------------------------------------------------------------
--Left Anti Join (LEFT JOIN + WHERE IS NULL)
-----------------------------------------------------------------------------------------------------------------------

--Task 53: Find all customers who have NEVER placed an order.
--Hint: LEFT JOIN sales.customers with sales.orders, then filter WHERE order_id IS NULL.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers c
LEFT JOIN sales.orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


--Task 54: Find all products that are NOT currently in stock at ANY store.
--Hint: LEFT JOIN production.products with production.stocks, filter WHERE store_id IS NULL.

SELECT 
    p.product_id,
    p.product_name
FROM production.products p
LEFT JOIN production.stocks s
    ON p.product_id = s.product_id
WHERE s.store_id IS NULL;

--Task 55: Find brands that have NO products in the database.

 SELECT 
    b.brand_id,
    b.brand_name,
    COUNT(p.product_id) AS product_count
FROM production.brands b
LEFT JOIN production.products p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_id, b.brand_name;

--Task 56: Find all products that have never been ordered.
--Hint: LEFT JOIN production.products with sales.order_items, filter WHERE order_id IS NULL.

SELECT 
    p.product_id,
    p.product_name
FROM production.products p
LEFT JOIN sales.order_items oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

--Task 57: Find stores that have never had any staff assigned to them.

SELECT 
    s.store_id,
    s.store_name
FROM sales.stores s
LEFT JOIN sales.staffs st
    ON s.store_id = st.store_id
WHERE st.staff_id IS NULL;

--Task 58: Find staff members who have never handled a single order.

SELECT 
    s.staff_id,
    s.first_name,
    s.last_name
FROM sales.staffs s
LEFT JOIN sales.orders o
    ON s.staff_id = o.staff_id
WHERE o.order_id IS NULL;

--Task 59: Find categories where no product has a list price above 2000.
--Hint: LEFT anti-join categories against a subquery of categories that DO have products above 2000.

SELECT 
    c.category_id,
    c.category_name
FROM production.categories c
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) p
    ON c.category_id = p.category_id
WHERE p.category_id IS NULL;

--Task 60: Find customers who placed orders but never ordered any product from the brand 'Trek'.
--Hint: This combines a regular join (customers who ordered) with a left anti pattern (never ordered Trek).

SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers c
JOIN sales.orders o
    ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT DISTINCT
        o.customer_id
    FROM sales.orders o
    JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    JOIN production.products p
        ON oi.product_id = p.product_id
    JOIN production.brands b
        ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) t
    ON c.customer_id = t.customer_id
WHERE t.customer_id IS NULL;