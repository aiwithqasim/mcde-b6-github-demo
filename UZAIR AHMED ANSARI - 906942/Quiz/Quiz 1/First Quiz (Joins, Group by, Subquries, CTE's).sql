								--- Class Assignment ---
										--JOIINS--

--1. List every order with the customer's full name, store name, and the full name of the staff  member who handled it.
SELECT
	c.first_name+ ' ' + c.last_name AS customer_full_name,
	store_name,
	s.first_name + ' ' + s.last_name AS staff_member,
	order_id
FROM sales.orders AS o
INNER JOIN sales.customers AS c
	ON c.customer_id = o.customer_id
INNER JOIN sales.stores AS st
	ON st.store_id = o.store_id
INNER JOIN sales.staffs AS s
	ON s.staff_id = o.staff_id

--2.Show each product with its brand name and category name. Include products even if they have no brand or category assigned?
SELECT
	p.product_id,
	p.product_name,
	b.brand_name,
	c.category_name
FROM production.products AS p
INNER JOIN production.brands AS b
	ON p.brand_id = b.brand_id
INNER JOIN production.categories AS c
	ON c.category_id = p.category_id

--3. Find all customers who have never placed an order. Return their name, city, and email?
SELECT
	first_name + ' ' + last_name AS customer_name,
	city,
	email
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
	ON o.customer_id = c.customer_id

										-- GROUP BY --
--4. Calculate total revenue per store. Revenue = quantity * list_price * (1 - discount). Sort from highest to lowest?
SELECT
	s.store_id,
	s.store_name,
	SUM(quantity * list_price * (1 - discount)) AS total_revenue
FROM sales.stores AS s
INNER JOIN sales.orders AS o
	ON o.store_id = s.store_id
INNER JOIN sales.order_items AS oi
	ON oi.order_id = o.order_id
GROUP BY 
	s.store_id,
	s.store_name
ORDER BY total_revenue DESC;

--For each brand, show the number of products, the average list price, and the highest list price. Only include brands with more than 5 products?
SELECT 
	COUNT(p.product_id) AS number_of_products,
	AVG(p.list_price) AS avg_list_price,
	MAX(p.list_price) AS highest_list_price,
	b.brand_id,
	b.brand_name
FROM production.brands AS b
INNER JOIN production.products AS p
	ON p.brand_id = b.brand_id
GROUP BY
	b.brand_id,
	b.brand_name
HAVING 
	COUNT(p.product_id) > 5

--6. Show the number of orders and total revenue per month for the year 2017, ordered chronologically?
SELECT
	MONTH(o.order_date) AS order_month,
	COUNT(DISTINCT o.order_id) AS number_of_orders,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
	ON oi.order_id = o.order_id
WHERE YEAR(order_date) = 2017
GROUP BY MONTH(o.order_date)
ORDER BY order_month;

										-- Subqueries -- 
--7. Find all products priced above the average list price of their own category. Hint: Use a correlated subquery?
SELECT
	o.product_id,
	o.product_name,
	o.list_price,
	o.category_id
FROM production.products AS o
WHERE list_price > (
	SELECT
	AVG(list_price)
	FROM production.products AS i
	WHERE i.category_id = o.category_id
);

--8. List the customers who have placed more orders than the average number of orders per customer?
SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS full_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers c
INNER JOIN sales.orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count * 1.0)
    FROM (
        SELECT
            customer_id,
            COUNT(*) AS order_count
        FROM sales.orders
        GROUP BY customer_id
    ) AS customer_orders
)
ORDER BY
    order_count DESC;

                                                        -- CTE's --

--9. Using a CTE, calculate each customer's total spend, then return the top 10 customers with their spend and rank. Add a second CTE that labels 
--each customer as "High" (above the overall average spend) or "Regular".

WITH customer_spend AS (
    SELECT
        c.customer_id,
        c.first_name + ' ' + c.last_name AS full_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spend
    FROM sales.customers c
    INNER JOIN sales.orders o
        ON c.customer_id = o.customer_id
    INNER JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
),

customer_labeled AS (
    SELECT
        customer_id,
        full_name,
        total_spend,
        CASE
            WHEN total_spend > AVG(total_spend) OVER ()
                THEN 'High'
            ELSE 'Regular'
        END AS customer_type
    FROM customer_spend
),

ranked_customers AS (
    SELECT
        customer_id,
        full_name,
        total_spend,
        customer_type,
        RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
    FROM customer_labeled
)

SELECT TOP 10
    customer_id,
    full_name,
    total_spend,
    customer_type,
    spend_rank
FROM ranked_customers
ORDER BY spend_rank;

--10. Using CTEs, find the best-selling product (by quantity) in each category, and show how much of that product's stock is currently available 
--across all stores. Hint: Use ROW_NUMBER() or RANK() partitioned by category, then join to production.stocks.

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        c.category_name,
        SUM(oi.quantity) AS total_quantity_sold
    FROM production.products p
    INNER JOIN production.categories c
        ON p.category_id = c.category_id
    INNER JOIN sales.order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category_id,
        c.category_name
),

ranked_products AS (
    SELECT
        product_id,
        product_name,
        category_id,
        category_name,
        total_quantity_sold,
        ROW_NUMBER() OVER (
            PARTITION BY category_id
            ORDER BY total_quantity_sold DESC
        ) AS product_rank
    FROM product_sales
),

best_products AS (
    SELECT
        product_id,
        product_name,
        category_id,
        category_name,
        total_quantity_sold
    FROM ranked_products
    WHERE product_rank = 1
),

stock_summary AS (
    SELECT
        product_id,
        SUM(quantity) AS total_stock
    FROM production.stocks
    GROUP BY product_id
)

SELECT
    bp.category_name,
    bp.product_id,
    bp.product_name,
    bp.total_quantity_sold,
    ISNULL(ss.total_stock, 0) AS total_stock_available
FROM best_products bp
LEFT JOIN stock_summary ss
    ON bp.product_id = ss.product_id
ORDER BY
    bp.category_name;


                                            -- Bonus Challenges -- 

--Rewrite Q8 using a CTE instead of a subquery and compare readability?
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
average_orders AS (
    SELECT
        AVG(order_count * 1.0) AS avg_order_count
    FROM customer_orders
)
SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS full_name,
    co.order_count
FROM customer_orders co
INNER JOIN sales.customers c
    ON co.customer_id = c.customer_id
CROSS JOIN average_orders ao
WHERE co.order_count > ao.avg_order_count
ORDER BY co.order_count DESC;

--For Q4, add a column showing each store's percentage share of total company revenue?
WITH store_revenue AS (
    SELECT
        s.store_id,
        s.store_name,
        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        ) AS total_revenue
    FROM sales.stores s
    INNER JOIN sales.orders o
        ON s.store_id = o.store_id
    INNER JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        s.store_id,
        s.store_name
)
SELECT
    store_id,
    store_name,
    total_revenue,
    ROUND(
        total_revenue * 100.0
        / SUM(total_revenue) OVER (),
        2
    ) AS revenue_percentage
FROM store_revenue
ORDER BY
    total_revenue DESC;







