------------------SQL PAPER-------------------------

------JOINS---------------------

TASK NO 1)
SELECT
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    s.store_name,
    st.first_name + ' ' + st.last_name AS staff_name
FROM sales.orders AS o
INNER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN sales.stores AS s
    ON o.store_id = s.store_id
INNER JOIN sales.staffs AS st
    ON o.staff_id = st.staff_id;
    

TASK NO 2)
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

    TASK NO 3)
    SELECT
    c.first_name + ' ' + c.last_name AS customer_name,
    c.city,
    c.email
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
----------------GROUP BY-----------------------

TASK NO 4)
SELECT
    s.store_name,
    SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) AS total_revenue
FROM sales.stores AS s
INNER JOIN sales.orders AS o
    ON s.store_id = o.store_id
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    s.store_name
ORDER BY
    total_revenue DESC;

  TASK NO 5)
  SELECT
    b.brand_name,
    COUNT(p.product_id) AS product_count,
    AVG(p.list_price) AS average_list_price,
    MAX(p.list_price) AS highest_list_price
FROM production.brands AS b
INNER JOIN production.products AS p
    ON b.brand_id = p.brand_id
GROUP BY
    b.brand_name
HAVING COUNT(p.product_id) > 5;


TASK NO 6)  
SELECT
    MONTH(o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) AS total_revenue
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY
    MONTH(o.order_date)
ORDER BY
    order_month;

--------------SUB SQUERIES------------------

    TASK NO 7)
    SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    p.list_price
FROM production.products AS p
WHERE p.list_price >
(
    SELECT AVG(p2.list_price)
    FROM production.products AS p2
    WHERE p2.category_id = p.category_id
);

TASK NO 8)
SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(o.order_id) >
(
    SELECT AVG(order_count)
    FROM
    (
        SELECT
            customer_id,
            COUNT(*) AS order_count
        FROM sales.orders
        GROUP BY customer_id
    ) AS customer_orders
);

----------------------CTE---------------------
TASK NO 9) 
WITH customer_spend AS
(
    SELECT
        c.customer_id,
        c.first_name + ' ' + c.last_name AS customer_name,
        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        ) AS total_spend
    FROM sales.customers AS c
    INNER JOIN sales.orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
),

customer_labels AS
(
    SELECT
        customer_id,
        customer_name,
        total_spend,
        CASE
            WHEN total_spend >
            (
                SELECT AVG(total_spend)
                FROM customer_spend
            )
            THEN 'High'
            ELSE 'Regular'
        END AS customer_type
    FROM customer_spend
)

SELECT TOP 10
    customer_id,
    customer_name,
    total_spend,
    RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
    customer_type
FROM customer_labels
ORDER BY total_spend DESC;

TASK NO 10)
WITH product_sales AS
(
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity) AS total_quantity
    FROM production.products AS p
    INNER JOIN sales.order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category_id
),

ranked_products AS
(
    SELECT
        product_id,
        product_name,
        category_id,
        total_quantity,
        RANK() OVER
        (
            PARTITION BY category_id
            ORDER BY total_quantity DESC
        ) AS product_rank
    FROM product_sales
),

best_products AS
(
    SELECT
        product_id,
        product_name,
        category_id,
        total_quantity
    FROM ranked_products
    WHERE product_rank = 1
),

stock_available AS
(
    SELECT
        bp.product_id,
        SUM(s.quantity) AS available_stock
    FROM best_products AS bp
    INNER JOIN production.stocks AS s
        ON bp.product_id = s.product_id
    GROUP BY
        bp.product_id
)

SELECT
    c.category_name,
    bp.product_name,
    bp.total_quantity AS quantity_sold,
    sa.available_stock
FROM best_products AS bp
INNER JOIN production.categories AS c
    ON bp.category_id = c.category_id
INNER JOIN stock_available AS sa
    ON bp.product_id = sa.product_id
ORDER BY
    c.category_name;
