--1

SELECT
    product_id,
    product_name,
    list_price,
    AVG(list_price) OVER () AS overall_avg_price
FROM production.products;

--2
SELECT
    product_id,
    product_name,
    brand_id,
    list_price,
    ROW_NUMBER() OVER (
        PARTITION BY brand_id
        ORDER BY list_price DESC
    ) AS row_num
FROM production.products;

--3
SELECT
    product_id,
    product_name,
    list_price,
    RANK() OVER (
        ORDER BY list_price DESC
    ) AS rank_num,
    DENSE_RANK() OVER (
        ORDER BY list_price DESC
    ) AS dense_rank_num
FROM production.products;

--4
SELECT
    product_id,
    product_name,
    list_price,
    NTILE(4) OVER (
        ORDER BY list_price DESC
    ) AS price_bucket
FROM production.products;

--5
SELECT
    order_id,
    order_date,
    customer_id,
    LAG(order_date) OVER (
        ORDER BY order_date
    ) AS previous_order_date,
    LEAD(order_date) OVER (
        ORDER BY order_date
    ) AS next_order_date
FROM sales.orders;

--6
SELECT
    product_id,
    product_name,
    brand_id,
    list_price,
    FIRST_VALUE(list_price) OVER (
        PARTITION BY brand_id
        ORDER BY list_price DESC
    ) AS highest_price,
    LAST_VALUE(list_price) OVER (
        PARTITION BY brand_id
        ORDER BY list_price DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS lowest_price
FROM production.products;

--7
SELECT
    order_id,
    order_date,
    customer_id,
    SUM(order_id) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS running_total
FROM sales.orders;

--8
SELECT
    order_id,
    order_date,
    customer_id,
    SUM(order_id) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM sales.orders;

--9
SELECT
    o.order_id,
    o.store_id,
    o.order_date,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS order_revenue,

    RANK() OVER (
        PARTITION BY o.store_id
        ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount)) DESC
    ) AS store_rank,

    SUM(SUM(oi.quantity * oi.list_price * (1 - oi.discount))) OVER (
        PARTITION BY o.store_id
        ORDER BY o.order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_revenue,

    LAG(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount))
    ) OVER (
        PARTITION BY o.store_id
        ORDER BY o.order_date
    ) AS previous_order_revenue

FROM sales.orders o
INNER JOIN sales.order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.store_id,
    o.order_date;