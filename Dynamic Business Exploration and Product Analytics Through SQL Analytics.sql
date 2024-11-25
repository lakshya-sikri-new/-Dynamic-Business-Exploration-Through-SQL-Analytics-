 
 --Dynamic Business Exploration And Product Analytics Through SQL Analytics

-- View all Orders and Customer Details

SELECT  o.Order_ID,o.Order_Date,o.Ship_Date,o.Ship_Mode,c.Customer_Name,c.Segment,c.City,c.State
FROM 
Order_Details o
JOIN 
Customer_Details c ON o.Customer_ID = c.Customer_ID;

-- View Product Information Along with Order Details

SELECT o.Order_ID,o.Order_Date,o.Ship_Date,p.Product_Name,p.Category,p.Sub_Category,p.Region
FROM 
    Order_Details o
JOIN 
    Product_Details p ON o.Customer_ID = p.Customer_ID

-- Exploring the Data

SELECT TOP 10 * FROM Customer_Payment;

-- Check the first 10 records from Seller_Data
SELECT TOP 10 * FROM Seller_Data;

-- Check the first 10 records from Product_Details
SELECT TOP 10 * FROM Product_Details;


-- Count the number of orders per seller city

SELECT seller_city, COUNT(Order_ID) AS Order_Count
FROM Seller_Data
GROUP BY seller_city;

-- Count of products in each category

SELECT Category, COUNT(Product_ID) AS Product_Count
FROM Product_Details
GROUP BY Category;

-- Count the number of null values in payment_method

SELECT COUNT(*) AS Null_Payment_Methods
FROM Customer_Payment
WHERE payment_method IS NULL;

-- Explore orders with their payment and seller details
SELECT cp.Order_ID, cp.payment_method, sd.seller_city, pd.Product_Name
FROM Customer_Payment cp
LEFT JOIN Seller_Data sd ON cp.Order_ID = sd.Order_ID
LEFT JOIN Product_Details pd ON cp.Order_ID = pd.Order_ID;




-- Problems Statement 

--1)Total Sales and Profit per Customer

SELECT  c.Customer_Name,  SUM(pp.Sales) AS Total_Sales,  SUM(pp.Profit) AS Total_Profit
FROM Product_Prices pp
JOIN 
    Customer_Details c ON pp.Customer_ID = c.Customer_ID
GROUP BY 
    c.Customer_Name;

--2) Calculates total sales, total profit, and the number of orders for each customer.

SELECT 
    c.Customer_Name,
    SUM(pp.Sales) AS Total_Sales,
    SUM(pp.Profit) AS Total_Profit,
    COUNT(o.Order_ID) AS Total_Orders
FROM 
    Customer_Details c
JOIN 
    Order_Details o ON c.Customer_ID = o.Customer_ID
JOIN 
    Product_Prices pp ON o.Customer_ID = pp.Customer_ID
GROUP BY 
    c.Customer_Name
ORDER BY 
    Total_Sales DESC;


-- 3) Calculates all order details and their associated customer names. Orders that do not have corresponding customer records will still appear in the results.
SELECT 
    o.Order_ID,
    o.Order_Date,
    c.Customer_Name
FROM 
    Order_Details o
RIGHT JOIN 
    Customer_Details c ON o.Customer_ID = c.Customer_ID
ORDER BY 
    o.Order_Date DESC;

--4) Retrieves customer information and their total sales. Customers without sales records will still be included in the results.
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    SUM(pp.Sales) AS Total_Sales
FROM 
    Customer_Details c
LEFT JOIN 
    Order_Details o ON c.Customer_ID = o.Customer_ID
LEFT JOIN 
    Product_Prices pp ON o.Customer_ID = pp.Customer_ID
GROUP BY 
    c.Customer_ID, c.Customer_Name
ORDER BY 
    Total_Sales DESC;



-- 5) Total sales and the number of products sold for each product category

SELECT 
    pd.Category,
    SUM(pp.Sales) AS Total_Sales,
    COUNT(pd.Product_ID) AS Number_of_Products_Sold
