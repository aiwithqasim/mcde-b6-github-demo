--Section 3 — JOINs

--Task 12: List every product along with its brand name and category name.
--Hint: JOIN production.products with production.brands and production.categories.

SELECT 
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products AS p
INNER JOIN production.brands AS b
    ON p.brand_id = b.brand_id
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id;


--Task 13: List all orders with the customer's full name (first_name + last_name), order date, and order status.

SELECT 
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_date,
    o.order_status
FROM sales.orders AS o
INNER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id;


--Task 14: Show every order item with the product name, quantity, list price, and discount.

SELECT 
    oi.order_id,
    oi.item_id,
    p.product_name,
    oi.quantity,
    oi.list_price,
    oi.discount
FROM sales.order_items AS oi
INNER JOIN production.products AS p
    ON oi.product_id = p.product_id;


--Task 15: List each staff member's full name alongside their store name.

SELECT 
    s.first_name + ' ' + s.last_name AS staff_name,
    st.store_name
FROM sales.staffs AS s
INNER JOIN sales.stores AS st
    ON s.store_id = st.store_id;


--Task 16: List staff members along with their manager's full name.
--Hint: Use a self-join on the sales.staffs table using manager_id.

SELECT 
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id;


--Task 17: Show all stores and the products they have in stock, including the product name and quantity. Only show items where quantity > 0.

SELECT 
    st.store_name,
    p.product_name,
    sk.quantity
FROM production.stocks AS sk
INNER JOIN sales.stores AS st
    ON sk.store_id = st.store_id
INNER JOIN production.products AS p
    ON sk.product_id = p.product_id
WHERE sk.quantity > 0;


--Task 18: List all customers who placed at least one order. Show customer name and order date.
--Hint: An INNER JOIN naturally eliminates non-ordering customers.

SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_date
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;
    
    
--Task 19: List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.
--Hint: Use a LEFT JOIN.

SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;


--Section 4 — GROUP BY & Aggregates


--Task 20: Count how many products exist in each category. Show category name and product count.

SELECT 
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM production.categories AS c
LEFT JOIN production.products AS p
    ON c.category_id = p.category_id
GROUP BY c.category_name;


--Task 21: Find the average list price of products per brand.

SELECT 
    b.brand_name,
    AVG(p.list_price) AS average_list_price
FROM production.brands AS b
INNER JOIN production.products AS p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_name;


--Task 22: For each store, count the total number of orders.

SELECT 
    s.store_name,
    COUNT(o.order_id) AS total_orders
FROM sales.stores AS s
LEFT JOIN sales.orders AS o
    ON s.store_id = o.store_id
GROUP BY s.store_name;


--Task 23: Find the total revenue per order. Revenue = quantity × list_price × (1 - discount).

SELECT 
    oi.order_id,
    SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) AS total_revenue
FROM sales.order_items AS oi
GROUP BY oi.order_id;


--Task 24: Find each customer's total number of orders. Sort by order count descending.

SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY order_count DESC;


--Task 25: Find the brand that has the highest average product price.

SELECT TOP 1
    b.brand_name,
    AVG(p.list_price) AS average_price
FROM production.brands AS b
INNER JOIN production.products AS p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_name
ORDER BY average_price DESC;


--Task 26: List categories that have more than 50 products.
--Hint: Use the HAVING clause to filter grouped results.

SELECT 
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM production.categories AS c
INNER JOIN production.products AS p
    ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) > 50;


--Task 27: For each store, find the total revenue generated across all orders.

SELECT 
    s.store_name,
    SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) AS total_revenue
FROM sales.stores AS s
INNER JOIN sales.orders AS o
    ON s.store_id = o.store_id
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY s.store_name;


--Task 28: Find how many orders each staff member handled, and show only those who handled more than 50 orders.

SELECT 
    s.staff_id,
    s.first_name + ' ' + s.last_name AS staff_name,
    COUNT(o.order_id) AS order_count
FROM sales.staffs AS s
INNER JOIN sales.orders AS o
    ON s.staff_id = o.staff_id
GROUP BY 
    s.staff_id,
    s.first_name,
    s.last_name
HAVING COUNT(o.order_id) > 50;


