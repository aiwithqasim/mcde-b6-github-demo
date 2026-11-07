--Assignment - 05 Sub Queries 


--Question 5.1

SELECT
    product_id,
    product_name,
    brand_id,
    list_price
FROM production.products AS p
WHERE list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products AS p2
    WHERE p2.brand_id = p.brand_id
);


=================================

--Question 5.2

SELECT *
FROM sales.orders
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE state IN ('NY', 'CA')
);


=================================

--Question 5.3

SELECT c.customer_id
FROM sales.customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
);


===================================

--Question 5.4

SELECT AVG(item_count * 1.0) AS avg_items_per_order
FROM (
    SELECT order_id, COUNT(*) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_summary;

===================================

--Question 5.5

SELECT *
FROM sales.customers
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.orders
);

===================================

--Question 5.6

SELECT
    c.customer_id,
    c.first_name,
    o.order_id,
    o.order_date
FROM sales.customers AS c
CROSS APPLY (
    SELECT TOP 3
        order_id,
        order_date
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
    ORDER BY order_date DESC
) AS o;

====================================

--Question 5.7

   `ANY` ko tab use karte hain jab humein check karna ho ke condition subquery ki kisi bhi ek value ke liye true hai. `= ANY` functionally `IN` jaisa hi hota hai, isliye simple cases mein `IN` zyada easy aur readable hota hai.

   `ALL` tab use karte hain jab condition subquery ki har value ke liye true honi chahiye. For example: “Kaun se products apne brand ke tamam products se mehngay hain?” Yeh question `ALL` ke saath naturally express hota hai, jabke `IN` ke saath cleanly express nahi hota.