FROM 
    Product_Details pd
JOIN 
    Product_Prices pp ON pd.Customer_ID = pp.Customer_ID
GROUP BY 
    pd.Category
ORDER BY 
    Total_Sales ASC;

-- 6) Calculates the average discount and profit for each product.

SELECT 
    pd.Product_Name,
    AVG(pp.Discount) AS Avg_Discount,
    AVG(pp.Profit) AS Avg_Profit
FROM 
    Product_Details pd
JOIN 
    Product_Prices pp ON pd.Customer_ID = pp.Customer_ID
GROUP BY 
    pd.Product_Name
ORDER BY 
    Avg_Profit DESC;

-- 7) Calculates total sales and profit for each region.

SELECT 
    pd.Region,
    SUM(pp.Sales) AS Total_Sales,
    SUM(pp.Profit) AS Total_Profit
FROM 
    Product_Details pd
JOIN 
    Product_Prices pp ON pd.Customer_ID = pp.Customer_ID
GROUP BY 
    pd.Region
ORDER BY 
    Total_Profit DESC;

-- 8) Identifies customers who placed more than one order.

SELECT 
    c.Customer_Name,
    COUNT(o.Order_ID) AS Number_of_Orders
FROM 
    Customer_Details c
JOIN 
    Order_Details o ON c.Customer_ID = o.Customer_ID
GROUP BY 
    c.Customer_Name
HAVING 
    COUNT(o.Order_ID) > 1
ORDER BY 
    Number_of_Orders DESC;

-- 9) Calculates total sales for each customer segment.

SELECT 
    c.Segment,
    SUM(pp.Sales) AS Total_Sales
FROM 
    Customer_Details c
JOIN 
    Product_Prices pp ON c.Customer_ID = pp.Customer_ID
GROUP BY 
    c.Segment
ORDER BY 
    Total_Sales DESC;

-- 10) finds the top 5 products with the highest total profit.

SELECT 
    TOP 5 pd.Product_Name,
    SUM(pp.Profit) AS Total_Profit
FROM 
    Product_Details pd
JOIN 
    Product_Prices pp ON pd.Customer_ID = pp.Customer_ID
GROUP BY 
    pd.Product_Name
ORDER BY 
    Total_Profit DESC;

-- 11) Calculates total sales for each shipping mode.

SELECT 
    o.Ship_Mode,
    SUM(pp.Sales) AS Total_Sales
FROM 
    Order_Details o
JOIN 
    Product_Prices pp ON o.Customer_ID = pp.Customer_ID
GROUP BY 
    o.Ship_Mode
ORDER BY 
    Total_Sales DESC;





-- 12) Calculates the lifetime value of each customer by aggregating total sales and profit over their order history.
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    COUNT(o.Order_ID) AS Total_Orders,
    SUM(pp.Sales) AS Total_Sales,
    SUM(pp.Profit) AS Total_Profit,
    (SUM(pp.Profit) / COUNT(o.Order_ID)) AS Average_Order_Profit,
    (SUM(pp.Sales) / COUNT(o.Order_ID)) AS Average_Order_Value
FROM 
    Customer_Details c
JOIN 
    Order_Details o ON c.Customer_ID = o.Customer_ID
JOIN 
    Product_Prices pp ON o.Customer_ID = pp.Customer_ID
GROUP BY 
    c.Customer_ID, c.Customer_Name
ORDER BY 
    Total_Profit DESC;


-- 13) Identifies customers who haven't placed any orders in the past two years, potentially marking them as churned customers.
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    MAX(YEAR(o.Order_Date)) AS Last_Order_Year
FROM 
    Customer_Details c
JOIN 
    Order_Details o ON c.Customer_ID = o.Customer_ID
GROUP BY 
    c.Customer_ID, c.Customer_Name
HAVING 
    MAX(YEAR(o.Order_Date)) < YEAR(GETDATE()) - 2  -- No orders in the last 2 years
ORDER BY 
    Last_Order_Year ASC;

