-- Assignment: Self Join, Cross Join, Right Join, Left Anti Join
-- Student:Muhammad Talha
-- Saylani ID: [CDE-884628]
-- BATCH (CDE6)

------------------------------------------------
-- Self Join
------------------------------------------------

-- Task 41
SELECT s.staff_id, s.first_name, s.last_name,
       m.first_name AS manager_first_name,
       m.last_name AS manager_last_name
FROM sales.staffs s
LEFT JOIN sales.staffs m
       ON s.manager_id = m.staff_id;

-- Task 42
SELECT p1.product_name AS product1,
       p2.product_name AS product2,
       b.brand_name
FROM production.products p1
JOIN production.products p2
       ON p1.brand_id = p2.brand_id
      AND p1.list_price = p2.list_price
      AND p1.product_id < p2.product_id
JOIN production.brands b
       ON p1.brand_id = b.brand_id;

-- Task 43
SELECT c1.first_name AS customer1,
       c2.first_name AS customer2,
       c1.city, c1.state
FROM sales.customers c1
JOIN sales.customers c2
       ON c1.city = c2.city
      AND c1.state = c2.state
      AND c1.customer_id < c2.customer_id;

-- Task 44
SELECT s.staff_id, s.first_name, s.last_name, s.store_id,
       m.staff_id AS manager_id, m.first_name AS manager_first_name
FROM sales.staffs s
JOIN sales.staffs m
       ON s.manager_id = m.staff_id
      AND s.store_id = m.store_id;

------------------------------------------------
-- Cross Join
------------------------------------------------

-- Task 45
SELECT b.brand_name, c.category_name
FROM production.brands b
CROSS JOIN production.categories c;

-- Task 46
SELECT bc.brand_name, bc.category_name
FROM (SELECT b.brand_id, b.brand_name, c.category_id, c.category_name
      FROM production.brands b
      CROSS JOIN production.categories c) bc
LEFT JOIN production.products p
       ON bc.brand_id = p.brand_id
      AND bc.category_id = p.category_id
WHERE p.product_id IS NULL;

-- Task 47
SELECT st.store_name, p.product_name,
       COALESCE(s.quantity, 0) AS stock_quantity
FROM sales.stores st
CROSS JOIN production.products p
LEFT JOIN production.stocks s
       ON st.store_id = s.store_id
      AND p.product_id = s.product_id;

-- Task 48
SELECT s.staff_id, s.first_name, st.store_id, st.store_name,
       CASE WHEN s.store_id = st.store_id THEN 'Assigned'
            ELSE 'Not Assigned' END AS assignment_status
FROM sales.staffs s
CROSS JOIN sales.stores st;

------------------------------------------------
-- Right Join
------------------------------------------------

-- Task 49
SELECT b.brand_name, p.product_name
FROM production.products p
RIGHT JOIN production.brands b
       ON p.brand_id = b.brand_id;

-- Task 50
SELECT st.store_name, o.order_id
FROM sales.orders o
RIGHT JOIN sales.stores st
       ON o.store_id = st.store_id;

-- Task 51
SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM production.products p
RIGHT JOIN production.categories c
       ON p.category_id = c.category_id
GROUP BY c.category_name;

-- Task 52
SELECT st.first_name, st.last_name, o.order_id
FROM sales.orders o
RIGHT JOIN sales.staffs st
       ON o.staff_id = st.staff_id;

------------------------------------------------
-- Left Anti Join
------------------------------------------------

-- Task 53
SELECT c.customer_id, c.first_name, c.last_name
FROM sales.customers c
LEFT JOIN sales.orders o
       ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Task 54
SELECT p.product_id, p.product_name
FROM production.products p
LEFT JOIN production.stocks s
       ON p.product_id = s.product_id
WHERE s.store_id IS NULL;

-- Task 55
SELECT b.brand_id, b.brand_name
FROM production.brands b
LEFT JOIN production.products p
       ON b.brand_id = p.brand_id
WHERE p.product_id IS NULL;

-- Task 56
SELECT p.product_id, p.product_name
FROM production.products p
LEFT JOIN sales.order_items oi
       ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

-- Task 57
SELECT st.store_id, st.store_name
FROM sales.stores st
LEFT JOIN sales.staffs s
       ON st.store_id = s.store_id
WHERE s.staff_id IS NULL;

-- Task 58
SELECT s.staff_id, s.first_name, s.last_name
FROM sales.staffs s
LEFT JOIN sales.orders o
       ON s.staff_id = o.staff_id
WHERE o.order_id IS NULL;

-- Task 59
SELECT c.category_id, c.category_name
FROM production.categories c
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) sub ON c.category_id = sub.category_id
WHERE sub.category_id IS NULL;

-- Task 60
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM sales.customers c
JOIN sales.orders o
       ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT DISTINCT o.customer_id
    FROM sales.orders o
    JOIN sales.order_items oi
           ON o.order_id = oi.order_id
    JOIN production.products p
           ON oi.product_id = p.product_id
    JOIN production.brands b
           ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) trek_orders ON c.customer_id = trek_orders.customer_id
WHERE trek_orders.customer_id IS NULL;
