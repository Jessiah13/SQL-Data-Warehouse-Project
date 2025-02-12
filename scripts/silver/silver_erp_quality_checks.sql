/*
=================================================================================================================

Data Quality Checks Silver Layer - ERP Source
=================================================================================================================

Script Purpose: 
	This script performs the data quality checks from the silver layer after the data is populated. 
	It performs the chceks on each table within the silver schema taht has an ERP source with the expectation of th result noted.

	Should there be a different result other than the expected, 
		either one or both DDL silver layer and/or  procedure_load_silver stored procedure would need to be looked at.

Important: 
	Tables are NOT updated in this script. It ONLY queires exisitng ERP silver tables for quality checks.
=================================================================================================================
*/




-- ============================================ ERP_CUST_AZ12 ================================================= --


-- Check for NAS prefix from the cid column or if another prefix is populated.

SELECT cid
 FROM [DataWarehouse].silver.[erp_cust_az12]
 WHERE cid LIKE 'NAS%' OR LEN(cid) >10



-- Check the extremes of the bdate that are beyond the current year
 -- Ensure that there's not birthdate in the future (beyond the current year)
 SELECT [bdate]
 FROM [DataWarehouse].silver.[erp_cust_az12]
 WHERE [bdate] < '1925-01-01' OR [bdate] > GETDATE()
 ORDER BY 1



-- Low cardinality Check for gender column
-- Ensure distinct values are unrelated from each other (f, female etc.)
SELECT DISTINCT	 [gen]
FROM [DataWarehouse].silver.[erp_cust_az12];



-- Final Review of table:
SELECT TOP (100) *
FROM [DataWarehouse].[silver].[erp_cust_az12];





-- ============================================ ERP_LOC_A101 ================================================= --


-- Check cid column if the format is found in the cust_info table
-- Expectation: No Result
SELECT cid
FROM silver.erp_loc_a101
WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info);-- format of cid in erp_loc_a101 is different



-- Low cardinality: Check distinct countries 
-- Standardize countries if two or more values related to the same item is found 
SELECT DISTINCT cntry
FROM Silver.erp_loc_a101
ORDER BY 1;


-- Final Review of table:
SELECT TOP (100) *
FROM [DataWarehouse].[silver].erp_loc_a101;






-- ============================================ ERP_PX_CAT_G1V2 ================================================= --

-- Check for unwatned white spaces
-- Expectation: No Result
SELECT *
FROM silver.[erp_px_cat_g1v2]
WHERE cat != TRIM(cat) OR id != TRIM(id) OR cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);



-- Verify Low cardinality columns standardization 
-- Epxectation: only DISTNCT unrelated values.
SELECT DISTINCT cat
FROM silver.[erp_px_cat_g1v2];
-- no related distinct values found.

SELECT DISTINCT subcat
FROM silver.[erp_px_cat_g1v2];
-- no related distinct values found.

SELECT DISTINCT maintenance
FROM silver.[erp_px_cat_g1v2];
-- no related distinct values found.


-- Final Review of table:
SELECT TOP (100) *
FROM [DataWarehouse].[silver].[erp_px_cat_g1v2];
