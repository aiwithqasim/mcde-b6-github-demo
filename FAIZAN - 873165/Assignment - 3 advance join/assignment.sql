-- =========================================================
-- SELF JOIN
-- =========================================================

-- Task 41: List each staff member alongside their manager's full name.
-- If a staff member has no manager (top-level), still show them with NULL for manager name.

SELECT 
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id;


-- Task 42: Find pairs of products from the same brand that have the exact same list price.
-- Show both product names and the brand name.

SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    b.brand_name
FROM production.products AS p1
INNER JOIN production.products AS p2
    ON p1.brand_id = p2.brand_id
    AND p1.list_price = p2.list_price
    AND p1.product_id < p2.product_id
INNER JOIN production.brands AS b
    ON p1.brand_id = b.brand_id;


-- Task 43: Find all pairs of customers who live in the same city and state.
-- Avoid duplicates (don't show A-B and B-A both).

SELECT
    c1.first_name + ' ' + c1.last_name AS customer_1,
    c2.first_name + ' ' + c2.last_name AS customer_2,
    c1.city,
    c1.state
FROM sales.customers AS c1
INNER JOIN sales.customers AS c2
    ON c1.city = c2.city
    AND c1.state = c2.state
    AND c1.customer_id < c2.customer_id;


-- Task 44: List staff members who were hired at the same store as their manager.

SELECT
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name,
    s.store_id
FROM sales.staffs AS s
INNER JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id
    AND s.store_id = m.store_id;




-- Task 45: Generate a list of every possible combination of brand and category.
-- Show brand name and category name.

SELECT
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c;


-- Task 46: Using the result of a CROSS JOIN between brands and categories,
-- find brand-category combinations that have NO products.

SELECT
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c
LEFT JOIN production.products AS p
    ON p.brand_id = b.brand_id
    AND p.category_id = c.category_id
WHERE p.product_id IS NULL;


-- Task 47: Generate a report showing every store paired with every product,
-- along with the stock quantity. If a store doesn't carry a product, show 0.

SELECT
    st.store_name,
    p.product_name,
    COALESCE(s.quantity, 0) AS quantity
FROM sales.stores AS st
CROSS JOIN production.products AS p
LEFT JOIN production.stocks AS s
    ON st.store_id = s.store_id
    AND p.product_id = s.product_id;


-- Task 48: Create all possible staff-store assignments (every staff paired with every store),
-- then show which ones are the actual current assignments.

SELECT
    s.first_name + ' ' + s.last_name AS staff_name,
    st.store_name,
    CASE
        WHEN s.store_id = st.store_id THEN 'Actual Assignment'
        ELSE 'Not Actual Assignment'
    END AS assignment_status
FROM sales.staffs AS s
CROSS JOIN sales.stores AS st;




-- Task 49: List all brands and the products that belong to them.
-- Ensure ALL brands appear, even if they have no products.
-- Use a RIGHT JOIN (products RIGHT JOIN brands).

SELECT
    b.brand_name,
    p.product_name
FROM production.products AS p
RIGHT JOIN production.brands AS b
    ON p.brand_id = b.brand_id;


-- Task 50: Show all stores and the orders placed at each store.
-- Use a RIGHT JOIN so that stores with zero orders still appear.

SELECT
    st.store_name,
    o.order_id,
    o.order_date
FROM sales.orders AS o
RIGHT JOIN sales.stores AS st
    ON o.store_id = st.store_id;


-- Task 51: List all categories with their product count.
-- Use a RIGHT JOIN to ensure categories with no products show a count of 0.

SELECT
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM production.products AS p
RIGHT JOIN production.categories AS c
    ON p.category_id = c.category_id
GROUP BY
    c.category_id,
    c.category_name;


-- Task 52: Show all staff members and the orders they handled.
-- Use a RIGHT JOIN on orders RIGHT JOIN staffs,
-- so staff who handled zero orders still appear.

SELECT
    s.first_name + ' ' + s.last_name AS staff_name,
    o.order_id,
    o.order_date
FROM sales.orders AS o
RIGHT JOIN sales.staffs AS s
    ON o.staff_id = s.staff_id;



-- Task 53: Find all customers who have NEVER placed an order.
-- Hint: LEFT JOIN sales.customers with sales.orders,
-- then filter WHERE order_id IS NULL.

SELECT
    c.first_name + ' ' + c.last_name AS customer_name
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Task 54: Find all products that are NOT currently in stock at ANY store.
-- Hint: LEFT JOIN production.products with production.stocks,
-- filter for products with no positive stock.

SELECT
    p.product_name
FROM production.products AS p
LEFT JOIN
(
    SELECT DISTINCT product_id
    FROM production.stocks
    WHERE quantity > 0
) AS s
    ON p.product_id = s.product_id
WHERE s.product_id IS NULL;


-- Task 55: Find brands that have NO products in the database.

SELECT
    b.brand_name
FROM production.brands AS b
LEFT JOIN production.products AS p
    ON b.brand_id = p.brand_id
WHERE p.product_id IS NULL;


-- Task 56: Find all products that have never been ordered.
-- Hint: LEFT JOIN production.products with sales.order_items,
-- filter WHERE order_id IS NULL.

SELECT
    p.product_name
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;


-- Task 57: Find stores that have never had any staff assigned to them.

SELECT
    st.store_name
FROM sales.stores AS st
LEFT JOIN sales.staffs AS s
    ON st.store_id = s.store_id
WHERE s.staff_id IS NULL;


-- Task 58: Find staff members who have never handled a single order.

SELECT
    s.first_name + ' ' + s.last_name AS staff_name
FROM sales.staffs AS s
LEFT JOIN sales.orders AS o
    ON s.staff_id = o.staff_id
WHERE o.order_id IS NULL;


-- Task 59: Find categories where no product has a list price above 2000.
-- Hint: LEFT anti-join categories against categories
-- that DO have products above 2000.

SELECT
    c.category_name
FROM production.categories AS c
LEFT JOIN
(
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) AS p
    ON c.category_id = p.category_id
WHERE p.category_id IS NULL;


-- Task 60: Find customers who placed orders but never ordered any product
-- from the brand 'Trek'.
-- Hint: Combine a regular join with a left anti pattern.

SELECT DISTINCT
    c.first_name + ' ' + c.last_name AS customer_name
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
LEFT JOIN
(
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