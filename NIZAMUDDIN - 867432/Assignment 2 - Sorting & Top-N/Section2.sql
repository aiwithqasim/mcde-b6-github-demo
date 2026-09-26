-- SECTION 2: Sorting & Top-N

-- Task 9: Display the top 10 most expensive products, sorted by price from highest to lowest.
select top 10 product_name,list_price 
from production.products 
order by list_price desc;


-- Task 10: Display all customers sorted by last name in A–Z order,
-- followed by first name in A–Z order.
select * 
from sales.customers 
order by last_name asc, first_name asc;


-- Task 11: Display the 5 cheapest products produced in the year 2018,
-- sorted by price from lowest to highest.
select top 5 * 
from production.products 
where model_year = '2018' 
order by list_price asc;