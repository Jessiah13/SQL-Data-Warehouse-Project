/*
=================================================================================================================

Data Quality Checks Silver Layer - CRM Source
=================================================================================================================

Script Purpose: 
	This script performs the data quality checks from the silver layer after the data is populated. 
	It performs the chceks on each table within the silver schema that has an CRM source with the expectation of the result noted.

	Should there be a different result other than the expected, 
		either one or both DDL silver layer and/or  procedure_load_silver stored procedure would need to be looked at.

Important: 
	Tables are NOT updated in this script. It ONLY queires exisitng CRM silver tables for quality checks.
=================================================================================================================
*/

******/


USE DataWarehouse


-- ============================================ CRM_PRD_INFO ================================================= --


-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result

SELECT cst_id, COUNT(*)
  FROM [DataWarehouse].[silver].[crm_cust_info]
  GROUP BY cst_id
  HAVING COUNT(*) > 1 OR cst_id IS NULL;
-- Duplicates detected

SELECT *
FROM [DataWarehouse].[silver].[crm_cust_info]
WHERE  cst_id = 29466;
-- Duplicates investigation



-- Checking string columns for white spaces
-- Expectation: no result

SELECT [cst_firstname]
FROM [DataWarehouse].[silver].[crm_cust_info]
WHERE [cst_firstname] != TRIM([cst_firstname]);

SELECT [cst_lastname]
FROM [DataWarehouse].[silver].[crm_cust_info]
WHERE [cst_lastname] != TRIM([cst_lastname]);




-- Check low cardinality columns
-- standardize with friendly text (no acronyms, replace nulls with n/a) 
SELECT DISTINCT[cst_gndr]
FROM [DataWarehouse].[silver].[crm_cust_info];

SELECT DISTINCT[cst_marital_status]
FROM [DataWarehouse].[silver].[crm_cust_info];

-- Final Review of table:
SELECT TOP (100) *
FROM [DataWarehouse].[silver].[crm_cust_info];






-- ============================================ CRM_CUST_INFO ================================================= --



SELECT  [prd_id]
      ,[prd_key]
      ,[prd_nm]
      ,[prd_cost]
      ,[prd_line]
      ,[prd_start_dt]
      ,[prd_end_dt]
  FROM [DataWarehouse].[silver].[crm_prd_info];

  -- Check for Null or Duplicates in Primary Key
  -- Expectation: No Result
  SELECT prd_id, COUNT(*)
  FROM [silver].[crm_prd_info]
  GROUP BY prd_id
  HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- Checking for white space
-- Expectation: No Results

SELECT prd_nm
FROM [silver].[crm_prd_info]
WHERE prd_nm != TRIM(prd_nm)


--Checking for nulls or negative numbers
--Expectations: No Results

SELECT prd_cost
FROM [silver].[crm_prd_info]
WHERE prd_cost < 0 OR prd_cost IS NULL -- there are nulls


-- Low Cardinality 
-- Checking to see how many distinct low cardinality values are there
SELECT DISTINCT prd_line
FROM [silver].[crm_prd_info]


-- Final Review of table:
SELECT TOP (100) *
FROM [DataWarehouse].[silver].[crm_prd_info];





-- ============================================ CRM_CUST_INFO ================================================= --




-- Check for unwatned white spaces 
-- Expectatio: No Result
SELECT 
	[sls_ord_num]
    ,[sls_prd_key]
    ,[sls_cust_id]
    ,[sls_order_dt]
    ,[sls_ship_dt]
    ,[sls_due_dt]
    ,[sls_sales]
    ,[sls_quantity]
    ,[sls_price]
  FROM [DataWarehouse].[silver].[crm_sales_details]
  WHERE [sls_ord_num] != TRIM([sls_ord_num])
  -- No unwated spaces


-- Checking foriegn key - sls_prd_key relation to the crm_prd_info table
-- Expectation: No result
SELECT *
FROM [DataWarehouse].[silver].[crm_sales_details]
WHERE [sls_prd_key] NOT IN (SELECT prd_key FROM silver.crm_prd_info)
-- Means that all the sls_prd_key in the sales details table can be found in the crm_prd_info table.

  
  
-- Checking foriegn key - [sls_cust_id] relation to the crm_cust_info table
-- Expectation: No result
SELECT *
FROM [DataWarehouse].[silver].[crm_sales_details]
WHERE [sls_cust_id] NOT IN (SELECT cst_id FROM silver.crm_cust_info)
-- Means that all the cust id's in the sales details table can be found in the cust info table.


-- Checking for dates that are equal to or less than 0 
-- Expectation: No Result
SELECT [sls_order_dt]
FROM [DataWarehouse].[silver].[crm_sales_details]
WHERE [sls_order_dt] <= 0 
OR LEN([sls_order_dt]) != 8
OR [sls_order_dt] > 20500101
OR [sls_order_dt] < 19000101
-- Dates = to 0 found


-- Checking for dates that are equal to or less than 0 
-- Expectation: No Result
SELECT [sls_ship_dt]
FROM [DataWarehouse].[silver].[crm_sales_details]
WHERE --[sls_ship_dt] <= 0 
LEN([sls_ship_dt]) != 10
OR [sls_ship_dt] > '2050-01-01'
OR [sls_ship_dt] < '1900-01-01'
-- Dates = to 0 found


-- Checking for dates that are equal to or less than 0 
-- Expectation: No Result
SELECT [sls_due_dt]
FROM [DataWarehouse].[silver].[crm_sales_details]
WHERE --[sls_due_dt] <= 0 
 LEN([sls_due_dt]) != 10
OR [sls_ship_dt] > '20500101'
OR [sls_ship_dt] < '19000101'
-- Dates = to 0 found




-- Checking for Invalid Date Orders
-- Expectation: No Result
SELECT *
FROM [DataWarehouse].[silver].[crm_sales_details]
WHERE [sls_order_dt] >= sls_ship_dt OR sls_ship_dt >= sls_due_dt


-- Check Data Consistency: Between Sales, Quantity and Price.
-->> Sales = Qantity * Price
-->> Values must not be Null, 0, or negative.


SELECT 
	 [sls_sales] 
	,[sls_quantity]
	,[sls_price] 
FROM [DataWarehouse].[silver].[crm_sales_details]
WHERE [sls_sales] != [sls_quantity] * [sls_price]
OR [sls_sales] IS NULL OR [sls_quantity] IS NULL OR [sls_quantity] IS NULL
OR [sls_sales] <=0 OR [sls_quantity] <=0 OR [sls_quantity] <=0
ORDER BY 1,2,3



-- Final Review of table:
SELECT TOP (100) *
FROM [DataWarehouse].[silver].[crm_sales_details];







