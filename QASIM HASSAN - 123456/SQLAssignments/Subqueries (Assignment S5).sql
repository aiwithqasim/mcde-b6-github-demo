use BikeStores;
go 

--Task 29:  Find all products whose list price
--is above the overall average list price.
--Hint: Use a subquery in the WHERE clause with AVG().

select * from production.products
where list_price > (select avg(list_price)
from production.products);


-- Task 30:  Find customers who have never placed an order.
-- Hint: Use NOT IN or NOT EXISTS with a subquery on sales.orders.

select * 
from sales.customers
where customer_id NOT IN (select customer_id 
from sales.orders );

