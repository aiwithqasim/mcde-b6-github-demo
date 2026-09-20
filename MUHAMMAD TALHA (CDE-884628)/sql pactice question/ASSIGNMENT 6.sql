-- ============================================================
-- Assignment: BikeStores - Joins, GROUP BY, Subqueries & CTEs
-- Student: Muhammad Talha
-- Saylani ID: CDE-884628
-- ============================================================

-- ============================================================
-- JOINS
-- ============================================================

-- Task 1: List every order with the customer, store, and staff names.
SELECT
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
    st.store_name,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_full_name,
    o.order_date,
    o.order_status
FROM sales.orders AS o
INNER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN sales.stores AS st
    ON o.store_id = st.store_id
INNER JOIN sales.staffs AS s
    ON o.staff_id = s.staff_id;

-- Task 2: Show every product with its brand and category, including missing assignments.
SELECT
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products AS p
LEFT JOIN production.brands AS b
    ON p.brand_id = b.brand_id
LEFT JOIN production.categories AS c
    ON p.category_id = c.category_id;

-- Task 3: Find customers who have never placed an order.
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
    c.city,
    c.email
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- ============================================================
-- GROUP BY
-- ============================================================

-- Task 4: Calculate total revenue per store, from highest to lowest.
SELECT
    st.store_id,
    st.store_name,
    COALESCE(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 0) AS total_revenue
FROM sales.stores AS st
LEFT JOIN sales.orders AS o
    ON st.store_id = o.store_id
LEFT JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY st.store_id, st.store_name
ORDER BY total_revenue DESC;

-- Task 5: Show brand product count, average price, and highest price.
SELECT
    b.brand_id,
    b.brand_name,
    COUNT(p.product_id) AS product_count,
    AVG(p.list_price) AS average_list_price,
    MAX(p.list_price) AS highest_list_price
FROM production.brands AS b
INNER JOIN production.products AS p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_id, b.brand_name
HAVING COUNT(p.product_id) > 5
ORDER BY product_count DESC;

-- Task 6: Show order count and revenue for each month in 2017.
SELECT
    MONTH(o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_date >= '20170101'
  AND o.order_date < '20180101'
GROUP BY MONTH(o.order_date)
ORDER BY order_month;

-- ============================================================
-- SUBQUERIES
-- ============================================================

-- Task 7: Find products priced above the average price of their category.
SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    p.list_price
FROM production.products AS p
WHERE p.list_price > (
    SELECT AVG(category_product.list_price)
    FROM production.products AS category_product
    WHERE category_product.category_id = p.category_id
)
ORDER BY p.category_id, p.list_price DESC;

-- Task 8: List customers with more orders than the average orders per customer.
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(customer_order_count * 1.0)
    FROM (
        SELECT
            c2.customer_id,
            COUNT(o2.order_id) AS customer_order_count
        FROM sales.customers AS c2
        LEFT JOIN sales.orders AS o2
            ON c2.customer_id = o2.customer_id
        GROUP BY c2.customer_id
    ) AS order_counts
)
ORDER BY order_count DESC;

-- ============================================================
-- CTEs
-- ============================================================

-- Task 9: Calculate customer spend, label customers, and return the top 10.
;WITH CustomerSpend AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
        COALESCE(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 0) AS total_spend
    FROM sales.customers AS c
    LEFT JOIN sales.orders AS o
        ON c.customer_id = o.customer_id
    LEFT JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
LabeledCustomers AS (
    SELECT
        customer_id,
        customer_full_name,
        total_spend,
        CASE
            WHEN total_spend > (SELECT AVG(total_spend * 1.0) FROM CustomerSpend)
                THEN 'High'
            ELSE 'Regular'
        END AS customer_label
    FROM CustomerSpend
),
RankedCustomers AS (
    SELECT
        customer_id,
        customer_full_name,
        total_spend,
        customer_label,
        RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
    FROM LabeledCustomers
)
SELECT TOP 10
    customer_id,
    customer_full_name,
    total_spend,
    customer_label,
    spend_rank
FROM RankedCustomers
ORDER BY spend_rank, customer_id;

-- Task 10: Find the best-selling product in each category and its total stock.
;WITH ProductSales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity) AS total_quantity_sold
    FROM production.products AS p
    INNER JOIN sales.order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category_id
),
RankedProducts AS (
    SELECT
        ps.product_id,
        ps.product_name,
        ps.category_id,
        ps.total_quantity_sold,
        ROW_NUMBER() OVER (
            PARTITION BY ps.category_id
            ORDER BY ps.total_quantity_sold DESC, ps.product_id
        ) AS product_rank
    FROM ProductSales AS ps
),
StockTotals AS (
    SELECT
        product_id,
        SUM(quantity) AS total_stock_available
    FROM production.stocks
    GROUP BY product_id
)
SELECT
    c.category_name,
    rp.product_id,
    rp.product_name,
    rp.total_quantity_sold,
    COALESCE(st.total_stock_available, 0) AS total_stock_available
FROM RankedProducts AS rp
INNER JOIN production.categories AS c
    ON rp.category_id = c.category_id
LEFT JOIN StockTotals AS st
    ON rp.product_id = st.product_id
WHERE rp.product_rank = 1
ORDER BY c.category_name;

-- ============================================================
-- BONUS CHALLENGES
-- ============================================================

-- Bonus 1: Rewrite Task 8 using a CTE.
;WITH CustomerOrderCounts AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
        COUNT(o.order_id) AS order_count
    FROM sales.customers AS c
    LEFT JOIN sales.orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
AverageOrderCount AS (
    SELECT AVG(order_count * 1.0) AS average_orders_per_customer
    FROM CustomerOrderCounts
)
SELECT
    coc.customer_id,
    coc.customer_full_name,
    coc.order_count
FROM CustomerOrderCounts AS coc
CROSS JOIN AverageOrderCount AS aoc
WHERE coc.order_count > aoc.average_orders_per_customer
ORDER BY coc.order_count DESC;

-- Bonus 2: Add each store's percentage share of total company revenue.
;WITH StoreRevenue AS (
    SELECT
        st.store_id,
        st.store_name,
        COALESCE(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 0) AS store_revenue
    FROM sales.stores AS st
    LEFT JOIN sales.orders AS o
        ON st.store_id = o.store_id
    LEFT JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY st.store_id, st.store_name
)
SELECT
    store_id,
    store_name,
    store_revenue,
    CAST(
        100.0 * store_revenue / NULLIF(SUM(store_revenue) OVER (), 0)
        AS DECIMAL(10, 2)
    ) AS revenue_share_percentage
FROM StoreRevenue
ORDER BY store_revenue DESC;
