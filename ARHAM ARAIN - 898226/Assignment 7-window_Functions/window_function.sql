
-------------- EXERCISE WINDOW FUNCTIONS -------
 --------------------TASK # 7.1---------------


SELECT
    product_name,
    category_id,
    list_price,

    ROW_NUMBER() OVER(
        ORDER BY list_price DESC
    ) AS overall_row_number,

    ROW_NUMBER() OVER(
        PARTITION BY category_id
        ORDER BY list_price DESC
    ) AS category_row_number

FROM production.products;


 --------------------TASK # 7.2---------------

 SELECT
    product_name,
    category_id,
    list_price,

    RANK() OVER(
        PARTITION BY category_id
        ORDER BY list_price DESC
    ) AS price_rank,

    DENSE_RANK() OVER(
        PARTITION BY category_id
        ORDER BY list_price DESC
    ) AS price_dense_rank

FROM production.products
ORDER BY category_id, list_price DESC;


 --------------------TASK # 7.3---------------
WITH monthly_revenue AS (
    SELECT
        o.store_id,
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,

        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        ) AS current_month_revenue

    FROM sales.orders o
    INNER JOIN sales.order_items oi
        ON o.order_id = oi.order_id

    GROUP BY
        o.store_id,
        YEAR(o.order_date),
        MONTH(o.order_date)
)

SELECT
    store_id,
    order_year,
    order_month,
    current_month_revenue,

    LAG(current_month_revenue) OVER(
        PARTITION BY store_id
        ORDER BY order_year, order_month
    ) AS previous_month_revenue,

    current_month_revenue
    - LAG(current_month_revenue) OVER(
        PARTITION BY store_id
        ORDER BY order_year, order_month
    ) AS revenue_difference

FROM monthly_revenue
ORDER BY
    store_id,
    order_year,
    order_month;

    ----------------------TASK # 7.4---------------
    SELECT
    product_name,
    list_price,

    NTILE(5) OVER(
        ORDER BY list_price
    ) AS price_band

FROM production.products
ORDER BY list_price;

----------------------------TASK # 7.5----------------
SELECT
    o.order_id,
    o.order_date,

    SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) AS order_revenue,

    SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) OVER(
        ORDER BY o.order_date, o.order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue

FROM sales.orders o
INNER JOIN sales.order_items oi
    ON o.order_id = oi.order_id

GROUP BY
    o.order_id,
    o.order_date

ORDER BY
    o.order_date,
    o.order_id;


----------------------------TASK # 7.6----------------

/*FIRST_VALUE()
→ First value already current frame mein hoti hai
→ Isliye default frame mein correctly works

LAST_VALUE()
→ Actual last value current row ke baad ho sakti hai
→ Default frame current row par stop hota hai
→ Isliye UNBOUNDED FOLLOWING chahiye


