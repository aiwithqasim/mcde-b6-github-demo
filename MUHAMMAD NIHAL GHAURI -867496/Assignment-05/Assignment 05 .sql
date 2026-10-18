-- Task 29: Products above the overall average list price
SELECT *
FROM production.products
WHERE list_price > (SELECT AVG(list_price) FROM production.products);


-- Task 30: Customers who have never placed an order
SELECT *
FROM sales.customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
);


-- Task 31: Most expensive product in each category
WITH ranked_products AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        p.list_price,
        ROW_NUMBER() OVER (
            PARTITION BY p.category_id
            ORDER BY p.list_price DESC
        ) AS rn
    FROM production.products p
)
SELECT
    c.category_name,
    r.product_name,
    r.list_price
FROM ranked_products r
JOIN production.categories c ON c.category_id = r.category_id
WHERE r.rn = 1;


-- Task 32: Staff members who work in the store that generated the most revenue
WITH store_revenue AS (
    SELECT
        o.store_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON oi.order_id = o.order_id
    GROUP BY o.store_id
)
SELECT s.*
FROM sales.staffs s
WHERE s.store_id = (
    SELECT store_id
    FROM store_revenue
    WHERE revenue = (SELECT MAX(revenue) FROM store_revenue)
);



-- Task 33: Orders where the total order value exceeds 5000
WITH order_totals AS (
    SELECT
        order_id,
        SUM(quantity * list_price * (1 - discount)) AS order_total
    FROM sales.order_items
    GROUP BY order_id
)
SELECT o.*, ot.order_total
FROM sales.orders o
JOIN order_totals ot ON ot.order_id = o.order_id
WHERE ot.order_total > 5000;


-- Task 34: Products that have never been ordered
SELECT p.*
FROM production.products p
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.order_items oi
    WHERE oi.product_id = p.product_id
);


-- Task 35: Customer who has spent the most money overall
WITH customer_spend AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent
    FROM sales.orders o
    JOIN sales.order_items oi ON oi.order_id = o.order_id
    GROUP BY o.customer_id
)
SELECT c.*, cs.total_spent
FROM customer_spend cs
JOIN sales.customers c ON c.customer_id = cs.customer_id
WHERE cs.total_spent = (SELECT MAX(total_spent) FROM customer_spend);