-- MASTER ANALYSIS VIEW

CREATE OR REPLACE VIEW v_order_sales AS
SELECT
    o.order_id,
    o.order_date,
    oc.order_status,
    oc.sales_channel,
    c.customer_id,
    c.country,
    c.state,
    c.city,
    oi.product_id,
    p.category,
    p.subcategory,
    p.brand,
    oi.quantity,
    oi.unit_price,
    oi.discount,
    (oi.quantity * oi.unit_price * (1 - oi.discount/100)) AS gross_sales_amount
FROM orders_clean oc
JOIN customers_clean c   ON oc.customer_id = c.customer_id
JOIN order_items_clean oi ON oc.order_id = oi.order_id
JOIN products_clean p     ON oi.product_id = p.product_id
JOIN orders o             ON oc.order_id = o.order_id;

-- Q1: Monthly revenue and orders
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS year_month,
    COUNT(DISTINCT order_id)        AS total_orders,
    ROUND(SUM(gross_sales_amount), 2) AS total_revenue
FROM v_order_sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY year_month;

-- Q2: Top 10 products by revenue
SELECT
    product_id,
    category,
    subcategory,
    brand,
    ROUND(SUM(gross_sales_amount), 2) AS product_revenue
FROM v_order_sales
GROUP BY product_id, category, subcategory, brand
ORDER BY product_revenue DESC
LIMIT 10;

-- Q3: Top 10 customers by revenue
SELECT
    customer_id,
    country,
    state,
    city,
    ROUND(SUM(gross_sales_amount), 2) AS customer_revenue,
    COUNT(DISTINCT order_id)          AS order_count
FROM v_order_sales
GROUP BY customer_id, country, state, city
ORDER BY customer_revenue DESC
LIMIT 10;
