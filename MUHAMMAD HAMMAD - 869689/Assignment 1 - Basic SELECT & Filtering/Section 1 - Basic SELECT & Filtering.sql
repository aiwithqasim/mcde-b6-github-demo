Use bikestores;
----Assignment 1----
--==============--

--Basic SELECT & Filtering
--======================--

--Task 1--
--======--

Select product_name, model_year, list_price
 from production.products;

--Task 2--
--=====---

 Select product_name,list_price from production.products
  where list_price > 1000;

--Task 3--
--=====---

select * from sales.customers 
 where state = 'NY';

--Task 4--
--=====---

 select * from sales.orders
  where Year(order_date) = '2017';

--Task 5--
--=====---

Select *
 from production.products
 where product_name Like '%Trek%';

 --Task 6--
--=====---

Select *
 From production.products
 Where list_price BETWEEN 500 AND 1500;

 --Task 7--
--=====---

Select distinct city from sales.customers;

--Task 8--
--=====---

SELECT *
FROM sales.orders
WHERE shipped_date IS NULL;