-- ASSIGNMENT 7 ---

-- Ex 7.1:

SELECT *,
	ROW_NUMBER() OVER(ORDER BY p.list_price DESC) as row_num,
	ROW_NUMBER() OVER(PARTITION BY p.category_id ORDER BY p.list_price DESC) as cat_row_num
FROM production.products p;

-- Ex 7.2

SELECT
    product_name,
    category_id,
    list_price,
    RANK() OVER (
        PARTITION BY category_id
        ORDER BY list_price DESC
    ) AS rnk,
    DENSE_RANK() OVER (
        PARTITION BY category_id
        ORDER BY list_price DESC
    ) AS dense_rnk
FROM production.products;

-- Ex 7.3

SELECT
    s.store_name,
    MONTH(o.order_date) AS month,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS current_revenue,
    LAG(SUM(oi.quantity * oi.list_price * (1 - oi.discount))) OVER (
        PARTITION BY s.store_id
        ORDER BY MONTH(o.order_date)
    ) AS previous_revenue
FROM sales.stores s
JOIN sales.orders o
    ON s.store_id = o.store_id
JOIN sales.order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    s.store_id,
    s.store_name,
    MONTH(o.order_date);

-- Ex 7.4

SELECT
    product_name,
    list_price,
    NTILE(5) OVER (
        ORDER BY list_price
    ) AS price_band
FROM production.products;

-- Ex 7.5

SELECT
    o.order_id,
    o.order_date,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue,
    SUM(SUM(oi.quantity * oi.list_price * (1 - oi.discount))) OVER (
        ORDER BY o.order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM sales.orders o
JOIN sales.order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.order_date;

-- Ex 7.6

-- FIRST_VALUE() works with the default frame because the first row is always included. LAST_VALUE() requires UNBOUNDED FOLLOWING because the default frame ends at the current row, so it cannot see the rows after the current row.







