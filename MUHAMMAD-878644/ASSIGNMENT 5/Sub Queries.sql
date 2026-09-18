USE bikeStore

------ ASSINGMENT 05 -----
 ------ SUB QUERIES ----

-------  5.1: Products priced above their brand's average

SELECT p.product_id, p.product_name, p.brand_id, p.list_price
FROM production.products AS p
WHERE p.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products AS p2
    WHERE p2.brand_id = p.brand_id
);

------ 5.2: Orders from New York or California customers

SELECT o.order_id, o.customer_id, o.order_date
FROM sales.orders AS o
WHERE o.customer_id IN (
    SELECT c.customer_id
    FROM sales.customers AS c
    WHERE c.state IN ('NY', 'CA')
);

------ 5.3: Fixing the NULL trap


SELECT c.customer_id
FROM sales.customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
);

------- 5.4: Average items per order with a derived table

SELECT AVG(t.item_count * 1.0) AS avg_items_per_order
FROM (
    SELECT order_id, COUNT(*) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS t;


-----------  5.5
-- EXISTS version
SELECT c.customer_id, c.first_name, c.last_name, c.city
FROM sales.customers AS c
WHERE EXISTS (
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
      AND YEAR(o.order_date) = 2017
)
ORDER BY c.first_name, c.last_name;

-- IN version
SELECT c.customer_id, c.first_name, c.last_name, c.city
FROM sales.customers AS c
WHERE c.customer_id IN (
    SELECT o.customer_id
    FROM sales.orders AS o
    WHERE YEAR(o.order_date) = 2017
)
ORDER BY c.first_name, c.last_name

------ 5.6: Top 3 most recent orders per customer with CROSS APPLY

SELECT c.customer_id, c.first_name, o.order_id, o.order_date
FROM sales.customers AS c
CROSS APPLY (
    SELECT TOP (3) order_id, order_date
    FROM sales.orders
    WHERE customer_id = c.customer_id
    ORDER BY order_date DESC, order_id DESC
) AS o
ORDER BY c.customer_id, o.order_date DESC;

------ 5.7
SELECT p.product_name, p.list_price
FROM production.products AS p
WHERE p.list_price > ALL (
    SELECT p2.list_price
    FROM production.products AS p2
    JOIN production.brands AS b ON b.brand_id = p2.brand_id
    WHERE b.brand_name = 'Electra'
      AND p2.list_price IS NOT NULL
);