use bikestores;
-- section 1 -- Basic Select And Filtring 
--task 1
SELECT 
    product_name,
    model_year,
    list_price
FROM production.products;
 
--task 2
SELECT 
    product_name,
    list_price
FROM production.products
WHERE list_price > 1000;

--task 3
SELECT *
FROM sales.customers
WHERE state = 'NY';

--task 4
SELECT *
FROM sales.orders
WHERE YEAR(order_date) = 2017;

--task 5
SELECT *
FROM production.products
WHERE product_name LIKE '%Trek%';
--task 6 
SELECT *
FROM production.products
WHERE list_price BETWEEN 500 AND 1500;

--task 7
SELECT DISTINCT city
FROM sales.customers;




--task 8
SELECT *
FROM sales.orders
WHERE shipped_date IS NULL;

