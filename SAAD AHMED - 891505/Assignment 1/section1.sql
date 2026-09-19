-- Section 1 -- Basic Select and filtering
-- Task 1
Select product_name, model_year, list_price from production.products

-- Task 2
Select product_name, list_price from production.products where list_price > 1000

-- Task 3
Select * from sales.customers where state = 'NY'

-- Task 4
Select * from sales.orders where Year(order_date) = '2017'

-- -- Task 5
Select * from production.products WHERE product_name LIKE '[Trek]%'

-- Task 6
Select * from production.products WHERE list_price between 500 and 1500 order by list_price

-- Task 7
Select distinct city from sales.customers

-- Task 8
Select * from sales.orders WHERE shipped_date is NULL
