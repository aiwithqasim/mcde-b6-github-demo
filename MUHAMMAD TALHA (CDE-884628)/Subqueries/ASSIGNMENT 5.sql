-- Assignment: Subqueries 
-- Student:    Muhammad Talha
-- Saylani ID: [CDE-884628]
-------------------------------------------------
-- TASK 1: Customers with more than 3 orders
-------------------------------------------------
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 1;

-------------------------------------------------
-- TASK 2: Products more expensive than average price
-------------------------------------------------
SELECT product_id, product_name, list_price
FROM production.products
WHERE list_price > (
    SELECT AVG(list_price) FROM production.products
);

-------------------------------------------------
-- TASK 3: Orders containing the most expensive product
-------------------------------------------------

SELECT o.order_id, oi.product_id, oi.quantity
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE oi.product_id = (
    SELECT TOP 1 product_id
    FROM production.products
    ORDER BY list_price DESC
);


-------------------------------------------------
-- TASK 4: Customers who never placed an order
-------------------------------------------------

SELECT c.customer_id, c.first_name, c.last_name, c.city, c.state, c.email
FROM sales.customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
);



-------------------------------------------------
-- TASK 5: Stores with staff earning above average salary
-------------------------------------------------

SELECT store_id, store_name
FROM sales.stores
WHERE store_id IN (
    SELECT store_id
    FROM sales.staffs
    GROUP BY store_id
    HAVING COUNT(staff_id) > (
        SELECT AVG(staff_count)
        FROM (
            SELECT COUNT(staff_id) AS staff_count
            FROM sales.staffs
            GROUP BY store_id
        ) AS sub
    )
);

-------------------------------------------------
-- TASK 6: Products in categories with more than 50 products
-------------------------------------------------
SELECT product_name, category_id
FROM production.products
WHERE category_id IN (
    SELECT category_id
    FROM production.products
    GROUP BY category_id
    HAVING COUNT(product_id) > 50
);

-------------------------------------------------
-- TASK 7: Customers who ordered Trek products
-------------------------------------------------
SELECT first_name, last_name
FROM sales.customers
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE oi.product_id IN (
        SELECT product_id FROM production.products WHERE product_name LIKE '%Trek%'
    )
);

-------------------------------------------------
-- TASK 8: Products cheaper than the cheapest product in category 3
-------------------------------------------------
SELECT product_name, list_price
FROM production.products
WHERE list_price < (
    SELECT MIN(list_price) FROM production.products WHERE category_id = 3
);

-------------------------------------------------
-- TASK 9: Orders placed by staff from store 1
-------------------------------------------------
SELECT order_id, customer_id
FROM sales.orders
WHERE staff_id IN (
    SELECT staff_id FROM sales.staffs WHERE store_id = 1
);

-------------------------------------------------
-- TASK 10: Customers living in cities with more than 5 customers
-------------------------------------------------
SELECT first_name, last_name, city
FROM sales.customers
WHERE city IN (
    SELECT city
    FROM sales.customers
    GROUP BY city
    HAVING COUNT(customer_id) > 5
);

-------------------------------------------------
-- TASK 11: Products with price higher than all products in category 2
-------------------------------------------------
SELECT product_name, list_price
FROM production.products
WHERE list_price > ALL (
    SELECT list_price FROM production.products WHERE category_id = 2
);

-------------------------------------------------
-- TASK 12: Orders shipped later than average shipped_date
-------------------------------------------------

SELECT order_id, customer_id, order_date, shipped_date
FROM sales.orders
WHERE shipped_date > (
    SELECT DATEADD(
        DAY,
        AVG(DATEDIFF(DAY, '1900-01-01', shipped_date)),
        '1900-01-01'
    )
    FROM sales.orders
    WHERE shipped_date IS NOT NULL
);




-------------------------------------------------
-- TASK 13: Customers who ordered the same product more than once
-------------------------------------------------
SELECT DISTINCT o.customer_id
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id, oi.product_id
HAVING COUNT(oi.order_id) > 1;


-------------------------------------------------
-- TASK 14: Products belonging to brands with fewer than 10 products
-------------------------------------------------
SELECT product_name, brand_id
FROM production.products
WHERE brand_id IN (
    SELECT brand_id
    FROM production.products
    GROUP BY brand_id
    HAVING COUNT(product_id) < 10
);

-------------------------------------------------
-- TASK 15: Customers who ordered in 2018 but not in 2019
-------------------------------------------------
SELECT first_name, last_name
FROM sales.customers
WHERE customer_id IN (
    SELECT customer_id FROM sales.orders WHERE YEAR(order_date) = 2018
)
AND customer_id NOT IN (
    SELECT customer_id FROM sales.orders WHERE YEAR(order_date) = 2019
);

-------------------------------------------------
-- TASK 16: Products with price equal to maximum price in their category
-------------------------------------------------
SELECT product_name, category_id, list_price
FROM production.products p
WHERE list_price = (
    SELECT MAX(list_price)
    FROM production.products
    WHERE category_id = p.category_id
);

-------------------------------------------------
-- TASK 17: Staff working in stores located in the same city as customers
-------------------------------------------------
SELECT staff_id, first_name, last_name
FROM sales.staffs
WHERE store_id IN (
    SELECT store_id
    FROM sales.stores
    WHERE city IN (SELECT DISTINCT city FROM sales.customers)
);

-------------------------------------------------
-- TASK 18: Orders with total amount greater than average order amount
-------------------------------------------------
SELECT order_id, SUM(list_price * quantity) AS total_amount
FROM sales.order_items oi
JOIN production.products p ON oi.product_id = p.product_id
GROUP BY order_id
HAVING SUM(list_price * quantity) > (
    SELECT AVG(total_amount)
    FROM (
        SELECT SUM(list_price * quantity) AS total_amount
        FROM sales.order_items oi2
        JOIN production.products p2 ON oi2.product_id = p2.product_id
        GROUP BY order_id
    ) AS sub
);

-------------------------------------------------
-- TASK 19: Customers who ordered products from more than 3 categories
-------------------------------------------------
SELECT customer_id
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.orders o2
    JOIN sales.order_items oi2 ON o2.order_id = oi2.order_id
    JOIN production.products p ON oi2.product_id = p.product_id
    GROUP BY customer_id
    HAVING COUNT(DISTINCT category_id) > 3
);

-------------------------------------------------
-- TASK 20: Products not ordered by any customer
-------------------------------------------------
SELECT product_id, product_name
FROM production.products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id FROM sales.order_items
);
