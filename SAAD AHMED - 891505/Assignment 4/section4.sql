--Section 4 — GROUP BY & Aggregates
--Task 20:  Count how many products exist in each category. Show category name and product count
select c.category_name, count(product_id) as product_count 
from production.categories as c join production.products as p on c.category_id = p.category_id
GROUP BY c.category_name

--Task 21:  Find the average list price of products per brand.
select b.brand_name, AVG(p.list_price) as list_price 
from production.brands as b join production.products as p
on b.brand_id = p.brand_id group by b.brand_name

--Task 22:  For each store, count the total number of orders.
select s1.store_name, count(o.order_id) as order_id 
from sales.stores as s1 join sales.orders as o on s1.store_id = o.store_id
group by s1.store_name