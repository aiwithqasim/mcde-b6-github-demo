use bikeStore

---SECTION 2--

---------Sorting & Top-N--------

-----TASK 1 -----

SELECT TOP 10
product_name,
list_price
FROM 
production.products
ORDER BY  list_price DESC;

------TASK 2-------
SELECT
first_name,
last_name,
email

FROM
sales.customers
ORDER BY last_name ASC, first_name


------- TASK 3 --------

SELECT TOP 5
product_name,
list_price,
model_year
FROM production.products
WHERE model_year= 2018
ORDER BY list_price ASC;

