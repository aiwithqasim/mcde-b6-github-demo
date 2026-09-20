-- ============================================================
-- Section 3 - JOINs
-- Student: Muhammad Talha
-- Saylani ID: CDE-884628
-- ============================================================

-- Task 12: List every product along with its brand name and category name.
SELECT
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products AS p
INNER JOIN production.brands AS b
    ON p.brand_id = b.brand_id
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id;

-- Task 13: List all orders with the customer's full name, order date, and order status.
SELECT
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_full_name,
    o.order_date,
    o.order_status
FROM sales.orders AS o
INNER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id;

-- Task 14: Show every order item with the product name, quantity, list price, and discount.
SELECT
    oi.order_id,
    p.product_name,
    oi.quantity,
    oi.list_price,
    oi.discount
FROM sales.order_items AS oi
INNER JOIN production.products AS p
    ON oi.product_id = p.product_id;

-- Task 15: List each staff member's full name alongside their store name.
SELECT
    s.first_name + ' ' + s.last_name AS staff_full_name,
    st.store_name
FROM sales.staffs AS s
INNER JOIN sales.stores AS st
    ON s.store_id = st.store_id;

-- Task 16: List staff members along with their manager's full name.
SELECT
    s.first_name + ' ' + s.last_name AS staff_full_name,
    m.first_name + ' ' + m.last_name AS manager_full_name
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id;

-- Task 17: Show stores and products in stock where quantity is greater than zero.
SELECT
    st.store_name,
    p.product_name,
    sk.quantity
FROM sales.stores AS st
INNER JOIN production.stocks AS sk
    ON st.store_id = sk.store_id
INNER JOIN production.products AS p
    ON sk.product_id = p.product_id
WHERE sk.quantity > 0;

-- Task 18: List all customers who placed at least one order with the order date.
SELECT
    c.first_name + ' ' + c.last_name AS customer_full_name,
    o.order_date
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;

-- Task 19: List all customers and their orders, including customers without orders.
SELECT
    c.first_name + ' ' + c.last_name AS customer_full_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;
