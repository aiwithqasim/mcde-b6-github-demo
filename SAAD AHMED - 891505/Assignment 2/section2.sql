-- Section 2 -- Sorting and Top-N
-- Task 9
Select Top 10 product_name, list_price from production.products order by list_price Desc

-- Task 10
Select * FROM sales.customers ORDER BY last_name ASC, first_name ASC;

-- Task 11
Select * FROM production.products where model_year = 2018 and list_price < 1000;