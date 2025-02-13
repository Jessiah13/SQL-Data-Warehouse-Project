# Document: Data Catalog

Checkbox: Yes
DWH Epics: Build Gold Layer (https://www.notion.so/Build-Gold-Layer-18daffe5768880929d61c461b90004a2?pvs=21)

# Data Dictionary for Gold Layer

---

## Overview

---

The Gold layer is the business level data representation, structured to support analytical and reporting use cases. It consists of **dimensions  tables** and **fact tables** for specific business metrics.

---

---

### 1. gold.dim_customer

- **Purpose:** Stores customer details enriched with demographic and geographic data.
- **Columns:**
    
    
    | **Column Name** | **Data Type** | **Description** |
    | --- | --- | --- |
    | customer_key | INT | Surrogate key uniquely identifying each customer record in the dimension view. |
    | customer_id | INT | Unique numerical identifier assigned to each customer. |
    | customer_number | NVARCHAR(50) | Alpha numeric identifier representing the customer, used for tracking and referencing |
    | first_name | NVARCHAR(50) | The customer’s first name, as recorded in system. |
    | last_name | NVARCHAR(50) | The customer’s last name, as recorded in system. |
    | country | NVARCHAR(50) | The country of residence of the customer (e.g. ‘Australia’). |
    | marital_status | NVARCHAR(50) | The marital status of the customer (e.g. ‘Married’, ‘Single’). |
    | gender | NVARCHAR(50) | The gender of the customer (e.g. ‘Male’, ‘Female’, ‘n’/a’). |
    | birth_date | DATE | The customer’s birthday in the format YYYY-MM-DD (e.g. ‘1994-02-12’). |
    | create_date | DATE | The date and time when the customer record was created in the system. |

---

### 2. gold.dim_products

- **Purpose:** Provides information about the products and their attributes.
- **Columns:**

| **Column Name** | **Data Type** | **Description** |
| --- | --- | --- |
| product_key | INT | Surrogate key uniquely identifying each product record in the product dimension view. |
| product_id | INT | A unique identifier assigned to the products for internal tracking and referencing. |
| product_number | NVARCHAR(50) | A structured alphanumeric code representing the product, often used for categorization or inventory. |
| product_name | NVARCHAR(50) | Descriptive product name, including key details such as type, colour and size. |
| category_id | NVARCHAR(50) | A unique identifier for the product’s category, linking to its high-level classification. |
| category_name | NVARCHAR(50) | The broader classification of the product (e.g. ‘Bikes’, ’Accessories’). |
| subcategory | NVARCHAR(50) | A more detailed classification of the product within the category such as product type. (’Road Bike’, ‘Tires and Tubes’). |
| maintenance | NVARCHAR(50) | Indicator whether the product requires maintenance (e.g. ‘Yes’, ‘No’). |
| product_cost | INT | The cost of the product, measured in monetary units. |
| prodcut_line | NVARCHAR(50) | The specific product line or series to which the product belongs (e.g. ‘Road’, ‘Mountain’) |
| start_date | DATE | The date when the product become available for sale or use, formatted YYYY-MM-DD |

---

### 3. gold.fact_sales

- **Purpose:** Stores transactional sales data for analytical purposes.
- **Columns:**

| **Column Name** | **Data Type** | **Description** |
| --- | --- | --- |
| order_number | NVARCHAR(50) | A unique alphanumeric identifier for each sales order (e.g. ‘SO57870’). |
| product_key | INT | Surrogate key linking the orders to the product dimension view. |
| customer_key | INT | Surrogate key linking the orders to the customer dimension view. |
| order_date | DATE | The date when the order was placed, formatted YYYY-MM-DD. |
| shipping_date | DATE | The date when the order was shipped to the customer, formatted YYYY-MM-DD. |
| due_date | DATE | The date when the order payment was due, formatted YYYY-MM-DD. |
| sales_amount | INT | The total monetary value of the sale for the line item, in whole currency unit (e.g. 25). |
| quantity | INT | The number of unites of the products ordered from the line item (e.g. 1). |
| price | INT | The price per unit of the product for the line item, in whole currency units (e.g. 25). |
