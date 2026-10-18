 
 -------------- EXERCISE SUBQUERIES-------
 -----------TASK # 5.1---------------
 SELECT * FROM production.products;
 
SELECT
    p.product_id,
    p.product_name,
    p.brand_id,
    p.list_price
FROM production.products AS p
WHERE p.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products AS p2
    WHERE p2.brand_id = p.brand_id
);


 --------------TASK # 5.2----------------

 SELECT 
order_id,
customer_id,
order_date
FROM sales.orders
WHERE customer_id IN(
SELECT 
customer_id
FROM 
sales.customers
WHERE  state IN ('CA','NY'))



 --------------TASK # 5.3----------------
 SELECT
    c.customer_id
FROM sales.customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
);

 -------------TASK # 5.4-----------------

 SELECT
    o.order_id,
    COUNT(oi.product_id) AS item_count
FROM sales.orders AS o
JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id;

 --------------TASK # 5.5---------------

 SELECT *
FROM sales.customers
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.orders
);


 --------------TASK # 5.6-----------------


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
    FROM sales.orders
    WHERE customer_id = c.customer_id
    ORDER BY order_date DESC
) o;


 -------------TASK # 5.7----------------


----ANY is useful when we want to compare a value against at least one value returned by a subquery,
---especially with operators such as >, <, or >=. IN is clearer for checking whether a value matches any value in a list.

---ALL is useful when a condition must be true for every value returned by a subquery. A natural business question is:
--“Find products that are more expensive than every product in a particular brand.” 
---This is expressed cleanly using > ALL, whereas IN checks equality and does not directly express this universal comparison.




