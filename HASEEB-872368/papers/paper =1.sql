
-----------------------------------------------------------QUIZ-1-----------------------------------------------------------------------------------------------------------------

================================================================================================================================================================
------joins-----
-- 1. (Easy)  List every order with the customer's full name, store name, and the full name of the staff member who handled it.

SELECT 
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    s.store_name,
    st.first_name + ' ' + st.last_name AS staff_name
FROM sales.orders o
JOIN sales.customers c ON o.customer_id = c.customer_id
   JOIN sales.stores s ON o.store_id = s.store_id
  JOIN sales.staffs st ON o.staff_id = st.staff_id;

---2.  (Easy)  Show each product with its brand name and category name. Include products even if they have no brand or category assigned.
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products as p
LEFT JOIN production.brands b ON p.brand_id = b.brand_id
LEFT JOIN production.categories c ON p.category_id = c.category_id;

-- 3. (Medium) Customers who have never placed an order
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    c.city,
    c.email
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

===============================================================================================================================================================

-----GROUP BY----------
--4.  (Easy)  Calculate total revenue per store. Revenue = quantity * list_price * (1 - discount). Sort from highest to lowest.

SELECT 
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN sales.stores s ON o.store_id = s.store_id
GROUP BY s.store_name
ORDER BY total_revenue DESC;

--5.  (Medium)  For each brand, show the number of products, the average list price, and the highest list price. Only include brands with more than 5 products.
SELECT 
    b.brand_name,
    COUNT(p.product_id) AS product_count,
    AVG(p.list_price) AS avg_price,
    MAX(p.list_price) AS max_price
FROM production.brands b
JOIN production.products p ON b.brand_id = p.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 5;

---6.  (Medium)  Show the number of orders and total revenue per month for the year 2017, ordered chronologically.
SELECT 
    MONTH(o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY MONTH(o.order_date)
ORDER BY order_month ASC;

=============================================================================================================================================================
----sub query------------------


-- 7. (Medium) Products priced above average list price of their own category
SELECT 
    p1.product_id,
    p1.product_name,
    p1.category_id,
    p1.list_price
FROM production.products p1
WHERE p1.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p1.category_id
);

----8.  (Medium)  List the customers who have placed more orders than the average number of orders per customer.
SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT COUNT(order_id) * 1.0 / COUNT(DISTINCT customer_id)
    FROM sales.orders
);

===============================================================================================================================================================-
--------------CTEs---------------------


-- 9. (Hard) Customer spend ranking and tier labeling

WITH CustomerSpend AS (
    SELECT 
        c.customer_id,
        c.first_name + ' ' + c.last_name AS customer_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spend
    FROM sales.customers c
    JOIN sales.orders o ON c.customer_id = o.customer_id
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),

OverallAvg AS (
    SELECT AVG(total_spend) AS avg_spend FROM CustomerSpend
)
SELECT TOP 10 
    cs.customer_id,
    cs.customer_name,
    cs.total_spend,
    RANK() OVER (ORDER BY cs.total_spend DESC) AS spend_rank,

    CASE 
        WHEN cs.total_spend > oa.avg_spend THEN 'High'
        ELSE 'Regular'
    END AS customer_tier
FROM CustomerSpend cs
CROSS JOIN OverallAvg oa
ORDER BY spend_rank;


-- 10. (Hard) Best-selling product per category with total stock across stores

WITH ProductSales AS (
    SELECT 
        p.category_id,
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS total_quantity_sold,
        ROW_NUMBER() OVER (
            PARTITION BY p.category_id 
            ORDER BY SUM(oi.quantity) DESC
        ) AS rank_num
    FROM production.products p
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category_id, p.product_id, p.product_name
),
TotalStock AS (
    SELECT 
        product_id,
        SUM(quantity) AS current_stock
    FROM production.stocks
    GROUP BY product_id
)
SELECT 
    cat.category_name,
    ps.product_name,
    ps.total_quantity_sold,
    ISNULL(ts.current_stock, 0) AS total_stock_available
FROM ProductSales ps
JOIN production.categories cat ON ps.category_id = cat.category_id
LEFT JOIN TotalStock ts ON ps.product_id = ts.product_id
WHERE ps.rank_num = 1;
======================================================================================================================================================
---------Bonus challenges------------

------- Bonus 1: Rewrite Q8 using a CTE
WITH CustomerOrderCounts AS (
    SELECT 
        c.customer_id,
        c.first_name + ' ' + c.last_name AS customer_name,
        COUNT(o.order_id) AS order_count
    FROM sales.customers c
    JOIN sales.orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
AverageOrderCount AS (
    SELECT AVG(1.0 * order_count) AS avg_orders 
    FROM CustomerOrderCounts
)
SELECT 
    coc.customer_id,
    coc.customer_name,
    coc.order_count
FROM CustomerOrderCounts coc
CROSS JOIN AverageOrderCount aoc
WHERE coc.order_count > aoc.avg_orders;



-- Bonus 2: Q4 with percentage share of total company revenue
WITH StoreRevenue AS (
    SELECT 
        s.store_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS store_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN sales.stores s ON o.store_id = s.store_id
    GROUP BY s.store_name
)
SELECT 
    store_name,
    store_revenue,
    (store_revenue * 100.0 / SUM(store_revenue) OVER ()) AS revenue_percentage_share
FROM StoreRevenue
ORDER BY store_revenue DESC;

