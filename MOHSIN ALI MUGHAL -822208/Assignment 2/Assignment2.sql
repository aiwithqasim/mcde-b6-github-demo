
--------------------SECTION 2-----------------
-----------------TASK 1-------------------------
select top 10 * from production.products 
order by list_price desc 

--------------------------TASK 2--------------------
SELECT last_name, first_name FROM sales.staffs
order by last_name, first_name asc


-------------------TASK 3 --------------------------
SELECT top 5 * 
FROM production.products 
WHERE model_year = '2018'
order by list_price asc;