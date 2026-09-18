

--SEC 2 
--Q9) List the top 10 most expensive products;sorted by price descending 

SELECT 
	TOP 10 product_name , list_price
	FROM Production.products 
	ORDER BY list_price DESC;

	--Q10) List al customers sorted by last name (A-Z) then first name (A-Z) 

	SELECT 
		Customer_id , first_name , phone , email
		FROM sales.customers
		ORDER BY last_name ASC , first_name ASC;



		--Q11) Find the 5 cheapest product that were produced in model year 2018


		SELECT
			Top 5
			product_name,
			model_year,
			list_price
			From production.products
			Where model_year = 2018
			Order By list_price ASC;
