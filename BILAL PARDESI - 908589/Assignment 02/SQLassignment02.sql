
### Task 9: List the top 10 most expensive products, sorted by price descending.

```sql
SELECT TOP 10
    product_name,
    product_id,
    list_price
FROM production.products
ORDER BY list_price DESC;
```

---

### Task 10: List all customers sorted by last name (A–Z), then first name (A–Z).

```sql
SELECT
    customer_id,
    first_name,
    last_name
FROM sales.customers
ORDER BY last_name ASC, first_name ASC;
```

---

### Task 11: Find the 5 cheapest products that were produced in model year 2018.

```sql
SELECT TOP 5
    product_name,
    product_id,
    model_year,
    list_price
FROM production.products
WHERE model_year = 2018
ORDER BY list_price ASC;
```

---

## Quick Revision

```text
TOP 10 + ORDER BY list_price DESC
→ 10 most expensive

ORDER BY last_name ASC, first_name ASC
→ Last name A–Z, then first name A–Z

WHERE model_year = 2018
+ TOP 5
+ ORDER BY list_price ASC
→ 5 cheapest products from 2018
```