-- 14) Identifies products that have generated the most profit relative to their sales, highlighting high-profit products.
SELECT 
    pd.Product_Name,
    pd.Category,
    pd.Sub_Category,
    SUM(pp.Profit) AS Total_Profit,
    SUM(pp.Sales) AS Total_Sales,
    (SUM(pp.Profit) / SUM(pp.Sales)) * 100 AS Profit_Margin
FROM 
    Product_Details pd
JOIN 
    Product_Prices pp ON pd.Customer_ID = pp.Customer_ID
GROUP BY 
    pd.Product_Name, pd.Category, pd.Sub_Category
HAVING 
    SUM(pp.Sales) > 500 
ORDER BY 
    Profit_Margin DESC;

-- 15) Shows the cities that have contributed the most to profit, helping you identify key areas of success.
	SELECT 
    c.City,
    c.State,
    SUM(pp.Sales) AS Total_Sales,
    SUM(pp.Profit) AS Total_Profit,
    (SUM(pp.Profit) / SUM(pp.Sales)) * 100 AS Profit_Margin
FROM 
    Customer_Details c
JOIN 
    Order_Details o ON c.Customer_ID = o.Customer_ID
JOIN 
    Product_Prices pp ON o.Customer_ID = pp.Customer_ID
GROUP BY 
    c.City, c.State
HAVING 
    SUM(pp.Sales) > 1000  
ORDER BY 
    Total_Profit DESC;

-- 16) Calculates the average value of orders across different shipping modes to determine which shipping methods are most profitable.
SELECT 
    o.Ship_Mode,
    COUNT(o.Order_ID) AS Orders_Count,
    SUM(pp.Sales) AS Total_Sales,
    SUM(pp.Profit) AS Total_Profit,
    (SUM(pp.Sales) / COUNT(o.Order_ID)) AS Avg_Order_Value,
    (SUM(pp.Profit) / SUM(pp.Sales)) * 100 AS Profit_Margin
FROM 
    Order_Details o
JOIN 
    Product_Prices pp ON o.Customer_ID = pp.Customer_ID
GROUP BY 
    o.Ship_Mode
ORDER BY 
    Avg_Order_Value DESC;


-- 17) Identifies orders where the company lost money, showing negative profits.

SELECT 
    o.Order_ID,
    c.Customer_Name,
    pp.Sales,
    pp.Profit
FROM 
    Order_Details o
JOIN 
    Product_Prices pp ON o.Customer_ID = pp.Customer_ID
JOIN 
    Customer_Details c ON o.Customer_ID = c.Customer_ID
WHERE 
    pp.Profit < 0  -- Filter for orders with negative profit
ORDER BY 
    pp.Profit ASC;


-- 18) Calculates the year-over-year sales growth for each customer segment.

WITH SegmentYearlySales AS (
    SELECT 
        c.Segment,
        YEAR(o.Order_Date) AS Year,
        SUM(pp.Sales) AS Total_Sales
    FROM 
        Customer_Details c
    JOIN 
        Order_Details o ON c.Customer_ID = o.Customer_ID
    JOIN 
        Product_Prices pp ON o.Customer_ID = pp.Customer_ID
    GROUP BY 
        c.Segment, YEAR(o.Order_Date)
)
SELECT 
    s1.Segment,
    s1.Year AS Current_Year,
    s1.Total_Sales AS Current_Year_Sales,
    s2.Total_Sales AS Previous_Year_Sales,
    ((s1.Total_Sales - s2.Total_Sales) / s2.Total_Sales) * 100 AS Sales_Growth
FROM 
    SegmentYearlySales s1
LEFT JOIN 
    SegmentYearlySales s2 ON s1.Segment = s2.Segment AND s1.Year = s2.Year + 1
WHERE 
    s2.Total_Sales IS NOT NULL
ORDER BY 
    Sales_Growth DESC;

-- 19) Calculates the retention rate of customers by comparing the number of customers placing orders in consecutive years.

