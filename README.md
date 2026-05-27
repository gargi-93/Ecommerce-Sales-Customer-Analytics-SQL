# Ecommerce-Sales-Customer-Analytics-SQL
SQL case study analyzing sales performance, customer behavior, product trends, and return patterns in an e‑commerce business.

## 1. Business context

An online retailer wants to understand:

- How revenue and orders are trending over time.  
- Which product categories, products, and customers drive the most revenue.  
- Which sales channels perform best.  
- How discounts and product returns affect profitability.

This project uses MySQL to simulate an end‑to‑end analytics workflow from raw transactional data to business insights.

## 2. Data model

Entities in the database:

- `customers`: customer demographic and location details.  
- `products`: product catalog with category, subcategory, brand, prices.  
- `orders`: order header with date, status, channel, and payment.  
- `order_items`: line‑level items within each order.  
- `payments`: payment method, status, and date.  
- `returns`: returns, reasons, and refund amounts.

For each raw table there is a corresponding `_clean` version used for analysis (for example, `customers_clean`, `orders_clean`). These are created through a data‑cleaning script in MySQL.

## 3. Tech stack

- Database: MySQL (schema design, data cleaning, analysis queries).  
- Tooling: MySQL Workbench for running scripts and validating results.  
- Version control: GitHub for hosting SQL scripts and documentation.

## 4. Project structure

- `schema.sql` – creates all base tables and database.  
- `data_cleaning.sql` – builds cleaned tables from raw data.  
- `analysis_queries.sql` – contains views and all analytical queries (Q1–Q7).  
- `insights.md` – human‑readable summary of key findings.  
- `images/` – screenshots used in this README.

## 5. How to run

1. **Create the database**

   ```sql
   CREATE DATABASE IF NOT EXISTS ecommerce_sales_db;
   USE ecommerce_sales_db;
   ```

2. **Create tables**

   Run `schema.sql` in MySQL Workbench to create `customers`, `products`, `orders`, `order_items`, `payments`, and `returns`.

3. **Load data**

   Insert data into the base tables (for example, using the sample INSERT statements from this repository or your own CSV imports).

4. **Build clean tables**

   Run `data_cleaning.sql` to create the `_clean` tables (e.g. `customers_clean`, `orders_clean`, etc.).

5. **Create views and run analysis**

   Run `analysis_queries.sql`.

   - This creates the main views `v_order_sales` and `v_order_returns`.  
   - Then execute each SELECT query (Q1–Q7) to generate insights.

## 6. Key analytical questions

The project answers typical business questions for an e‑commerce analyst:

1. **Monthly performance**  
   - What are total orders and revenue by month?  
   - Are there noticeable peaks or dips?

2. **Product and category performance**  
   - Which categories generate the highest revenue?  
   - Which individual products are the top sellers?

3. **Customer value**  
   - Who are the top customers by revenue and order count?  
   - How is revenue distributed across regions (country/state/city)?

4. **Channel effectiveness**  
   - How does revenue and order volume vary across sales channels (online, store, marketplace)?

5. **Discount effectiveness**  
   - How much revenue comes from different discount bands (0%, 0–5%, 5–15%, >15%)?  
   - Are heavy discounts driving meaningful additional revenue?

6. **Returns and quality**  
   - What are return rates and total refunds by category?  
   - Which categories show higher returns due to size or quality issues?

## 7. Example insights (using demo data)

- Electronics drive the largest share of revenue, led by accessories and audio products.  
- Online channel is the main revenue source, while store and marketplace make smaller contributions.  
- A small number of high‑value customers contribute a disproportionate share of revenue.  
- Moderate discounts (5–15%) are associated with strong revenue bands in the sample.  
- Apparel shows higher return rates due to size/quality issues, impacting refund amounts and margins.

## 8. Possible extensions

Future improvements that could be added:

- Additional tables for marketing campaigns or website traffic.  
- Cohort analysis (repeat purchases over time).  
- Profitability analysis including cost vs. revenue and return impact.  
- Visual dashboards (Power BI / Tableau) built on top of the SQL outputs.
