use bikestores;
--Task 1(section 1 Basic Select & Filtering)
--
select * from production.products

--
select product_name,list_price from production.products where list_price > 1000

--
select * from sales.customers where state='ny'

--
select * from sales.orders where order_date between '2017-01-01' AND '2017-12-30'

--
select * from production.products where product_name Like '%trek%'

--
select * from production.products where list_price between '500' AND  '1500'

--
select Distinct city,first_name,last_name from sales.customers
select * from sales.customers

--
select * from sales.orders where shipped_date IS NULL

