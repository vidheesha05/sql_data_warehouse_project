/*
====================================================================
DDL Script: Create Gold Views
====================================================================
Script Purpose: 
This script creates views for the Gold layer in the data warehouse.
This Gold layer represents the final dimension and fact tables.

Each view performs transformations and combines data from the silver layer
to produce a clean, enriched, and business-ready datasets.
*/


--Building Gold Layer 
--Creating Customer Dimension

PRINT'========================================================='
PRINT'Create Dimension: gold.dim_customers'
PRINT'========================================================='
IF OBJECT_ID(gold.dim_customers,'V') IS NOT NULL
	DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
	    ELSE COALESCE(ca.gen,'n/a')
	END AS gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON    ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON    ci.cst_key = la.cid
GO

PRINT'========================================================='
PRINT'Create Dimension: gold.dim_products'
PRINT'========================================================='

--Creating Product Dimension
IF OBJECT_ID(gold.dim_products,'V') IS NOT NULL
	DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY crpd.prd_start_date, crpd.prd_key) AS product_key,
	crpd.prd_id AS product_id,
	crpd.prd_key AS product_number,
	crpd.prd_nm AS product_name,
	crpd.cat_id AS category_id,
	erpd.cat AS category,
	erpd.subcat AS subcategory,
	erpd.maintenance,
	crpd.prd_cost AS cost,
	crpd.prd_line AS product_line,
	crpd.prd_start_date AS start_date
FROM silver.crm_prd_info crpd
LEFT JOIN silver.erp_px_cat_g1v2 erpd
ON crpd.cat_id = erpd.id
WHERE prd_end_date IS NULL --Filtering historical data
GO

PRINT'========================================================='
PRINT'Create Fact: gold.fact_sales'
PRINT'========================================================='

--Creating Sales Table
IF OBJECT_ID(gold.fact_sales,'V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT 
	st.sls_ord_num AS order_number,
	pr.product_key,
	pc.customer_key,
	st.sls_order_dt AS order_date,
	st.sls_ship_dt AS ship_date,
	st.sls_due_dt AS due_date,
	st.sls_sales AS sales_amount,
	st.sls_quantity AS qfuantity,
	st.sls_price AS price
FROM silver.crm_sales_details st
LEFT JOIN gold.dim_products pr
ON st.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers pc
ON st.sls_cust_id = pc.customer_id
GO