WITH YearlyCustomers AS (
    SELECT 
        c.Customer_ID,
        YEAR(o.Order_Date) AS Order_Year
    FROM 
        Customer_Details c
    JOIN 
        Order_Details o ON c.Customer_ID = o.Customer_ID
    GROUP BY 
        c.Customer_ID, YEAR(o.Order_Date)
)
SELECT 
    y1.Order_Year AS Year,
    COUNT(DISTINCT y1.Customer_ID) AS Customers_Current_Year,
    COUNT(DISTINCT y2.Customer_ID) AS Customers_Previous_Year,
    (COUNT(DISTINCT y1.Customer_ID) * 1.0 / NULLIF(COUNT(DISTINCT y2.Customer_ID), 0)) * 100 AS Retention_Rate
FROM 
    YearlyCustomers y1
LEFT JOIN 
    YearlyCustomers y2 ON y1.Customer_ID = y2.Customer_ID AND y1.Order_Year = y2.Order_Year + 1
GROUP BY 
    y1.Order_Year
ORDER BY 
    Year DESC;

-- 20) It gives a breakdown of total sales by product category and subcategory, and it calculates the contribution of each subcategory to its parent category.
SELECT 
    pd.Category,
    pd.Sub_Category,
    SUM(pp.Sales) AS Subcategory_Sales,
    ROUND(SUM(pp.Sales) * 100.0 / SUM(SUM(pp.Sales)) OVER (PARTITION BY pd.Category), 2) AS Subcategory_Contribution
FROM 
    Product_Details pd
JOIN 
    Product_Prices pp ON pd.Customer_ID = pp.Customer_ID
GROUP BY 
    pd.Category, pd.Sub_Category
ORDER BY 
    pd.Category, Subcategory_Contribution DESC;


-- 21) Calculate the year-over-year (YoY) sales growth for each product category.

WITH YearlySales AS (
    SELECT 
        pd.Category,
        YEAR(o.Order_Date) AS Year,
        SUM(pp.Sales) AS Total_Sales
    FROM 
        Order_Details o
    JOIN 
        Product_Prices pp ON o.Customer_ID = pp.Customer_ID
    JOIN 
        Product_Details pd ON pp.Customer_ID = pd.Customer_ID
    GROUP BY 
        pd.Category, YEAR(o.Order_Date)
)
SELECT 
    Category,
    Year,
    Total_Sales,
    (Total_Sales - LAG(Total_Sales, 1) OVER (PARTITION BY Category ORDER BY Year)) AS YoY_Sales_Change,
    ROUND((Total_Sales * 1.0 / NULLIF(LAG(Total_Sales, 1) OVER (PARTITION BY Category ORDER BY Year), 0) - 1) * 100, 2) AS YoY_Growth_Percent
FROM 
    YearlySales
ORDER BY 
    Category, Year;

-- 22) Calculates the rolling 3-month average sales for each region.

WITH MonthlySales AS (
    SELECT 
        pd.Region,
        YEAR(o.Order_Date) AS Year,
        MONTH(o.Order_Date) AS Month,
        SUM(pp.Sales) AS Total_Sales
    FROM 
        Order_Details o
    JOIN 
        Product_Prices pp ON o.Customer_ID = pp.Customer_ID
    JOIN 
        Product_Details pd ON o.Customer_ID = pd.Customer_ID
    GROUP BY 
        pd.Region, YEAR(o.Order_Date), MONTH(o.Order_Date)
)
SELECT 
    Region,
    Year,
    Month,
    Total_Sales,
    AVG(Total_Sales) OVER (PARTITION BY Region ORDER BY Year, Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Rolling_3_Month_Avg
FROM 
    MonthlySales
ORDER BY 
    Region, Year, Month;

-- 23) Identifies the top N products by profit growth over time using window functions and a ranking system.
WITH ProductProfit AS (
    SELECT 
        pd.Product_Name,
        YEAR(o.Order_Date) AS Order_Year,
        SUM(pp.Profit) AS Yearly_Profit,
        LAG(SUM(pp.Profit), 1) OVER (PARTITION BY pd.Product_Name ORDER BY YEAR(o.Order_Date)) AS Previous_Year_Profit
    FROM 
        Product_Details pd
    JOIN 
        Order_Details o ON pd.Customer_ID = o.Customer_ID
    JOIN 
        Product_Prices pp ON o.Customer_ID = pp.Customer_ID
    GROUP BY 
        pd.Product_Name, YEAR(o.Order_Date)
),
ProfitGrowth AS (
    SELECT 
        Product_Name,
        Order_Year,
        Yearly_Profit,
        Previous_Year_Profit,
        (Yearly_Profit - Previous_Year_Profit) AS Profit_Growth
    FROM 
        ProductProfit
    WHERE 
        Previous_Year_Profit IS NOT NULL
)
SELECT 
    Product_Name,
    Order_Year,
    Profit_Growth,
    RANK() OVER (ORDER BY Profit_Growth DESC) AS Profit_Growth_Rank