--Section 5 — Subqueries


--Task 29: Find all products whose list price is above the overall average list price.
--Hint: Use a subquery in the WHERE clause with AVG().

SELECT 
    product_name,
    list_price
FROM production.products
WHERE list_price > (
    SELECT AVG(list_price)
    FROM production.products
);


--Task 30: Find customers who have never placed an order.
--Hint: Use NOT IN or NOT EXISTS with a subquery on sales.orders.

SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name
FROM sales.customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
);


--Task 31: List the most expensive product in each category.
--Hint: Use a correlated subquery or a CTE with ROW_NUMBER().

SELECT 
    p.product_id,
    p.product_name,
    p.category_id,
    p.list_price
FROM production.products AS p
WHERE p.list_price = (
    SELECT MAX(p2.list_price)
    FROM production.products AS p2
    WHERE p2.category_id = p.category_id
);


--Task 32: Find staff members who work in the store that generated the most revenue.

SELECT 
    s.first_name + ' ' + s.last_name AS staff_name,
    s.store_id
FROM sales.staffs AS s
WHERE s.store_id = (
    SELECT TOP 1
        o.store_id
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.store_id
    ORDER BY SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) DESC
);


--Task 33: Find orders where the total order value exceeds 5000.
--Hint: Use a subquery to calculate order totals, then filter in the outer query.

SELECT 
    o.order_id,
    o.order_date,
    o.order_status
FROM sales.orders AS o
WHERE o.order_id IN (
    SELECT oi.order_id
    FROM sales.order_items AS oi
    GROUP BY oi.order_id
    HAVING SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) > 5000
);


--Task 34: List products that have never been ordered by any customer.

SELECT 
    p.product_id,
    p.product_name
FROM production.products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.order_items AS oi
    WHERE oi.product_id = p.product_id
);


--Task 35: Find the customer who has spent the most money overall.

SELECT TOP 1
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) AS total_spent
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC;


--Section 6 — Mixed / Challenge Tasks


--Task 36: For each state, find the total number of customers AND the total revenue generated by those customers.

SELECT 
    c.state,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COALESCE(
        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        ), 0
    ) AS total_revenue
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
LEFT JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY c.state;


--Task 37: Rank all products by price within each category.
--Hint: Use ROW_NUMBER() or RANK() with PARTITION BY category_id.

SELECT 
    product_id,
    product_name,
    category_id,
    list_price,
    RANK() OVER (
        PARTITION BY category_id
        ORDER BY list_price DESC
    ) AS price_rank
FROM production.products;


--Task 38: Find the month-wise order count and total revenue for the year 2017.

SELECT 
    MONTH(o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) AS total_revenue
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY MONTH(o.order_date)
ORDER BY order_month;


--Task 39: List each store's best-selling product (by quantity sold).

WITH ProductSales AS (
    SELECT 
        o.store_id,
        oi.product_id,
        SUM(oi.quantity) AS total_quantity,
        ROW_NUMBER() OVER (
            PARTITION BY o.store_id
            ORDER BY SUM(oi.quantity) DESC
        ) AS rn
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY 
        o.store_id,
        oi.product_id
)
SELECT 
    s.store_name,
    p.product_name,
    ps.total_quantity
FROM ProductSales AS ps
INNER JOIN sales.stores AS s
    ON ps.store_id = s.store_id
INNER JOIN production.products AS p
    ON ps.product_id = p.product_id
WHERE ps.rn = 1;


--Task 40: Write a query to produce a report showing: store name, staff name, number of orders, and total revenue — grouped by store and staff member, sorted by revenue descending.

SELECT 
    st.store_name,
    s.first_name + ' ' + s.last_name AS staff_name,
    COUNT(DISTINCT o.order_id) AS number_of_orders,
    SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) AS total_revenue
FROM sales.stores AS st
INNER JOIN sales.staffs AS s
    ON st.store_id = s.store_id
LEFT JOIN sales.orders AS o
    ON s.staff_id = o.staff_id
LEFT JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY 
    st.store_name,
    s.staff_id,
    s.first_name,
    s.last_name
ORDER BY total_revenue DESC;