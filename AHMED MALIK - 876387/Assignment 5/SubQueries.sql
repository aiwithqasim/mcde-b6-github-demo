

--- TASK 5.1 IN COMPLETED!! ---

SELECT
    p1.product_name,
    p1.list_price,
    p1.brand_id
FROM production.products p1
WHERE p1.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.brand_id = p1.brand_id
);


-----------------------------------------------

--- TASK 5.2 IS COMPLETED!! ---

SELECT
    order_id,
    customer_id,
    order_date
FROM sales.orders
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE state IN ('New York', 'California')
);

-------------------------------------------------

--- TASK 5.3 IS COMPLETED!! ----

SELECT customer_id
FROM sales.customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM sales.orders
);

---------------------------------------------------

--- TASK 5.4 IS COMPLETED!! ---

SELECT
    AVG(item_count) AS average_items_per_order
FROM (
    SELECT
        order_id,
        COUNT(*) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_item_counts;

--------------------------------------------------


--- TASK 5.5 IS COMPLETED!! ---

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city
FROM sales.customers c
WHERE EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
      AND YEAR(o.order_date) = 2017
);


-------------------------------------------------------

--- TASK 5.6 IS COMPLETED!! ---

SELECT
    c.customer_id,
    c.first_name,
    o.order_id,
    o.order_date
FROM sales.customers c
CROSS APPLY (
    SELECT TOP 3
        order_id,
        order_date
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
    ORDER BY o.order_date DESC
) AS o
ORDER BY
    c.customer_id,
    o.order_date DESC;

------------------------------------------------

--- TASK 5.7 IS COMPLETED!! ---

 -- ANY PART ---

 SELECT
    product_name,
    list_price
FROM production.products
WHERE list_price > ANY (
    SELECT list_price
    FROM production.products
    WHERE brand_id = 1
);


----------------------------------------------

-- IN PART --

SELECT
    order_id,
    customer_id,
    order_date
FROM sales.orders
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE state IN ('New York', 'California')
);

--------------------------------------------------------------

-- ALL PART --

SELECT
    product_name,
    list_price
FROM production.products
WHERE list_price > ALL (
    SELECT list_price
    FROM production.products
    WHERE brand_id = 1
);