FROM 
    ProfitGrowth
ORDER BY 
    Profit_Growth_Rank
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY; 

-- 24) Calculates the month-over-month sales growth for each customer using a recursive CTE and window functions. It tracks the difference in sales between consecutive months.
WITH SalesByMonth AS (
    SELECT 
        c.Customer_ID,
        YEAR(o.Order_Date) AS Order_Year,
        MONTH(o.Order_Date) AS Order_Month,
        SUM(pp.Sales) AS Total_Sales
    FROM 
        Customer_Details c
    JOIN 
        Order_Details o ON c.Customer_ID = o.Customer_ID
    JOIN 
        Product_Prices pp ON o.Customer_ID = pp.Customer_ID
    GROUP BY 
        c.Customer_ID, YEAR(o.Order_Date), MONTH(o.Order_Date)
),
SalesGrowth AS (
    SELECT 
        Customer_ID,
        Order_Year,
        Order_Month,
        Total_Sales,
        LAG(Total_Sales, 1) OVER (PARTITION BY Customer_ID ORDER BY Order_Year, Order_Month) AS Previous_Month_Sales,
        (Total_Sales - LAG(Total_Sales, 1) OVER (PARTITION BY Customer_ID ORDER BY Order_Year, Order_Month)) AS Growth
    FROM 
        SalesByMonth
)
SELECT 
    Customer_ID,
    Order_Year,
    Order_Month,
    Total_Sales,
    Previous_Month_Sales,
    Growth,
    ROUND((Growth / NULLIF(Previous_Month_Sales, 0)) * 100, 2) AS Growth_Percentage
FROM 
    SalesGrowth
WHERE 
    Previous_Month_Sales IS NOT NULL
ORDER BY 
    Customer_ID, Order_Year, Order_Month;

-- 25) Extracts the first three digits of the postal code to identify which regions (based on postal code prefixes) contribute the most to sales.

WITH PostalCodeSales AS (
    SELECT 
        SUBSTRING(CAST(c.Postal_Code AS VARCHAR(10)), 1, 3) AS Postal_Prefix,
        SUM(pp.Sales) AS Total_Sales
    FROM 
        Customer_Details c
    JOIN 
        Order_Details o ON c.Customer_ID = o.Customer_ID
    JOIN 
        Product_Prices pp ON o.Customer_ID = pp.Customer_ID
    GROUP BY 
        SUBSTRING(CAST(c.Postal_Code AS VARCHAR(10)), 1, 3)
)
SELECT 
    Postal_Prefix,
    Total_Sales,
    RANK() OVER (ORDER BY Total_Sales DESC) AS Sales_Rank
FROM 
    PostalCodeSales
ORDER BY 
    Sales_Rank;

-- 26) Total Orders by Seller City and Status
SELECT 
    sd.seller_city,
    sd.Status,
    COUNT(sd.Order_ID) AS Total_Orders
FROM 
    seller_Data sd
GROUP BY 
    sd.seller_city, sd.Status
ORDER BY 
    Total_Orders DESC;


-- 27) Total Sales by Gender and Age Group

