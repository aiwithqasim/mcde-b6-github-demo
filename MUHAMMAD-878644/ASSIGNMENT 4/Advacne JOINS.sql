use bikeStore


---- ASSINGMENT 04 ------


---- SELF JOIN----



SELECT
    s.staff_id,
    s.first_name || ' ' || s.last_name AS staff_name,
    m.first_name || ' ' || m.last_name AS manager_name
FROM sales.staffs s
LEFT JOIN sales.staffs m
    ON s.manager_id = m.staff_id;

----- Task 42 — Same-brand product pairs with identical list price

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
    ON b.brand_id = p1.brand_id;

    --- CROSS JOIN----

---------  Task 45 — Every brand × category combination


SELECT
    b.brand_name,
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c
ORDER BY b.brand_name, c.category_name;

-----  Task 46 — Brand-category combos with NO products


SELECT
    bc.brand_name,
    bc.category_name
FROM (
    SELECT b.brand_id, b.brand_name, c.category_id, c.category_name
    FROM production.brands b
    CROSS JOIN production.categories c
) bc
LEFT JOIN production.products p
    ON p.brand_id = bc.brand_id
    AND p.category_id = bc.category_id
WHERE p.product_id IS NULL
ORDER BY bc.brand_name, bc.category_name;

  ---- RIGHT JOIN ----

-----  Task 49 — All brands with their products (RIGHT JOIN)


SELECT
    b.brand_name,
    p.product_name
FROM production.products p
RIGHT JOIN production.brands b
    ON p.brand_id = b.brand_id
ORDER BY b.brand_name;

------  Task 50 — All stores with their orders (RIGHT JOIN)


SELECT
    s.store_name,
    o.order_id,
    o.order_date
FROM sales.orders o
RIGHT JOIN sales.stores s
    ON o.store_id = s.store_id
ORDER BY s.store_name;
Left Anti Join (LEFT JOIN + WHERE IS NULL)


   ----- Left Anti Join (LEFT JOIN + WHERE IS NULL)  ----

-------- Task 53 — Customers who never placed an order


SELECT c.customer_id, c.first_name, c.last_name
FROM sales.customers c
LEFT JOIN sales.orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

----  Task 54 — Products not in stock at any store


SELECT p.product_id, p.product_name
FROM production.products p
LEFT JOIN production.stocks st
    ON p.product_id = st.product_id
WHERE st.store_id IS NULL;

----  Task 56 — Products never ordered


SELECT p.product_id, p.product_name
FROM production.products p
LEFT JOIN sales.order_items oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

---- Task 59 — Categories with no product priced above 2000


SELECT c.category_id, c.category_name
FROM production.categories c
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) hp
    ON c.category_id = hp.category_id
WHERE hp.category_id IS NULL;

----  Task 60 — Customers who ordered, but never ordered a Trek product


SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM sales.customers c
JOIN sales.orders o
    ON c.customer_id = o.customer_id          
LEFT JOIN (
    SELECT DISTINCT o2.customer_id
    FROM sales.orders o2
    JOIN sales.order_items oi ON oi.order_id = o2.order_id
    JOIN production.products p ON p.product_id = oi.product_id
    JOIN production.brands b ON b.brand_id = p.brand_id
    WHERE b.brand_name = 'Trek'
) trek_buyers
    ON c.customer_id = trek_buyers.customer_id
WHERE trek_buyers.customer_id IS NULL;