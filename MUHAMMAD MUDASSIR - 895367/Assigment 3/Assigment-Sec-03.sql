use bikestores ;

--section 3

--task 12
SELECT
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products AS p
INNER JOIN production.brands AS b
    ON p.brand_id = b.brand_id
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id;

--task 13

SELECT
    customers.first_name + ' ' + customers.last_name AS customer_name,
    orders.order_date,
    orders.order_status
FROM sales.orders
JOIN sales.customers
    ON orders.customer_id = customers.customer_id;

--task 14
SELECT
    products.product_name,
    order_items.quantity,
    order_items.list_price,
    order_items.discount
FROM sales.order_items
JOIN production.products
    ON order_items.product_id = products.product_id;


--task 15

SELECT
    staffs.first_name + ' ' + staffs.last_name AS staff_name,
    stores.store_name
FROM sales.staffs
JOIN sales.stores
    ON staffs.store_id = stores.store_id;

--task 16
SELECT
    stores.store_name,
    products.product_name,
    stocks.quantity
FROM production.stocks
JOIN sales.stores
    ON stocks.store_id = stores.store_id
JOIN production.products
    ON stocks.product_id = products.product_id
WHERE stocks.quantity > 0;

--task 17
SELECT
    stores.store_name,
    products.product_name,
    stocks.quantity
FROM production.stocks
JOIN sales.stores
    ON stocks.store_id = stores.store_id
JOIN production.products
    ON stocks.product_id = products.product_id
WHERE stocks.quantity > 0;

--task 18

SELECT
    customers.first_name + ' ' + customers.last_name AS customer_name,
    orders.order_date
FROM sales.customers
JOIN sales.orders
    ON customers.customer_id = orders.customer_id;

--task 19
SELECT
    customers.first_name + ' ' + customers.last_name AS customer_name,
    orders.order_date
FROM sales.customers
JOIN sales.orders
    ON customers.customer_id = orders.customer_id;