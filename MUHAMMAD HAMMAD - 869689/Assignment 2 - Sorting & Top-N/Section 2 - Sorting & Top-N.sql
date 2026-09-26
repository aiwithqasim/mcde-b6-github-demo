Use bikestores;

----Assignment 2----
-----=========----
--Sorting & Top-N
--=============--

--Task 9--
--=====---

Select Top 10 *
 From Production.products
 Order By list_price DESC;

--Task 10--
--=====---

Select * from sales.customers
Order by last_name ASC , first_name ASC;

--Task 11--
--=====---

Select Top 5 *
from production.products
where model_year = '2018'
Order by list_price ASC;