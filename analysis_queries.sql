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
    DATE_FORMAT(order_date, '%Y-%m') AS yearM,
    COUNT(DISTINCT order_id)         AS total_orders,
    ROUND(SUM(gross_sales_amount), 2) AS total_revenue
FROM v_order_sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY yearM;

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

-- Q4: Revenue by category
SELECT
    category,
    ROUND(SUM(gross_sales_amount), 2) AS category_revenue,
    COUNT(DISTINCT order_id)          AS order_count
FROM v_order_sales
GROUP BY category
ORDER BY category_revenue DESC;

-- Q5: Revenue and orders by sales channel
SELECT
    sales_channel,
    ROUND(SUM(gross_sales_amount), 2) AS channel_revenue,
    COUNT(DISTINCT order_id)          AS order_count
FROM v_order_sales
GROUP BY sales_channel
ORDER BY channel_revenue DESC;

-- Q6: Discount bands and revenue
SELECT
    CASE
        WHEN discount = 0 THEN '0%'
        WHEN discount BETWEEN 0.01 AND 5 THEN '0-5%'
        WHEN discount BETWEEN 5.01 AND 15 THEN '5-15%'
        ELSE '>15%'
    END AS discount_band,
    ROUND(AVG(discount), 2)           AS avg_discount,
    ROUND(SUM(gross_sales_amount), 2) AS band_revenue,
    COUNT(*)                          AS line_items
FROM v_order_sales
GROUP BY discount_band
ORDER BY band_revenue DESC;

-- View with returns information
CREATE OR REPLACE VIEW v_order_returns AS
SELECT
    vo.*,
    r.return_id,
    r.return_date,
    r.return_reason,
    r.refund_amount
FROM v_order_sales vo
LEFT JOIN returns_clean r
    ON vo.order_id = r.order_id
   AND vo.product_id = r.product_id;

-- Q7: Return rate by product category
SELECT
    category,
    COUNT(DISTINCT order_id)                          AS orders,
    COUNT(DISTINCT return_id)                         AS returned_orders,
    ROUND(100 * COUNT(DISTINCT return_id)
              / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS return_rate_pct,
    ROUND(SUM(refund_amount), 2)                      AS total_refund
FROM v_order_returns
GROUP BY category
ORDER BY return_rate_pct DESC;

USE ecommerce_sales_db;
INSERT INTO customers (customer_id, first_name, last_name, gender, age, city, state, country, signup_date) VALUES
(1, 'Anita',  'Sharma', 'F', 32, 'Mumbai',     'Maharashtra', 'India',    '2023-01-15'),
(2, 'Rahul',  'Verma',  'M', 29, 'Delhi',      'Delhi',       'India',    '2023-02-10'),
(3, 'Emily',  'Clark',  'F', 41, 'New York',   'NY',          'USA',      '2023-03-05'),
(4, 'David',  'Wong',   'M', 36, 'San Jose',   'CA',          'USA',      '2023-04-20'),
(5, 'Sara',   'Lopez',  'F', 27, 'Austin',     'TX',          'USA',      '2023-05-01');

INSERT INTO products (product_id, product_name, category, subcategory, brand, unit_price, cost_price) VALUES
(101, 'Wireless Mouse',        'Electronics', 'Accessories', 'LogiTech', 25.00, 12.00),
(102, 'Mechanical Keyboard',   'Electronics', 'Accessories', 'KeyPro',   80.00, 45.00),
(103, 'Noise Cancelling Headphones', 'Electronics', 'Audio', 'SoundMax', 150.00, 90.00),
(201, 'Running Shoes',         'Apparel',     'Footwear',    'FastRun',  70.00, 30.00),
(202, 'Sports T‑Shirt',        'Apparel',     'Topwear',     'Athletica',30.00, 10.00);

INSERT INTO payments (payment_id, payment_method, payment_status, payment_date) VALUES
(1001, 'Credit Card', 'PAID', '2023-06-01'),
(1002, 'UPI',         'PAID', '2023-06-02'),
(1003, 'Credit Card', 'PAID', '2023-06-05'),
(1004, 'PayPal',      'PAID', '2023-06-07'),
(1005, 'Credit Card', 'PAID', '2023-06-10');

INSERT INTO orders (order_id, customer_id, order_date, order_status, sales_channel, payment_id) VALUES
(5001, 1, '2023-06-01', 'COMPLETED', 'Online', 1001),
(5002, 2, '2023-06-02', 'COMPLETED', 'Online', 1002),
(5003, 3, '2023-06-05', 'COMPLETED', 'Marketplace', 1003),
(5004, 4, '2023-06-07', 'COMPLETED', 'Store', 1004),
(5005, 5, '2023-06-10', 'COMPLETED', 'Online', 1005);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount) VALUES
(1, 5001, 101, 1, 25.00, 0),
(2, 5001, 201, 1, 70.00, 10),
(3, 5002, 102, 1, 80.00, 5),
(4, 5003, 103, 1, 150.00, 0),
(5, 5004, 201, 2, 70.00, 15),
(6, 5005, 101, 1, 25.00, 0),
(7, 5005, 202, 3, 30.00, 5);

INSERT INTO returns (return_id, order_id, product_id, return_date, return_reason, refund_amount) VALUES
(9001, 5004, 201, '2023-06-15', 'Size issue', 70.00),
(9002, 5005, 202, '2023-06-18', 'Quality issue', 60.00);
