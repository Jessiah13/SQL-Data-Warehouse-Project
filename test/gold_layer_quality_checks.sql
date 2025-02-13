/*
=================================================================================================================

Data Quality Checks: Gold layer
=================================================================================================================

Script Purpose: 
	This script performs the data quality checks from the Gold layer after the data is populated. 
	It performs the chceks  to validate the integrity, consistency, and accuracy of the Gold layer
	These checks ensures:
	- Uniqueness of surrogated keys in dimension tables/views.
	- Referntial integrity between fact and dimension tables/view.
	- Validation of relationships in the data model for analytical purposes.

	Should there be a different result other than the expected, 
		either one or both DDL silver layer and/or  procedure_load_silver stored procedure would need to be looked at.

Important: 
	Tables are NOT updated in this script. It ONLY queires exisitng CRM silver tables for quality checks.

Usage Notes: 
	- Investigate and resolve any discrepancies found during checks.
=================================================================================================================
*/




/*==========================================Customers============================================*/


-- Check for duplicated customer_id rows 
-- Expectation: No result
SELECT customer_id, COUNT(*)
FROM [gold].[dim_customers]
GROUP BY customer_id 
HAVING COUNT(*) > 1



-- Check distcint values of gender columns
-- Expectation: Only Distinct and undrelated values should appear.(Male, Female, n/a)
SELECT DISTINCT gender
FROM [gold].[dim_customers]


-- Final Review: 
SELECT *
FROM [gold].[dim_customers]


/*==========================================Products============================================*/


-- Check for duplicated product_id rows 
-- Expectation: No result
SELECT product_id, COUNT(*)
FROM [gold].[dim_products]
GROUP BY product_id 
HAVING COUNT(*) > 1


-- Check for NULL values in category_name, subcategory and maintenance columns
-- Expectation: No Result
SELECT *
FROM [gold].[dim_products]
WHERE category_name IS NULL OR subcategory IS NULL OR maintenance IS NULL;


-- Final Review: 
SELECT *
FROM [gold].[dim_products];




/*==========================================Products============================================*/

-- Check if fact view joins correctly with dim views
-- Expectation 1 : all columns from gold views (fact_sales, dim_customer & dim_products)
-- Expectation 2 : No result
SELECT *
FROM gold.fact_sales as f 
LEFT JOIN gold.dim_customers c
	ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products as p
	ON f.product_key = p.product_key
WHERE c.customer_key IS NULL -- Check if dim_customer has any customer_key not found in fact_sales.
OR 
p.product_key IS NULL-- Check if dim_products has any product_key not found in fact_sales.

