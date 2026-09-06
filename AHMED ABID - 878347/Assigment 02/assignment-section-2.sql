use bikestores ;

--section 2

--task 9
SELECT TOP 10
    product_name,
    list_price
FROM production.products
ORDER BY list_price DESC;


--task 10
SELECT *
FROM sales.customers
ORDER BY last_name ASC, first_name ASC;

--task 11
SELECT TOP 5
    product_name,
    list_price
FROM production.products
WHERE model_year = 2018
ORDER BY list_price ASC;
