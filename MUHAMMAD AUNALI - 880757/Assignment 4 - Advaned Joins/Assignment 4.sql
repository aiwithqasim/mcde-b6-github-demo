use bikestores;

-- self join
-- task 41

select 
e.first_name + ' ' + e.last_name as employee,
e.staff_id,
e.manager_id,
m.first_name + ' ' + m.last_name as manager 
from sales.staffs as e left join sales.staffs as m
on e.manager_id = m.staff_id order by e.manager_id asc;

-- task 42
SELECT 
    b.brand_name,
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    p1.list_price
FROM production.products AS p1
INNER JOIN production.products AS p2 
    ON p1.brand_id = p2.brand_id 
   AND p1.list_price = p2.list_price 
   AND p1.product_id < p2.product_id
INNER JOIN production.brands AS b 
    ON p1.brand_id = b.brand_id
ORDER BY b.brand_name, p1.list_price DESC;
-- Cross Join
--task 45

SELECT 
    b.brand_name, 
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c
ORDER BY b.brand_name, c.category_name;

 --task 46
 SELECT 
    b.brand_name, 
    c.category_name,
    p.product_id
FROM production.brands AS b
CROSS JOIN production.categories AS c
LEFT JOIN production.products AS p 
    ON b.brand_id = p.brand_id 
   AND c.category_id = p.category_id
WHERE p.product_id IS NULL
ORDER BY b.brand_name, c.category_name, p.product_id;

--task 49
SELECT 
    b.brand_name,
    p.product_name,
    p.list_price
FROM production.products AS p
RIGHT JOIN production.brands AS b 
    ON p.brand_id = b.brand_id;


--task 50
SELECT 
    s.store_id,
    s.store_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM sales.orders AS o
RIGHT JOIN sales.stores AS s 
    ON o.store_id = s.store_id
ORDER BY s.store_id, o.order_id;

--task 53
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM sales.customers AS c
LEFT JOIN sales.orders AS o 
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--task 54
SELECT 
    p.product_id,
    p.product_name,
    p.list_price
FROM production.products AS p
LEFT JOIN production.stocks AS s 
    ON p.product_id = s.product_id
WHERE s.store_id IS NULL;

--task 56
SELECT 
    p.product_id,
    p.product_name,
    p.list_price
FROM production.products AS p
LEFT JOIN sales.order_items AS oi 
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

--task 59
SELECT 
    c.category_id,
    c.category_name
FROM production.categories AS c
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) AS expensive_categories 
    ON c.category_id = expensive_categories.category_id
WHERE expensive_categories.category_id IS NULL;


--task 60
SELECT DISTINCT
    c.customer_id,
    c.first_name + ' ' + c.last_name as customer_name
 FROM sales.customers AS c
INNER JOIN sales.orders AS o 
    ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT DISTINCT o.customer_id
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi 
        ON o.order_id = oi.order_id
    INNER JOIN production.products AS p 
        ON oi.product_id = p.product_id
    INNER JOIN production.brands AS b 
        ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) AS trek_buyers 
    ON c.customer_id = trek_buyers.customer_id
WHERE trek_buyers.customer_id IS NULL;