-- Q1
SELECT
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    s.store_name,
    CONCAT(st.first_name, ' ', st.last_name) AS staff_name
FROM sales.orders o
JOIN sales.customers c ON o.customer_id = c.customer_id
JOIN sales.stores s ON o.store_id = s.store_id
JOIN sales.staffs st ON o.staff_id = st.staff_id;


-- Q2
SELECT
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products p
LEFT JOIN production.brands b ON p.brand_id = b.brand_id
LEFT JOIN production.categories c ON p.category_id = c.category_id;


-- Q3
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    c.email
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Q4
SELECT
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.stores s
JOIN sales.orders o ON s.store_id = o.store_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_id, s.store_name
ORDER BY total_revenue DESC;


-- Q5
SELECT
    b.brand_name,
    COUNT(p.product_id) AS product_count,
    AVG(p.list_price) AS average_list_price,
    MAX(p.list_price) AS highest_list_price
FROM production.brands b
JOIN production.products p ON b.brand_id = p.brand_id
GROUP BY b.brand_id, b.brand_name
HAVING COUNT(p.product_id) > 5;


-- Q6
SELECT
    MONTH(o.order_date) AS month_number,
    COUNT(DISTINCT o.order_id) AS number_of_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.order_date >= '2017-01-01'
  AND o.order_date < '2018-01-01'
GROUP BY MONTH(o.order_date)
ORDER BY month_number;


-- Q7
SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    p.list_price
FROM production.products p
WHERE p.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p.category_id
);


-- Q8
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count)
    FROM (
        SELECT customer_id, COUNT(*) AS order_count
        FROM sales.orders
        GROUP BY customer_id
    ) customer_orders
);


-- Q9
WITH CustomerSpend AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spend
    FROM sales.customers c
    JOIN sales.orders o ON c.customer_id = o.customer_id
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
RankedCustomers AS (
    SELECT
        *,
        RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
        AVG(total_spend) OVER () AS overall_average_spend
    FROM CustomerSpend
),
LabeledCustomers AS (
    SELECT
        *,
        CASE
            WHEN total_spend > overall_average_spend THEN 'High'
            ELSE 'Regular'
        END AS customer_label
    FROM RankedCustomers
)
SELECT
    customer_id,
    customer_name,
    total_spend,
    spend_rank,
    customer_label
FROM LabeledCustomers
WHERE spend_rank <= 10
ORDER BY spend_rank;


-- Q10
WITH ProductSales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity) AS total_quantity
    FROM production.products p
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category_id
),
RankedProducts AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY category_id
            ORDER BY total_quantity DESC
        ) AS rn
    FROM ProductSales
),
ProductStock AS (
    SELECT
        product_id,
        SUM(quantity) AS total_stock
    FROM production.stocks
    GROUP BY product_id
)
SELECT
    c.category_name,
    rp.product_id,
    rp.product_name,
    rp.total_quantity AS units_sold,
    COALESCE(ps.total_stock, 0) AS current_stock
FROM RankedProducts rp
JOIN production.categories c
    ON rp.category_id = c.category_id
LEFT JOIN ProductStock ps
    ON rp.product_id = ps.product_id
WHERE rp.rn = 1
ORDER BY c.category_name;