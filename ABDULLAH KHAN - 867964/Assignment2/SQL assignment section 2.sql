                               --Section 2 — Sorting & Top-N
use BikeStores;
go

--Task 9:  List the top 10 most expensive products, sorted by price descending.
select top 10
product_name, 
product_id,
list_price
from production.products 
 order by 
 list_price desc;
--Task 9 end 

--Task 10:  List all customers sorted by last name (A–Z), then first name (A–Z).
SELECT * 
FROM sales.customers 
ORDER BY 
    first_name ASC, 
    last_name ASC;
--Task 10 end

--Task 11:  Find the 5 cheapest products that were produced in model year 2018.
select top 5 
product_id,
product_name,
list_price
from production.products
where  model_year = 2018 order by list_price ASC; 
--Task end