# 🛒 Zepto Product Analytics using SQL Server

##  Project Overview

This project is a beginner-friendly **SQL Server Product Analytics** project based on a retail product dataset inspired by Zepto. The project demonstrates how SQL can be used to clean, explore, and analyze product data to generate valuable business insights related to pricing strategies, inventory management, discount optimization, and product performance.

The project follows a complete analytics workflow—from database creation and data cleaning to advanced SQL analysis—showcasing practical SQL Server skills through real-world business scenarios.


# 🎯 Project Objectives

* Design a SQL Server database for product analytics.
* Explore and clean retail product data.
* Analyze pricing, discounts, inventory, and product availability.
* Estimate inventory value and potential revenue.
* Answer business-driven product analytics questions using SQL.
* Practice advanced SQL Server concepts such as CTEs, Window Functions, Views, Stored Procedures, and Conditional Logic.

# 📂 Dataset Information

The dataset contains product catalog information from a retail grocery platform, including:

* Product Name
* Category
* MRP
* Discount Percentage
* Discounted Selling Price
* Product Weight
* Available Quantity
* Stock Status

The dataset is used to perform product analytics by evaluating pricing, discounts, inventory levels, and product performance.

# 📊 What I Performed in This Project

## 1️⃣ Database Creation

* Created a SQL Server database.
* Designed the product table with appropriate data types.
* Defined an Identity Primary Key.
* Imported the retail product dataset into SQL Server.

## 2️⃣ Data Exploration

Performed exploratory analysis to understand the product catalog.

Examples include:

* Total number of products
* Distinct product categories
* Product availability
* Duplicate product identification
* Missing value detection
* Product distribution analysis

## 3️⃣ Data Cleaning

Improved data quality by:

* Removing invalid records
* Eliminating incorrect pricing values
* Converting prices from paise to rupees
* Validating inventory-related fields

## 4️⃣ Product Analytics

Analyzed the dataset to answer business questions related to products.

### 💰 Pricing Analytics

* Highest discounted products
* Premium-priced products
* Average category discounts
* Best value-for-money products

### 📦 Inventory Analytics

* Inventory quantity analysis
* Inventory value estimation
* Out-of-stock products
* High-value products with low inventory
* Weight-based product classification

### 📈 Product Performance Analytics

* Estimated revenue generation
* Top-performing products
* Category performance
* Product ranking using window functions
* Revenue contribution by category

# 🚀 SQL Concepts Implemented

## SQL Fundamentals

* SELECT
* WHERE
* ORDER BY
* GROUP BY
* HAVING
* DISTINCT

## Aggregate Functions

* COUNT()
* SUM()
* AVG()
* MAX()
* ROUND()

## Conditional Logic

* CASE WHEN
* IF...ELSE

## Window Functions

* DENSE_RANK()

## Common Table Expressions (CTEs)

Used for:

* Revenue calculations
* Revenue contribution
* Category ranking

## Views

Created reusable SQL Views for product discount analysis.

## Stored Procedures

Created parameterized Stored Procedures to identify products requiring business attention.

---

# 📌 Business Questions Solved

This project answers several practical business questions, including:

* Which products have the highest discounts?
* Which products generate the highest estimated revenue?
* Which categories contribute the most inventory value?
* Which products are currently out of stock?
* Which products should be restocked first?
* Which categories offer the best pricing opportunities?
* Which products provide the best value based on weight and price?
* Which categories generate the highest revenue?
* Which products require immediate business attention?
* How are products ranked within each category based on revenue?

---

# 📈 Key Business Insights

* Evaluated product pricing strategies.
* Compared discount effectiveness across categories.
* Estimated revenue potential using available inventory.
* Identified high-value products requiring inventory attention.
* Ranked products based on business performance.
* Analyzed category-wise product contribution.
* Generated insights supporting pricing and inventory decisions.

