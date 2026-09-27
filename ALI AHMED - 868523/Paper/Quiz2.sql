



--Task 1 — Build the Sales Detail Dataset (6 marks)
--Management needs a detailed sales dataset for analysis. Return one row per order item containing:
--● order_id and order_date
--● customer full name
--● store name
--● staff full name
--● product name
--● category name
--● brand name
--● quantity, list_price, discount
--● calculated net_line_revenue
--Include only completed orders (order_status = 4). Sort the result from newest order to oldest
select
    o.order_id,
    o.order_date,
    c.first_name + ' ' + c.last_name as customer_full_name,
    sto.store_name,
    st.first_name + ' ' + st.last_name as staff_full_name,
    p.product_name,
    cat.category_name,
    b.brand_name,
    oi.quantity,
    oi.list_price,
    oi.discount,
    (oi.quantity * oi.list_price * (1 - oi.discount)) as net_line_revenue
from sales.orders o
join sales.customers c on o.customer_id = c.customer_id
join sales.staffs st on o.staff_id = st.staff_id
join sales.stores sto on o.store_id = sto.store_id
join sales.order_items oi on o.order_id = oi.order_id
join production.products p on oi.product_id = p.product_id
join production.brands b on p.brand_id = b.brand_id
join production.categories cat on p.category_id = cat.category_id
where o.order_status = 4
order by o.order_date desc, o.order_id desc;


--Task 2 — Store Performance Summary (5 marks)
--Create a store-level performance report for completed orders showing:
--● store name
--● number of distinct orders
--● total units sold
--● total net revenue
--● average order value
--Return one row per store and order the stores from highest to lowest total net revenue.


select
    sto.store_name,
    count(distinct o.order_id) as distinct_orders,
    sum(oi.quantity) as total_units_sold,
    sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_net_revenue,avg(oi.list_price) as avg_order_value
from sales.stores sto
join sales.orders o on sto.store_id = o.store_id
join sales.order_items oi on o.order_id = oi.order_id
where o.order_status = 4
group by sto.store_id, sto.store_name
order by total_net_revenue desc;

--Task 3 — High-Value Customers (5 marks)
--Management wants to identify high-value customers. Return customers whose total completed-order
--spending is greater than the average total spending of customers who have completed orders.
--Show customer_id, customer name, completed order count, and total spending. Order the result by total
--spending descending.


with cte_value_customer as (
    select
        c.customer_id,
        c.first_name + ' ' + c.last_name as customer_full_name,
        count(distinct o.order_id) as completed_order_count,
        sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_spending
    from sales.customers c
    join sales.orders o on c.customer_id = o.customer_id
    join sales.order_items oi on o.order_id = oi.order_id
    where o.order_status = 4
    group by c.customer_id, c.first_name, c.last_name
)
select
    customer_id,
    customer_full_name,
    completed_order_count,
    total_spending
from cte_value_customer
where total_spending > (select avg(total_spending) from cte_value_customer)
order by total_spending desc;

--Task 4 — Inventory Risk Report (5 marks)
--Operations wants to identify inventory risk. Return products where the stock quantity is below 5 in at least
--one store. Show product name, store name, current quantity, category name, and brand name. Products with zero
--stock should appear first, followed by the lowest remaining quantities.


select
    p.product_name,
    sto.store_name,
    stoc.quantity as current_quantity,
    cat.category_name,
    b.brand_name
from production.stocks stoc
join sales.stores sto on stoc.store_id = sto.store_id
join production.products p on stoc.product_id = p.product_id
join production.brands b on p.brand_id = b.brand_id
join production.categories cat on p.category_id = cat.category_id
where stoc.quantity < 5
order by stoc.quantity asc, p.product_name asc;

--Task 7 — Reusable Reporting View (4 marks)
--Create a view named sales.vw_customer_sales_summary that returns one row per customer and includes:
--● customer_id
--● customer full name
--● total number of completed orders
--● total units purchased
--● total net revenue
--● most recent completed order date
--Customers with no completed orders must still be represented where possible, with appropriate zero/NULL
--values


create view sales.vw_customer_sales_summary as
select
    c.customer_id,
    c.first_name + ' ' + c.last_name as customer_full_name,
    count(distinct o.order_id) as completed_orders_count,
    isnull(sum(oi.quantity), 0) as total_units_purchased,
    isnull(sum(oi.quantity * oi.list_price * (1 - oi.discount)), 0) as total_net_revenue,
    max(o.order_date) as most_recent_order_date
from sales.customers c
left join sales.orders o on c.customer_id = o.customer_id and o.order_status = 4
left join sales.order_items oi on o.order_id = oi.order_id
group by c.customer_id, c.first_name, c.last_name;


select * from sales.vw_customer_sales_summary



--Task 8 — Safe Data Modification (4 marks)
--A customer with customer_id = 1 has requested that their phone number be changed to '(999) 555-0101'.
--Write SQL that performs this update inside an explicit transaction. Include a validation query after the
--UPDATE and show how the change can be rolled back during testing so the assessment database is not
--permanently changed.

begin transaction;

update sales.customers
set phone = '(999) 555-0101'
where customer_id = 1;

select customer_id, first_name, last_name, phone
from sales.customers
where customer_id = 1;

rollback transaction;
--Task 9 — Store Sales Procedure (6 marks)
--Create a stored procedure named sales.usp_store_sales_report with these input parameters:
--● @store_id
--● @start_date
--● @end_date

--The procedure should return completed-order sales for the requested store and date range, grouped by
--product. Return product name, total units sold, and total net revenue, ordered by revenue descending.
--Add appropriate error handling for invalid date ranges where @start_date is later than @end_date.



create procedure sales.usp_store_sales_report
    @store_id int,
    @start_date date,
    @end_date date
as
begin
    set nocount on;

    if @start_date > @end_date
    begin
        throw 50001, 'start date cannot be later than end date.', 1;
        return;
    end

    select
        p.product_name,
        sum(oi.quantity) as total_units_sold,
        sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_net_revenue
    from sales.orders o
    join sales.order_items oi on o.order_id = oi.order_id
    join production.products p on oi.product_id = p.product_id
    where o.store_id = @store_id
      and o.order_status = 4
      and o.order_date between @start_date and @end_date
    group by p.product_id, p.product_name
    order by total_net_revenue desc;
end;
exec sales.usp_store_sales_report 2,'2016-4-3','2018-3-4'

--Task 10 — Management Insight Query (3 marks)
--Write one additional SQL query that you believe would provide useful insight to BikeStores management
--using at least three tables.
--Below the query, add a SQL comment of no more than three lines explaining:
--1. the business question,
--2. what the result measures, and
--3. why management should care about it.

select
    cat.category_name,
    count(distinct o.order_id) as total_completed_orders,
    sum(oi.quantity) as total_units_sold,
    sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_net_revenue
from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
join production.products p on oi.product_id = p.product_id
join production.categories cat on p.category_id = cat.category_id
where o.order_status = 4
group by cat.category_id, cat.category_name
order by total_net_revenue desc;
