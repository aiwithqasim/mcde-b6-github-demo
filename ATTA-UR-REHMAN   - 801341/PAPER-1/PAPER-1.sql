-- task 1
SELECT
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    s.store_name,
    CONCAT(st.first_name, ' ', st.last_name) AS staff_name
FROM sales.orders AS o
JOIN sales.customers AS c
    ON o.customer_id = c.customer_id
JOIN sales.stores AS s
    ON o.store_id = s.store_id
JOIN sales.staffs AS st
    ON o.staff_id = st.staff_id;


-- task 2
SELECT
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products AS p
LEFT JOIN production.brands AS b
    ON p.brand_id = b.brand_id
LEFT JOIN production.categories AS c
    ON p.category_id = c.category_id;


-- task 3
SELECT
    c.first_name,
    c.last_name,
    c.city,
    c.email
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- task 4
SELECT
    s.store_id,
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.stores AS s
JOIN sales.orders AS o
    ON s.store_id = o.store_id
JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    s.store_id,
    s.store_name
ORDER BY
    total_revenue DESC;


-- task 5
SELECT
    b.brand_id,
    b.brand_name,
    COUNT(p.product_id) AS product_count,
    AVG(p.list_price) AS average_list_price,
    MAX(p.list_price) AS highest_list_price
FROM production.brands AS b
JOIN production.products AS p
    ON b.brand_id = p.brand_id
GROUP BY
    b.brand_id,
    b.brand_name
HAVING COUNT(p.product_id) > 5;


-- task 6
SELECT
    MONTH(o.order_date) AS month_number,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders AS o
JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY
    MONTH(o.order_date)
ORDER BY
    month_number;


-- task 7
SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    p.list_price
FROM production.products AS p
WHERE p.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products AS p2
    WHERE p2.category_id = p.category_id
);


-- task 8
SELECT
    o.customer_id,
    COUNT(*) AS order_count
FROM sales.orders AS o
GROUP BY
    o.customer_id
HAVING COUNT(*) > (
    SELECT AVG(order_count * 1.0)
    FROM (
        SELECT
            customer_id,
            COUNT(*) AS order_count
        FROM sales.orders
        GROUP BY customer_id
    ) AS customer_orders
);


-- task 9
WITH CustomerSpend AS (
    SELECT
        o.customer_id,
        SUM(
            oi.quantity *
            oi.list_price *
            (1 - oi.discount)
        ) AS total_spend
    FROM sales.orders AS o
    JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id
),
CustomerLabel AS (
    SELECT
        customer_id,
        total_spend,
        CASE
            WHEN total_spend > (
                SELECT AVG(total_spend)
                FROM CustomerSpend
            )
            THEN 'High'
            ELSE 'Regular'
        END AS customer_label
    FROM CustomerSpend
)
SELECT TOP 10
    customer_id,
    total_spend,
    customer_label,
    RANK() OVER (
        ORDER BY total_spend DESC
    ) AS customer_rank
FROM CustomerLabel
ORDER BY
    total_spend DESC;


-- task 10
WITH ProductSales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity) AS quantity_sold
    FROM production.products AS p
    JOIN sales.order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category_id
),
RankedProducts AS (
    SELECT
        product_id,
        product_name,
        category_id,
        quantity_sold,
        ROW_NUMBER() OVER (
            PARTITION BY category_id
            ORDER BY quantity_sold DESC
        ) AS product_rank
    FROM ProductSales
),
ProductStock AS (
    SELECT
        product_id,
        SUM(quantity) AS total_stock
    FROM production.stocks
    GROUP BY
        product_id
)
SELECT
    c.category_name,
    rp.product_id,
    rp.product_name,
    rp.quantity_sold,
    COALESCE(ps.total_stock, 0) AS total_stock
FROM RankedProducts AS rp
JOIN production.categories AS c
    ON rp.category_id = c.category_id
LEFT JOIN ProductStock AS ps
    ON rp.product_id = ps.product_id
WHERE rp.product_rank = 1
ORDER BY
    c.category_name;