WITH Age_Groups AS (
    SELECT 
        cp.Order_ID,
        cp.gender,
        CASE 
            WHEN cp.age < 20 THEN 'Under 20'
            WHEN cp.age BETWEEN 20 AND 29 THEN '20-29'
            WHEN cp.age BETWEEN 30 AND 39 THEN '30-39'
            WHEN cp.age BETWEEN 40 AND 49 THEN '40-49'
            ELSE '50 and above'
        END AS Age_Group
    FROM 
        Customer_Payment cp
)
SELECT 
    ag.gender,
    ag.Age_Group,
    COUNT(sd.Order_ID) AS Total_Orders
FROM 
    Age_Groups ag
JOIN 
    seller_Data sd ON ag.Order_ID = sd.Order_ID
GROUP BY 
    ag.gender, ag.Age_Group
ORDER BY 
    ag.gender, ag.Age_Group;

-- 28) Monthly Order Trends by Gender

SELECT 
    FORMAT(cp.invoice_date, 'yyyy-MM') AS Month,
    cp.gender,
    COUNT(cp.Order_ID) AS Total_Orders
FROM 
    Customer_Payment cp
GROUP BY 
    FORMAT(cp.invoice_date, 'yyyy-MM'), cp.gender
ORDER BY 
    Month, gender;



--29) Identifying Products Shipped to Customers

	SELECT 
    pd.Product_ID,
    pd.Product_Name,
    pd.Category,
    sd.Order_ID,
    sd.ship_country,
    sd.seller_city,
    CASE 
        WHEN sd.Order_ID IS NULL THEN 'No Orders Placed'
        ELSE 'Order Placed'
    END AS Order_Status
FROM 
    Product_Details pd
LEFT JOIN 
    seller_Data sd ON pd.Order_ID = sd.Order_ID
ORDER BY 
    pd.Product_ID, Order_Status;



-- 30) Most Popular Payment Method by Region

SELECT 
    pd.Region,
    cp.payment_method,
    COUNT(cp.Order_ID) AS Payment_Count
FROM 
    Product_Details pd
LEFT JOIN 
    Customer_Payment cp ON pd.Order_ID = cp.Order_ID
GROUP BY 
    pd.Region, cp.payment_method
HAVING 
    COUNT(cp.Order_ID) > 0
ORDER BY 
    pd.Region, Payment_Count DESC;

-- Average Age of Customers by Product Category 

SELECT 
    pd.Category,
    AVG(cp.age) AS Average_Customer_Age
FROM 
    Product_Details pd
LEFT JOIN 
    Customer_Payment cp ON pd.Order_ID = cp.Order_ID
GROUP BY 
    pd.Category
ORDER BY 
    Average_Customer_Age DESC;

--31) Orders Shipped Outside Seller State

SELECT 
    sd.Order_ID,
    sd.seller_city,
    sd.seller_state,
    sd.ship_country,
    CASE 
        WHEN sd.seller_state != sd.ship_country THEN 'Shipped Outside State'
        ELSE 'Shipped Within State'
    END AS Shipping_Status
FROM 
    seller_Data sd
LEFT JOIN 
    Product_Details pd ON sd.Order_ID = pd.Order_ID
WHERE 
    sd.seller_state != sd.ship_country
ORDER BY 
    sd.Order_ID;

--  32) Identifying High-Value Customers

    SELECT 
    cp.gender,
    cp.age,
    cp.payment_method,
    COUNT(sd.Order_ID) AS Total_Orders,
    CASE 
        WHEN COUNT(sd.Order_ID) > 10 THEN 'High-Value Customer'
        WHEN COUNT(sd.Order_ID) BETWEEN 5 AND 10 THEN 'Mid-Value Customer'
        ELSE 'Low-Value Customer'
    END AS Customer_Category
FROM 
    Customer_Payment cp
FULL OUTER JOIN 
    seller_Data sd ON cp.Order_ID = sd.Order_ID
GROUP BY 
    cp.gender, cp.age, cp.payment_method
ORDER BY 
    Total_Orders DESC;
