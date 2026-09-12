-- SECTION 1: Basic SELECT & Filtering

-- Task 1: Display all products with their product name, model year, and list price.
select product_name,model_year,list_price from production.products;


-- Task 2: Display all products whose list price is greater than 1000,
-- showing the product name and list price.
select product_name,list_price from production.products where list_price > 1000;


-- Task 3: Display all customers who are located in the state of New York (NY).
select * from sales.customers where state = 'NY';


-- Task 4: Display all orders that were placed in the year 2017.
select * from sales.orders where YEAR(order_date)=2017;


-- Task 5: Display all products whose name contains the word 'Trek'.
select * from production.products where product_name like 'Trek%';


-- Task 6: Display all products with a list price between 500 and 1500.
select * from production.products where list_price between 500 and 1500;


-- Task 7: Display all unique cities where customers are located.
select distinct city from sales.customers;


-- Task 8: Display all orders that have not been shipped yet.
-- Orders without a shipping date are identified by a NULL shipped_date.
select * from sales.orders where shipped_date is null;