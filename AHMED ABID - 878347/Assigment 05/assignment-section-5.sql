use bikestores ;

--section 5

--task 29
SELECT
    product_name,
    list_price
FROM production.products
WHERE list_price > (
    SELECT AVG(list_price)
    FROM production.products
);

--task 30
SELECT
    first_name,
    last_name
FROM sales.customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM sales.orders
);


--task 31
SELECT
    product_name,
    list_price,
    category_id
FROM production.products AS p
WHERE list_price = (
    SELECT MAX(list_price)
    FROM production.products
    WHERE category_id = p.category_id
);


-- task 32

SELECT
    staffs.first_name,
    staffs.last_name,
    staffs.store_id
FROM sales.staffs
WHERE store_id = (
    SELECT TOP 1
        orders.store_id
    FROM sales.orders
    JOIN sales.order_items
        ON orders.order_id = order_items.order_id
    GROUP BY orders.store_id
    ORDER BY SUM(order_items.quantity * order_items.list_price * (1 - order_items.discount)) DESC
);

--task 33

SELECT
    order_id,
    total_value
FROM (
    SELECT
        order_id,
        SUM(quantity * list_price * (1 - discount)) AS total_value
    FROM sales.order_items
    GROUP BY order_id
) AS order_totals
WHERE total_value > 5000;

--task 34

SELECT
    product_name
FROM production.products
WHERE product_id NOT IN (
    SELECT product_id
    FROM sales.order_items
);

--task 35

SELECT TOP 1
    customers.first_name,
    customers.last_name,
    SUM(order_items.quantity * order_items.list_price * (1 - order_items.discount)) AS total_spent
FROM sales.customers
JOIN sales.orders
    ON customers.customer_id = orders.customer_id
JOIN sales.order_items
    ON orders.order_id = order_items.order_id
GROUP BY customers.first_name, customers.last_name
ORDER BY total_spent DESC;