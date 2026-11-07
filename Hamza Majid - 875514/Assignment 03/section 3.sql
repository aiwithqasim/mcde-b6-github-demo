SELECT
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products AS p
INNER JOIN production.brands AS b
    ON b.brand_id = p.brand_id
INNER JOIN production.categories AS c
    ON c.category_id = p.category_id;

SELECT
    o.order_id,
    c.first_name,
    c.last_name,
    o.order_date,
    o.order_status
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;

SELECT
    oi.order_id,
    p.product_name,
    oi.quantity,
    oi.list_price,
    oi.discount
FROM production.products AS p
INNER JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id;

SELECT
    s.first_name,
    s.last_name,
    st.store_name
FROM sales.staffs AS s
INNER JOIN sales.stores AS st
    ON st.store_id = s.store_id;

SELECT
    s.first_name,
    s.last_name,
    m.first_name AS manager_first_name,
    m.last_