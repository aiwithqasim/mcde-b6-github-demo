--use BikeStores;

--Section 1 — Basic SELECT & Filtering

--TASK 1

--SELECT
--    product_name,
--    model_year,
--    list_price
--FROM production.products;

--TASK 2

--SELECT
--    product_name,
--    list_price
--FROM production.products
--WHERE list_price > 1000;

--TASK 3

--SELECT
--    *
--FROM sales.customers
--WHERE state = 'NY';

--TASK 4
--SELECT
--    *
--FROM sales.orders
--WHERE YEAR(order_date) = 2017;

--TASK 5

--SELECT
--    product_name
--FROM production.products
--WHERE product_name LIKE '%Trek%';

--Task 6:  Find all products priced between 500 and 1500.
--Hint: Use the BETWEEN operator.

--select * from production.products where list_price between 500 and 1500;

--Task 7:  List all distinct cities where customers are located

--SELECT DISTINCT city from sales.customers;

--Task 8:  Find all orders that have NOT been shipped

--select * from sales.orders  where shipped_date IS NULL;

