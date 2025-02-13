/*
==============================================================================================================

DDL Script: Create Gold Views
==============================================================================================================

Script Purpose: 
	This script creates views for the Gold layer in the data warehouse.
	The Gold layer represents the final dimension and fact tables (Star Schema)

	Each view performs transformations and combines data from the Silver layer to produce a cleaned, 
	enriched and business-ready dataset.

Usage:
	These views can be queried directly for analytics and reporting.
*/


/*==========================================Customers============================================*/

DROP VIEW IF EXISTS gold.dim_customers;
GO
-- create dim_customer view
CREATE VIEW gold.dim_customers AS


SELECT
	 ROW_NUMBER() OVER(ORDER BY [cst_id]) AS customer_key
	,ci.[cst_id] AS customer_id
	,ci.[cst_key] AS customer_number
	,ci.[cst_firstname] AS first_name
	,ci.[cst_lastname] AS last_name
	,cl.cntry AS country
	,ci.[cst_marital_status] AS marital_status
	,CASE 
		WHEN ci.cst_gndr != 'n/a' THEN cst_gndr -- CRM is the master for gender info.
		ELSE COALESCE(bd.gen , 'n/a')
		END AS gender
	,bd.bdate AS birth_date
	,ci.[cst_created_date] AS create_date
	

FROM [DataWarehouse].[silver].[crm_cust_info] AS ci
	LEFT JOIN  silver.erp_cust_az12 as bd
		ON ci.cst_key = bd.cid
	LEFT JOIN  silver.erp_loc_a101 as cl
		ON ci.cst_key = cl.cid;


/*==========================================Products============================================*/

DROP VIEW IF EXISTS gold.dim_products;
GO
-- create dim_products view
CREATE VIEW gold.dim_products AS 


SELECT 
	 ROW_NUMBER() OVER(ORDER BY p.[prd_start_dt], p.[prd_nm]) AS product_key
	,p.[prd_id] AS product_id
	,p.[prd_key] AS product_number
	,p.[prd_nm] AS product_name
    ,p.[cat_id] AS category_id
	,COALESCE(c.cat, 'n/a') AS category_name
	,COALESCE(c.subcat, 'n/a') AS subcategory
	,COALESCE(c.maintenance, 'n/a') AS maintenance
    ,p.[prd_cost] AS product_cost
    ,p.[prd_line] AS prodcut_line
    ,p.[prd_start_dt] AS start_date

FROM [DataWarehouse].[silver].[crm_prd_info] as p
	LEFT JOIN silver.erp_px_cat_g1v2 as c
	ON p.cat_id = c.id
WHERE p.prd_end_dt IS NULL;-- filter out historical data



/*==========================================Sales============================================*/

DROP VIEW IF EXISTS gold.fact_sales;
GO
-- create fact_sales view
CREATE VIEW gold.fact_sales AS 

SELECT 
	 [sls_ord_num] AS order_number
    ,p.product_key 
    ,c.customer_key
    ,[sls_order_dt] AS order_date
    ,[sls_ship_dt] AS shipping_date
    ,[sls_due_dt] AS due_date
    ,[sls_sales] AS sales_amount
    ,[sls_quantity] AS quantity
    ,[sls_price] AS price
  FROM [DataWarehouse].[silver].[crm_sales_details] AS s
	LEFT JOIN gold.dim_products as p
		ON s.sls_prd_key = p.product_number
	LEFT JOIN gold.dim_customers as c
		ON c.customer_id = s.sls_cust_id
