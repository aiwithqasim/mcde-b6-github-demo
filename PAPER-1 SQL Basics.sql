
/*List every order with the customer's full name, 
store name, and the full name of the staff member who handled it*/
SELECT
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    st.store_name,
    s.first_name + ' ' + s.last_name AS staff_name
FROM sales.orders AS o
INNER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN sales.stores AS st
    ON o.store_id = st.store_id
INNER JOIN sales.staffs AS s
    ON o.staff_id = s.staff_id;

/*)  Show each product with its brand name and category name. 
Include products even if they have no brand or category assigned*/
SELECT
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products AS p
LEFT JOIN production.brands AS b
    ON p.brand_id = b.brand_id
LEFT JOIN production.categories AS c
    ON p.category_id = c.category_id;

/*Find all customers who have never placed an order. Return their name, city, and email*/
SELECT
    c.first_name + ' ' + c.last_name AS full_name,
	c.city,
	c.email
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

/*Calculate total revenue per store. Revenue = quantity * list_price * (1 - discount). Sort from highest to lowest*/
SELECT
    o.store_id,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders AS o
JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY o.store_id
ORDER BY total_revenue DESC;


/* For each brand, show the number of products, the average list price, and the highest list price. 
Only include brands with more than 5 products*/
SELECT
    brand_id,
    COUNT(product_id) AS number_of_products,
    AVG(list_price) AS average_list_price,
    MAX(list_price) AS highest_list_price
FROM production.products
GROUP BY brand_id
HAVING COUNT(product_id) > 5;

/*Show the number of orders and total revenue per month for the year 2017, ordered chronologically.*/
SELECT
    MONTH(o.order_date) AS month,
    COUNT(DISTINCT o.order_id) AS number_of_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders AS o
JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY MONTH(o.order_date)
ORDER BY MONTH(o.order_date);

/*Find all products priced above the average list price of their own category.
Hint: Use a correlated subquery.*/
SELECT
    product_id,
    product_name,
    category_id,
    list_price
FROM production.products AS p
WHERE list_price > (
    SELECT AVG(list_price)
    FROM production.products AS p2
    WHERE p2.category_id = p.category_id
);

/*List the customers who have placed more orders than the average number of orders per customer.*/
SELECT
    customer_id,
    COUNT(order_id) AS order_count
FROM sales.orders
GROUP BY customer_id
HAVING COUNT(order_id) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(order_id) AS order_count
        FROM sales.orders
        GROUP BY customer_id
    ) AS customer_orders
);



--
WITH customer_spend AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spend
    FROM sales.orders AS o
    JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
),
customer_labeled AS (
    SELECT
        customer_id,
        total_spend,
        CASE
            WHEN total_spend > (SELECT AVG(total_spend) FROM customer_spend)
                THEN 'High'
            ELSE 'Regular'
        END AS spend_label
    FROM customer_spend
)
SELECT TOP 10
    customer_id,
    total_spend,
    RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
    spend_label
FROM customer_labeled
ORDER BY total_spend DESC;

--
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity) AS total_quantity
    FROM production.products AS p
    JOIN sales.order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category_id
),
ranked_products AS (
    SELECT
        product_id,
        product_name,
        category_id,
        total_quantity,
        ROW_NUMBER() OVER (
            PARTITION BY category_id
            ORDER BY total_quantity DESC
        ) AS rn
    FROM product_sales
),
product_stock AS (
    SELECT
        product_id,
        SUM(quantity) AS available_stock
    FROM production.stocks
    GROUP BY product_id
)
SELECT
    rp.category_id,
    rp.product_id,
    rp.product_name,
    rp.total_quantity,
    ps.available_stock
FROM ranked_products AS rp
LEFT JOIN product_stock AS ps
    ON rp.product_id = ps.product_id
WHERE rp.rn = 1
ORDER BY rp.category_id;

--
WITH product_details AS (
    SELECT
        p.product_id,
        p.product_name,
        p.brand_id,
        p.category_id
    FROM production.products AS p
)
SELECT
    pd.product_id,
    pd.product_name,
    b.brand_name,
    c.category_name
FROM product_details AS pd
LEFT JOIN production.brands AS b
    ON pd.brand_id = b.brand_id
LEFT JOIN production.categories AS c
    ON pd.category_id = c.category_id;

	--
	WITH store_revenue AS (
    SELECT
        o.store_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.orders AS o
    JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.store_id
)
SELECT
    store_id,
    total_revenue,
    total_revenue * 100.0 / SUM(total_revenue) OVER () AS revenue_percentage
FROM store_revenue
ORDER BY total_revenue DESC;








