-- 1) Standardize text formats
-- Make country / state / city consistent, trim spaces

CREATE TABLE customers_clean AS
SELECT
    customer_id,
    INITCAP(TRIM(first_name)) AS first_name,
    INITCAP(TRIM(last_name))  AS last_name,
    UPPER(TRIM(gender))       AS gender,
    age,
    INITCAP(TRIM(city))       AS city,
    INITCAP(TRIM(state))      AS state,
    INITCAP(TRIM(country))    AS country,
    signup_date
FROM customers;

CREATE TABLE products_clean AS
SELECT
    product_id,
    TRIM(product_name) AS product_name,
    INITCAP(TRIM(category))    AS category,
    INITCAP(TRIM(subcategory)) AS subcategory,
    INITCAP(TRIM(brand))       AS brand,
    unit_price,
    cost_price
FROM products;

-- 2) Clean orders: remove obviously bad rows, standardize status/channel

CREATE TABLE orders_clean AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    UPPER(TRIM(o.order_status))    AS order_status,
    INITCAP(TRIM(o.sales_channel)) AS sales_channel,
    o.payment_id
FROM orders o
WHERE o.order_date IS NOT NULL;

-- 3) Clean order_items: non‑negative quantity/price, discount default 0

CREATE TABLE order_items_clean AS
SELECT
    order_item_id,
    order_id,
    product_id,
    CASE WHEN quantity < 0 THEN 0 ELSE quantity END AS quantity,
    CASE WHEN unit_price < 0 THEN NULL ELSE unit_price END AS unit_price,
    COALESCE(discount, 0) AS discount
FROM order_items;

-- 4) Clean payments

CREATE TABLE payments_clean AS
SELECT
    payment_id,
    INITCAP(TRIM(payment_method)) AS payment_method,
    UPPER(TRIM(payment_status))   AS payment_status,
    payment_date
FROM payments;

-- 5) Clean returns

CREATE TABLE returns_clean AS
SELECT
    return_id,
    order_id,
    product_id,
    return_date,
    INITCAP(TRIM(return_reason)) AS return_reason,
    refund_amount
FROM returns;
