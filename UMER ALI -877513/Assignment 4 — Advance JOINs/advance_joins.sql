--ADVANCE JOINS
-- self join 
--task 41
SELECT
    e.first_name + ' ' + e.last_name AS employee,
    m.first_name + ' ' + m.last_name AS manager
FROM sales.staffs AS e
LEFT JOIN sales.staffs AS m 
    on e.manager_id = m.staff_id


--task 42
select 
p1.product_name as product_1,
p2.product_name as product_2,
pb.brand_name,
p1.list_price
from production.products as p1
inner join production.products as p2 
    on p1.brand_id = p2.brand_id        
    and p1.list_price = p2.list_price   
    and p1.product_id < p2.product_id   
inner join production.brands as pb 
    on p1.brand_id = pb.brand_id


--task 43
SELECT
c1.first_name + ' ' + c1.last_name as customer1,
c2.first_name + ' ' + c2.last_name as customer2,
c1.city,
c1.state
FROM sales.customers as c1 
inner join sales.customers as c2    
    on c1.city = c2.city
    and c1.state = c2.state
    and c1.customer_id < c2.customer_id

--task 44
SELECT 
e.first_name + ' ' + e.last_name as employee,
m.first_name + ' ' + m.last_name as hired_by
FROM sales.staffs as e
left join sales.staffs as m
    on e.manager_id = m.staff_id
    and e.store_id = m.store_id

--cross join
--task 45
SELECT 
pc.category_name,
pb.brand_name
FROM production.categories as pc 
cross join production.brands as pb

--task 46
SELECT 
pc.category_name,
pb.brand_name
FROM production.categories as pc 
cross join production.brands as pb
left join production.products as pp
    on pc.category_id = pp.category_id
    and pb.brand_id = pp.brand_id
where pp.product_id is null

--task 47
SELECT 
ss.store_name,
pp.product_name,
ISNULL(ps.quantity, 0) as quantity
FROM sales.stores as ss
cross join production.products as pp
left join production.stocks as ps 
    on ss.store_id = ps.store_id
    and pp.product_id = ps.product_id

--TASK 48 
SELECT
ss.first_name as staff_name,
st.store_name,
case 
    when ss.store_id = st.store_id then 'Actual Assignment'
    else 'Not Actual'
end as assignment_status
FROM sales.staffs as ss
cross join sales.stores as st

-- right join 
-- task 49
SELECT
pp.product_name,
pb.brand_name
FROM production.products as pp
right join production.brands as pb 
    on pp.brand_id = pb.brand_id

--Task 50
SELECT 
st.store_name,
so.order_id
FROM sales.orders as so
right join sales.stores as st
    on so.store_id = st.store_id

-- task 51
SELECT 
COUNT(pp.product_id) as counted_product,
pc.category_name
FROM production.products as pp
right join production.categories as pc
    on pp.category_id = pc.category_id
group by pc.category_name

--task 52
SELECT 
ss.first_name + ' ' + ss.last_name as staff_name,
so.order_id
FROM sales.orders as so
right join sales.staffs as ss
    on so.staff_id = ss.staff_id


--Left Anti Join (LEFT JOIN + WHERE IS NULL)
--task 53
SELECT 
sc.first_name + ' ' + sc.last_name as customer_name,
so.order_id
FROM sales.customers as sc
left join sales.orders as so 
    on sc.customer_id = so.customer_id
where order_id is null

--Task 54
SELECT
pp.product_name,
ps.quantity
FROM production.products as  pp
left join production.stocks as ps 
    on pp.product_id = ps.product_id
where  store_id is null

--Task 55
SELECT 
pb.brand_name
FROM production.brands as pb
left join production.products as pp
    on pb.brand_id = pp.brand_id
where pp.product_id is null

-- task 56
SELECT 
pp.product_name,
oi.order_id
FROM production.products as pp
left join sales.order_items as oi
    on pp.product_id = oi.product_id
where oi.order_id is null

--task 57
SELECT 
st.store_name
FROM sales.stores as st
left join sales.staffs as ss
    on st.store_id = ss.store_id
where ss.store_id is null

-- task 58
SELECT 
ss.first_name + ' ' + ss.last_name as staff_name
FROM sales.staffs as ss
left join sales.orders as so
    on ss.staff_id = so.staff_id
where so.order_id is null
 
--task 59
SELECT 
pc.category_name
FROM production.categories as pc
left join (
    select distinct category_id
    from production.products
    where list_price > 2000
) as expensive_cats
    on pc.category_id = expensive_cats.category_id
where expensive_cats.category_id is null

--Task 60
SELECT 
sc.first_name + ' ' + sc.last_name as customer_name
FROM sales.customers as sc
inner join sales.orders as so
    on sc.customer_id = so.customer_id
left join (
    select distinct so2.customer_id
    from sales.orders as so2
    inner join sales.order_items as oi on so2.order_id = oi.order_id
    inner join production.products as pp on oi.product_id = pp.product_id
    inner join production.brands as pb on pp.brand_id = pb.brand_id
    where pb.brand_name = 'Trek'
) as trek_buyers
    on sc.customer_id = trek_buyers.customer_id
where trek_buyers.customer_id is null

