
   Q1. List every order with:
       - Customer full name
       - Store name
       - Staff full name
  

SELECT
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    st.store_name,
    s.first_name + ' ' + s.last_name AS staff_name,
    o.order_date,
    o.order_status
FROM sales.orders o
INNER JOIN sales.customers c
    ON o.customer_id = c.customer_id
INNER JOIN sales.stores st
    ON o.store_id = st.store_id
INNER JOIN sales.staffs s
    ON o.staff_id = s.staff_id;



   Q2. Show each product with:
       - Brand name
       - Category name
       Include products even if brand/category is NULL
 

SELECT
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    p.list_price
FROM production.products p
LEFT JOIN production.brands b
    ON p.brand_id = b.brand_id
LEFT JOIN production.categories c
    ON p.category_id = c.category_id;



   Q3. Find customers who have NEVER placed an order
 /

SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    c.city,
    c.email
FROM sales.customers c
LEFT JOIN sales.orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;



   GROUP BY
 


   Q4. Calculate total revenue per store
       Revenue =
       quantity * list_price * (1 - discount)

       Highest revenue first
  
SELECT
    st.store_id,
    
    SUM(
        oi.quantity
        * oi.list_price
        * (1 - oi.discount)
    ) AS total_revenue
FROM sales.orders o
INNER JOIN sales.order_items oi
    ON o.order_id = oi.order_id
INNER JOIN sales.stores st
    ON o.store_id = st.store_id
GROUP BY
    st.store_id
    
ORDER BY
    total_revenue DESC;


   Q5. For each brand:
       - Number of products
       - Average list price
       - Highest list price

       Only brands having more than 5 products
   

SELECT
    b.brand_id,
    b.brand_name,
    COUNT(p.product_id) AS product_count,
    AVG(p.list_price) AS average_list_price,
    MAX(p.list_price) AS highest_list_price
FROM production.brands b
INNER JOIN production.products p
    ON b.brand_id = p.brand_id
GROUP BY
    b.brand_id,
    b.brand_name
HAVING COUNT(p.product_id) > 5;


   Q6. Number of orders and total revenue per month
       for year 2017
 

SELECT
    MONTH(o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(
        oi.quantity
        * oi.list_price
        * (1 - oi.discount)
    ) AS total_revenue
FROM sales.orders o
INNER JOIN sales.order_items oi
    ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY
    MONTH(o.order_date)
ORDER BY
    order_month;


/* =========================================================
   SUBQUERIES
   ========================================================= */

 ---------------------------------------------------------
   Q7. Products priced ABOVE the average list price
       of their OWN category.

       Correlated subquery
   

SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    p.list_price
FROM production.products p
WHERE p.list_price >
(
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p.category_id
);


/* ---------------------------------------------------------
   Q8. Customers who placed MORE orders than the
       average number of orders per customer.
   --------------------------------------------------------- */

SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers c
INNER JOIN sales.orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(o.order_id) >
(
    SELECT AVG(order_count * 1.0)
    FROM
    (
        SELECT
            customer_id,
            COUNT(*) AS order_count
        FROM sales.orders
        GROUP BY customer_id
    ) AS customer_orders
);


   CTEs
  


/* ---------------------------------------------------------
   Q9. CTE:
       1. Calculate each customer's total spend
       2. Calculate overall average spend
       3. Label customers:
          High   = above overall average
          Regular = otherwise
       4. Return TOP 10 with rank
   --------------------------------------------------------- */

WITH customer_spend AS
(
    SELECT
        c.customer_id,
        c.first_name + ' ' + c.last_name AS customer_name,
        SUM(
            oi.quantity
            * oi.list_price
            * (1 - oi.discount)
        ) AS total_spend
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

customer_labeled AS
(
    SELECT
        customer_id,
        customer_name,
        total_spend,
        CASE
            WHEN total_spend >
                (SELECT AVG(total_spend) FROM customer_spend)
            THEN 'High'
            ELSE 'Regular'
        END AS customer_type
    FROM customer_spend
),

ranked_customers AS
(
    SELECT
        customer_id,
        customer_name,
        total_spend,
        customer_type,
        RANK() OVER (
            ORDER BY total_spend DESC
        ) AS customer_rank
    FROM customer_labeled
)

SELECT TOP 10
    customer_id,
    customer_name,
    total_spend,
    customer_type,
    customer_rank
FROM ranked_customers
ORDER BY customer_rank;



/* =========================================================
   BONUS 1
   Rewrite Q8 using CTE instead of subquery
   ========================================================= */

WITH customer_orders AS
(
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),

average_orders AS
(
    SELECT
        AVG(order_count * 1.0) AS avg_order_count
    FROM customer_orders
)

SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    co.order_count
FROM customer_orders co
INNER JOIN sales.customers c
    ON co.customer_id = c.customer_id
CROSS JOIN average_orders ao
WHERE co.order_count > ao.avg_order_count
ORDER BY co.order_count DESC;

