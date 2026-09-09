-- SECTION 2 — Sorting & Top-N

-- TASK 9
---------

select top 10 * from production.products
order by list_price desc;

--TASK 10
--------

select * from sales.customers
order by last_name asc, first_name ASC;

--TASK 11
----------

SELECT TOP 5 * FROM production.Products
WHERE model_year = 2018
ORDER BY list_price ASC;

