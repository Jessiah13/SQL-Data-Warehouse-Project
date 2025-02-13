# Building a Data Wearhouse with SQL Server PROJECT

Welcome to the my the SQL Serve Data Warehouse Project Repository! <br>
This Portfolio project is my first attempt of Building a modern data warehouse with SQL Sever, including ETL processes, data modeling and analytics.<br>
As the lines of Data professionals continue to be blurred, I Very exited to to demonstrate the industry best practices and explore the world of Data Engeneering.
***


## Poject Overview
-----
This project involes: <br>
<br>
1. **Data Architecture**: Designing A Modern Data Warehouse Useing the Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.<br>
2. **ETL Pipelines**: Etracting, Transforming and Loading data from source system into warehose.

-----

## Project Requirements 
-----
### Objective

Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

Specifications:

. Data Sources: Import data from two source systems (ERP and CRM) provided as CSV files.<br>
. Data Quality: Cleanse and resolve data quality issues prior to analysis.<br>
. Integration: Combine both sources into a single, user-friendly data model designed for analytical queries.<br>
. Scope: Focus on the latest dataset only; historization of data is not required.<br>
. Documentation: Provide clear documentation of the data model to support both business stakeholders and analytics teams.<br>
-----
<br>
<br>

*****
## Data Architecture

The Structure of the the project follows the Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.<br>

![Alt text](https://raw.githubusercontent.com/Jessiah13/sql_data_warehouse_project/refs/heads/main/docs/Data%20Warehouse%20-%20Data%20Architecture%20(dark).drawio.png)


1. Bronze Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.<br>
2. Silver Layer: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.<br>
3. Gold Layer: Houses business-ready data modeled into a star schema required for reporting and analytics.<br>
