drop table if exists zepto;



CREATE TABle zepto (
    sku_id INT IDENTITY(1,1) PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp DECIMAL(8,2),
    discountPercent DECIMAL(5,2),
    availableQuantity INT,
    discountedSellingPrice DECIMAL(8,2),
    weightInGms INT,
    outOfStock BIT,
    quantity INT
);

select * from zepto 

ALTER TABLE zepto
ADD sku_id INT IDENTITY(1,1);

------------------------------------
     --DATA EXPLORATION
-------------------------------------

-- Count of rows
SELECT COUNT(*) AS Total_Rows
FROM zepto;

-- Sample data
SELECT TOP 10 *
FROM zepto;

-- Null values
SELECT *
FROM zepto
WHERE name IS NULL
   OR category IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR availableQuantity IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL;

-- Different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- Products in stock vs out of stock
SELECT outOfStock,
       COUNT(sku_id) AS Product_Count
FROM zepto
GROUP BY outOfStock;

-- Product names present multiple times
SELECT name,
       COUNT(sku_id) AS [Number of SKUs]
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

--------------------------------------------------
-- DATA CLEANING
--------------------------------------------------

-- Products with price = 0
SELECT *
FROM zepto
WHERE mrp = 0
   OR discountedSellingPrice = 0;

-- Delete products with MRP = 0
DELETE FROM zepto
WHERE mrp = 0;

-- Convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice
FROM zepto;

--------------------------------------------------
-- DATA ANALYSIS
--------------------------------------------------

-- Q1. Top 10 best-value products based on discount percentage
SELECT TOP 10
       name,
       mrp,
       discountPercent
FROM zepto
ORDER BY discountPercent DESC;

--------------------------------------------------

-- Q2. Products with High MRP but Out of Stock
SELECT DISTINCT
       name,
       mrp
FROM zepto
WHERE outOfStock = 1
  AND mrp > 300
ORDER BY mrp DESC;

--------------------------------------------------

-- Q3. Calculate Estimated Revenue for each category
SELECT category,
       SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

--------------------------------------------------

-- Q4. Products where MRP > 500 and discount < 10%
SELECT DISTINCT
       name,
       mrp,
       discountPercent
FROM zepto
WHERE mrp > 500
  AND discountPercent < 10
ORDER BY mrp DESC,
         discountPercent DESC;

--------------------------------------------------

-- Q5. Top 5 categories with highest average discount
SELECT TOP 5
       category,
       ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC;

--------------------------------------------------

