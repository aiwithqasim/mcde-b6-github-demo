
			---Section 5 — Subqueries


			-- TASK 29


SELECT * FROM 
production.products
WHERE list_price > (SELECT AVG(list_price)FROM production.products);


		-- TASK 30


SELECT * FROM sales.customers
WHERE customer_id NOT IN ( SELECT DISTINCT  customer_id FROM sales.orders); 

       	
        -- TASK 31


SELECT category_name
FROM production.categories
WHERE category_id IN (
SELECT category_id
FROM production.products
WHERE list_price = (SELECT MAX(list_price) FROM production.products)
);



		--task 32


SELECT first_name, last_name
FROM sales.staffs
WHERE store_id = (
    SELECT store_id
    FROM (
        SELECT o.store_id, SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_revenue
        FROM sales.orders o
        JOIN sales.order_items i ON o.order_id = i.order_id
        GROUP BY o.store_id
    ) AS store_sales
    WHERE total_revenue = (
        SELECT MAX(total_revenue)
        FROM (
            SELECT SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_revenue
            FROM sales.orders o
            JOIN sales.order_items i ON o.order_id = i.order_id
            GROUP BY o.store_id
        ) AS max_sales
    )
);

            --task 33


SELECT order_id, SUM(quantity * list_price * (1 - discount)) AS total_bill
FROM sales.order_items
GROUP BY order_id
HAVING SUM(quantity * list_price * (1 - discount)) > 5000;

            --Task34

            SELECT p.*
FROM production.products p
WHERE NOT EXISTS (
    SELECT 1 
    FROM sales.order_items i 
    WHERE i.product_id = p.product_id
);


        -- task35

        SELECT *
FROM sales.customers
WHERE customer_id = (
    SELECT TOP 1 o.customer_id
    FROM sales.orders o
    JOIN sales.order_items i ON o.order_id = i.order_id
    GROUP BY o.customer_id
    ORDER BY SUM(i.quantity * i.list_price * (1 - i.discount)) DESC
);