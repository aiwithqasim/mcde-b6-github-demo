--Q1) Assign a sequential row number to each product ordered by list_price descending. Then assign a second row number partitioned by category_id, resetting within each category.


SELECT 
    product_id,
    product_name,
    category_id,
    list_price,
    ROW_NUMBER() OVER (ORDER BY list_price DESC) AS global_row_num,
    ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS category_row_num
FROM production.products;


--Q2) Write a query that returns each product with its RANK() and DENSE_RANK() by list_price descending within its category. Show a product where the two rankings differ


WITH RankedProducts AS (
    SELECT 
        product_id,
        product_name,
        category_id,
        list_price,
        RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS price_rank,
        DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS price_dense_rank
    FROM production.products
)
SELECT *
FROM RankedProducts
WHERE price_rank <> price_dense_rank;


--Q3) Use LAG() to calculate the month-over-month revenue change for each store. Show the current month revenue, the previous month revenue, and the difference.


WITH MonthlyRevenue AS (
    SELECT 
        o.store_id,
        DATEFORMAT(o.order_date, 'yyyy-MM') AS year_month,
        SUM(i.quantity * i.list_price * (1 - i.discount)) AS current_month_revenue
    FROM sales.orders o
    JOIN sales.order_items i ON o.order_id = i.order_id
    GROUP BY o.store_id, DATEFORMAT(o.order_date, 'yyyy-MM')
)
SELECT 
    store_id,
    year_month,
    current_month_revenue,
    LAG(current_month_revenue) OVER (PARTITION BY store_id ORDER BY year_month) AS previous_month_revenue,
    current_month_revenue - LAG(current_month_revenue) OVER (PARTITION BY store_id ORDER BY year_month) AS revenue_difference
FROM MonthlyRevenue;



--Q4) Use NTILE(5) to divide all products into five price bands. Return the product name, price, and band number.


SELECT 
    product_name,
    list_price,
    NTILE(5) OVER (ORDER BY list_price DESC) AS price_band
FROM production.products;



--Q5) Write a query that shows each order with a running total of revenue ordered by order_date. Use ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.




WITH OrderRevenue AS (
    SELECT 
        o.order_id,
        o.order_date,
        SUM(i.quantity * i.list_price * (1 - i.discount)) AS order_revenue
    FROM sales.orders o
    JOIN sales.order_items i ON o.order_id = i.order_id
    GROUP BY o.order_id, o.order_date
)
SELECT 
    order_id,
    order_date,
    order_revenue,
    SUM(order_revenue) OVER (
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue
FROM OrderRevenue;



--Q6) Think About It: Why does LAST_VALUE() require RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING to return the actual last value in the partition, while FIRST_VALUE() works correctly with the default frame? What is the default window frame when ORDER BY is specified, and how does that explain the behavior?


Default Window Frame: Jab SQL query mein ORDER BY clause use hota hai, toh default window frame RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW hota hai.

FIRST_VALUE() Ka Behavior: Kyun ke frame pehli row se shuru hota hai (UNBOUNDED PRECEDING), is liye partition ki sab se pehli value hamesha frame ke andar shamil hoti hai aur FIRST_VALUE() sahi kaam karta hai.

LAST_VALUE() Ka Behavior: Default frame ka endpoint CURRENT ROW hota hai. Is ka matlab yeh hai ke LAST_VALUE() poore partition ki akhri row dekhne ke bajaye moujooda (current) row ko hi akhri samajhta hai.

Fix: Is wajah se LAST_VALUE() ko poore partition ka akhri element dikhane ke liye hum frame ko extend karke BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING set karte hain taake frame current row par rukne ke bajaye partition ke aakhir tak jaye.