-- Q6. Price per gram for products above 100g
SELECT DISTINCT
       name,
       weightInGms,
       discountedSellingPrice,
       ROUND(discountedSellingPrice * 1.0 / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--------------------------------------------------

-- Q7. Group products into Low, Medium, Bulk
SELECT DISTINCT
       name,
       weightInGms,
       CASE
           WHEN weightInGms < 1000 THEN 'Low'
           WHEN weightInGms < 5000 THEN 'Medium'
           ELSE 'Bulk'
       END AS weight_category
FROM zepto;

--------------------------------------------------

-- Q8. Total Inventory Weight Per Category
SELECT Category,
       SUM(CAST(weightInGms AS BIGINT) *
           CAST(availableQuantity AS BIGINT)) AS total_weight
FROM zepto
GROUP BY Category
ORDER BY total_weight DESC;

-------------------------------------------------------

---Q9. Revenue Contribution Percentage

WITH RevenueCTE AS
(
    SELECT
        Category,
        SUM(discountedSellingPrice * quantity) AS Revenue
    FROM zepto
    GROUP BY Category
)
SELECT
    Category,
    Revenue,
    ROUND(
        Revenue * 100.0 /
        SUM(Revenue) OVER(),
        2
    ) AS RevenuePercentage
FROM RevenueCTE
ORDER BY Revenue DESC;

-------------------------------------------

--Q10. Which categories contribute most to total revenue?

SELECT top 3 Category,
       SUM(discountedSellingPrice * quantity) Revenue
FROM zepto
GROUP BY Category
ORDER BY Revenue DESC;

-------------------------------------------------

---Q11. Which products generate the highest revenue?

SELECT TOP 20
       name,
       Category,
       discountedSellingPrice * quantity as Revenue
FROM zepto
ORDER BY Revenue DESC;

----------------------------------------------------

--Q12. Which high-revenue products are currently out of stock?

SELECT
       name,
       Category,
       discountedSellingPrice * quantity as PotentialRevenue
FROM zepto
WHERE outOfStock = 1
ORDER BY PotentialRevenue DESC;

---------------------------------------------------------

---Q13. Which categories have the highest inventory value?

SELECT
       Category,
       SUM(mrp * quantity) InventoryValue
FROM zepto
GROUP BY Category
ORDER BY InventoryValue DESC;

-------------------------------------------------------

--Q14. Which products have unusually high discounts?

SELECT
       name,
       Category,
       discountPercent
FROM zepto
WHERE discountPercent >
(
SELECT AVG(discountPercent)
FROM zepto
);

------------------------------------------------

--Q15. Which categories contribute 80% of total revenue?

WITH RevenueCTE AS
(
SELECT
Category,
SUM(discountedSellingPrice * quantity) Revenue
FROM zepto
GROUP BY Category
)
SELECT *
FROM RevenueCTE
ORDER BY Revenue DESC;

----------------------------------------------------

--Q16.Which products have low stock but high business importance?

SELECT TOP 20
name,
Category,
availableQuantity,
(discountedSellingPrice * quantity) AS PotentialRevenue
FROM zepto
ORDER BY availableQuantity ASC,
         PotentialRevenue DESC;

-------------------------------------------------------

--Q17. Which categories balance revenue and stock availability best?

SELECT
Category,
SUM(discountedSellingPrice * quantity) Revenue,
AVG(availableQuantity) AvgAvailability
FROM zepto
GROUP BY Category
ORDER BY Revenue DESC;

------------------------------------------------

---Q18. Product Name Length Analysis

SELECT
    name,
    LEN(name) AS ProductNameLength
FROM zepto
ORDER BY ProductNameLength DESC;

------------------------------------------------

---Q19. Find Products Containing "Chocolate"

SELECT *
FROM zepto
WHERE name LIKE '%Chocolate%';


-----------------------------------------------------

--Q20. Which categories are relying heavily on discounts to attract customers?

CREATE VIEW vw_DiscountAnalysis
AS
SELECT
    Category,
    COUNT(*) AS TotalProducts,
    AVG(discountPercent) AS AvgDiscount,
    MAX(discountPercent) AS MaxDiscount
FROM zepto
GROUP BY Category;

select * from  vw_DiscountAnalysis

----------------------------------------------------

---Q21. write a stored procedure that identifies products receiving high discounts while having low stock availability.

CREATE PROCEDURE sp_AttentionProducts
    @MinDiscount INT,
    @MaxAvailableQty INT
AS
BEGIN

    SELECT
        name,
        Category,
        discountPercent,
        availableQuantity,
        discountedSellingPrice
    FROM zepto
    WHERE discountPercent >= @MinDiscount
      AND availableQuantity <= @MaxAvailableQty
    ORDER BY discountPercent DESC,
             availableQuantity ASC;

END;

EXEC sp_AttentionProducts
     @MinDiscount = 15,
     @MaxAvailableQty = 100;


-------------------------------------------------------

--Q22. Top 1 revenue products

WITH ProductRevenue AS
(
    SELECT
        name,
        Category,
        discountedSellingPrice * quantity AS Revenue,

        DENSE_RANK() OVER
        (
            PARTITION BY Category
            ORDER BY discountedSellingPrice * quantity DESC
        ) AS RevenueRank

    FROM zepto
)

SELECT *
FROM ProductRevenue
WHERE RevenueRank <= 1;

--------------------------------------------------

--Q23.Category-wise Highest Discount Products

WITH DiscountRanking AS
(
    SELECT
        name,
        Category,
        discountPercent,

        DENSE_RANK() OVER
        (
            PARTITION BY Category
            ORDER BY discountPercent DESC
        ) AS DiscountRank

    FROM zepto
)

SELECT *
FROM DiscountRanking
WHERE DiscountRank <= 2;


------------------------------------------------

---Q24. Category revenue more than ?10 lakhs 

DECLARE @Revenue BIGINT;

SELECT
    @Revenue = SUM(discountedSellingPrice * quantity)
FROM zepto
WHERE Category = 'Chocolates & Candies';

IF @Revenue > 1000000
BEGIN
    PRINT 'High Performing Category';
END
ELSE
BEGIN
    PRINT 'Needs Improvement';
END

-----------------------------------------

--Q25.  Stock Availability Check 

DECLARE @OutOfStockCount INT;

SELECT
    @OutOfStockCount = COUNT(*)
FROM zepto
WHERE outOfStock = 1;

IF @OutOfStockCount > 50
BEGIN
    PRINT 'Inventory Alert: Too Many Products Out Of Stock';
END
ELSE
BEGIN
    PRINT 'Inventory Status Healthy';
END





