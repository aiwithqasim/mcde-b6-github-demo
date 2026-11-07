USE BikeStores
go

-- 7.1 - Assign a sequential row number to each product ordered
-- by list_price descending. Then assign a second row number 
-- partitioned by category_id, resetting within each category.

select 
 ROW_NUMBER() Over(order by list_price)
 as Global_row_num,

 ROW_NUMBER() OVER (
 partition by category_id
 order by list_price desc
 ) as Category_Row_num,
 *
 from production.products;



--7.2 - Write a query that returns each product with 
--its RANK() and DENSE_RANK() by list_price descending 
--within its category. Show a product 
--where the two rankings differ.

SELECT
    category_id,
    product_name,
    list_price,
    RANK()       OVER (
    partition by category_id
    ORDER BY list_price DESC
    ) AS rank_num,

    DENSE_RANK() OVER (
    partition by category_id
    ORDER BY list_price DESC
    ) AS dense_rank_num
FROM production.products;



--.3 - Use LAG() to calculate the month-over-month revenue 
--change for each store. Show the current month revenue, 
-- the previous month revenue, and the difference.
WITH MonthlyRevenue AS
(
    SELECT
        o.store_id,
        MONTH(o.order_date) AS month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM sales.orders o
    JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.store_id,
        MONTH(o.order_date)
)

SELECT
    store_id,
    month,
    revenue AS current_revenue,

    LAG(revenue) OVER
    (
        PARTITION BY store_id
        ORDER BY month
    ) AS previous_revenue,

    revenue - LAG(revenue) OVER
    (
        PARTITION BY store_id
        ORDER BY month
    ) AS difference

FROM MonthlyRevenue;



--7.4 - Use NTILE(5) to divide all products into five price bands. 
--Return the product name, price, and band number.

Select product_id,
       list_price,
       product_name,
       Ntile(5) over(
       Order by list_price) as Brand_Price
       from production.products
        order by Brand_price,list_price;


--7.5 - Write a query that shows each order with a running 
-- total of revenue ordered by order_date. 
-- Use ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.

with Order_revenue_per_day as(
Select 
    o.order_id,
    o.order_date,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as revenue
    from sales.orders as o
    inner join sales.order_items as oi
    on o.order_id = oi.order_id
    
    group by o.order_id,o.order_date
)
Select
    order_id,
    order_date,
    revenue,
    sum(revenue) OVER
    (
    order by order_date,order_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS total_of_revenue_ordered_by_order_date
        from Order_revenue_per_day
        order by order_date, order_id;

