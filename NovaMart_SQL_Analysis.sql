/*
    NovaMart Sales & Business Intelligence Analytics
    SQL Server Analysis Queries

    Database: NovaMart
    Table: dbo.NovaMart_Sales_Cleaned
*/

USE NovaMart;
GO

/* 1. View the cleaned data */
SELECT *
FROM dbo.NovaMart_Sales_Cleaned;
GO

/* 2. Overall business KPIs */
SELECT
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Profit) / NULLIF(SUM(Sales), 0) * 100 AS Profit_Margin_Percentage,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    SUM(Sales) / NULLIF(COUNT(DISTINCT Order_ID), 0) AS Average_Order_Value
FROM dbo.NovaMart_Sales_Cleaned;
GO

/* 3. Sales and profit by category */
SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Profit) / NULLIF(SUM(Sales), 0) * 100 AS Profit_Margin_Percentage
FROM dbo.NovaMart_Sales_Cleaned
GROUP BY Category
ORDER BY Total_Sales DESC;
GO

/* 4. Sales and profit by region */
SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Profit) / NULLIF(SUM(Sales), 0) * 100 AS Profit_Margin_Percentage
FROM dbo.NovaMart_Sales_Cleaned
GROUP BY Region
ORDER BY Total_Sales DESC;
GO

/* 5. Sales and profit by sub-category */
SELECT
    Sub_Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Profit) / NULLIF(SUM(Sales), 0) * 100 AS Profit_Margin_Percentage
FROM dbo.NovaMart_Sales_Cleaned
GROUP BY Sub_Category
ORDER BY Total_Sales DESC;
GO

/* 6. Top 10 customers by sales */
SELECT TOP 10
    Customer_ID,
    Customer_Name,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM dbo.NovaMart_Sales_Cleaned
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC;
GO

/* 7. Customer contribution to total sales */
WITH CustomerSales AS
(
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Sales) AS Total_Sales
    FROM dbo.NovaMart_Sales_Cleaned
    GROUP BY Customer_ID, Customer_Name
)
SELECT
    Customer_ID,
    Customer_Name,
    Total_Sales,
    Total_Sales / NULLIF(SUM(Total_Sales) OVER (), 0) * 100
        AS Sales_Contribution_Percentage
FROM CustomerSales
ORDER BY Total_Sales DESC;
GO

/* 8. Customer ranking using RANK */
SELECT
    Customer_ID,
    Customer_Name,
    SUM(Sales) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(Sales) DESC) AS Sales_Rank
FROM dbo.NovaMart_Sales_Cleaned
GROUP BY Customer_ID, Customer_Name
ORDER BY Sales_Rank;
GO

/* 9. Monthly sales and profit */
SELECT
    YEAR(Order_Date) AS Order_Year,
    MONTH(Order_Date) AS Order_Month,
    DATENAME(MONTH, Order_Date) AS Month_Name,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Profit) / NULLIF(SUM(Sales), 0) * 100 AS Profit_Margin_Percentage
FROM dbo.NovaMart_Sales_Cleaned
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date),
    DATENAME(MONTH, Order_Date)
ORDER BY
    Order_Year,
    Order_Month;
GO

/* 10. Product performance */
SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM dbo.NovaMart_Sales_Cleaned
GROUP BY
    Product_ID,
    Product_Name,
    Category,
    Sub_Category
ORDER BY Total_Sales DESC;
GO

/* 11. Top 10 products by sales */
SELECT TOP 10
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM dbo.NovaMart_Sales_Cleaned
GROUP BY
    Product_ID,
    Product_Name,
    Category,
    Sub_Category
ORDER BY Total_Sales DESC;
GO

/* 12. Sales by customer segment */
SELECT
    Segment,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT Customer_ID) AS Customer_Count
FROM dbo.NovaMart_Sales_Cleaned
GROUP BY Segment
ORDER BY Total_Sales DESC;
GO

/* 13. State-level performance */
SELECT
    State,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM dbo.NovaMart_Sales_Cleaned
GROUP BY State
ORDER BY Total_Sales DESC;
GO

/* 14. City-level performance */
SELECT
    City,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM dbo.NovaMart_Sales_Cleaned
GROUP BY City
ORDER BY Total_Sales DESC;
GO

/* 15. Data quality checks */
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Order_ID) AS Unique_Orders,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM dbo.NovaMart_Sales_Cleaned;
GO

/* 16. Check for duplicate Order IDs */
SELECT
    Order_ID,
    COUNT(*) AS Order_Count
FROM dbo.NovaMart_Sales_Cleaned
GROUP BY Order_ID
HAVING COUNT(*) > 1;
GO

/* 17. Check for missing values in important fields */
SELECT
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Order_ID,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Customer_ID,
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Product_ID,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS Missing_Sales,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS Missing_Profit
FROM dbo.NovaMart_Sales_Cleaned;
GO
