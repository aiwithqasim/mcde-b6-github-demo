use bikestores;
--Task 2(section 2 Sorting & Top-N)

--  List the top 10 most expensive products, sorted by price descending.
SELECT TOP 10 list_price
FROM production.products
ORDER BY list_price DESC;

--List all customers sorted by last name (A–Z), then first name (A–Z).
SELECT *
FROM sales.customers
ORDER BY last_name ASC, first_name ASC;

--
--Find the 5 cheapest products that were produced in model year 2018.
select * from production.products

SELECT TOP 5 list_price,model_year
FROM production.products
where model_year='2018'
ORDER BY list_price ASC;