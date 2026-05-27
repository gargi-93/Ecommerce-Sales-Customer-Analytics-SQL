-- DATA CLEANING SCRIPT (MySQL)

-- 1) Clean customers
CREATE TABLE customers_clean AS
SELECT
    customer_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name)  AS last_name,
    UPPER(TRIM(gender)) AS gender,
    age,
    TRIM(city)    AS city,
    TRIM(state)   AS state,
    TRIM(country) AS country,
    signup_date
FROM customers;

-- 2) Clean products
CREATE TABLE products_clean AS
SELECT
    product_id,
    TRIM(product_name) AS product_name,
    TRIM(category)     AS category,
    TRIM(subcategory)  AS subcategory,
    TRIM(brand)        AS brand,
    unit_price,
    cost_price
FROM products;

-- 3) Clean orders
CREATE TABLE orders_clean AS
SELECT
    order_id,
    customer_id,
    order_date,
    UPPER(TRIM(order_status))    AS order_status,
    TRIM(sales_channel)          AS sales_channel,
    payment_id
FROM orders
WHERE order_date IS NOT NULL;

-- 4) Clean order_items
CREATE TABLE order_items_clean AS
SELECT
    order_item_id,
    order_id,
    product_id,
    CASE WHEN quantity < 0 THEN 0 ELSE quantity END AS quantity,
    CASE WHEN unit_price < 0 THEN NULL ELSE unit_price END AS unit_price,
    IFNULL(discount, 0) AS discount
FROM order_items;

-- 5) Clean payments
CREATE TABLE payments_clean AS
SELECT
    payment_id,
    TRIM(payment_method) AS payment_method,
    UPPER(TRIM(payment_status)) AS payment_status,
    payment_date
FROM payments;

-- 6) Clean returns
CREATE TABLE returns_clean AS
SELECT
    return_id,
    order_id,
    product_id,
    return_date,
    TRIM(return_reason) AS return_reason,
    refund_amount
FROM returns;
