how databases;
use mahendra;
show tables;

-- Total Orders
select count(*) as Total_Orders from f_sales;

-- Total Sales Revenue 
Select sum(Price * Quantity_on_Hand) as Total_sales_Revenue from f_inventory_adjusted;

-- Stock on hand
select sum(Quantity_on_Hand) as Stock_On_Hand from f_inventory_adjusted;

-- On-Time delivery %

SELECT 
ROUND(
SUM(CASE WHEN Quantity_On_Hand > 0 THEN 1 ELSE 0 END) 
* 100.0 / COUNT(*), 
2
) AS On_Time_Delivery_Percentage
FROM f_inventory_adjusted;

-- Average Delay Days 
SELECT 
AVG(Fiscal_day_of_year) AS Average_Delay_Days
FROM calendar;

-- Fill Rate 
SELECT 
ROUND(
(
SUM(
CASE 
WHEN Quantity_On_Hand > 0 
THEN 1 
ELSE 0 
END
) * 100.0
) / COUNT(*), 2
) AS Fill_Rate
FROM f_inventory_adjusted;

-- Inventory Value Analysis
SELECT 
ROUND(SUM(Quantity_on_Hand * `Cost Amount`),2) 
AS Total_Inventory_Value
FROM f_inventory_adjusted;

-- Top 10 Expensive Products
SELECT 
`Product Name`,
Price
FROM f_inventory_adjusted
ORDER BY Price DESC
LIMIT 10;

-- Low Stock Products
SELECT 
`Product Name`,
Quantity_on_Hand
FROM f_inventory_adjusted
ORDER BY Quantity_on_Hand ASC
LIMIT 10;

-- Product Family Analysis
SELECT 
`Product Family`,
COUNT(*) AS Total_Products
FROM f_inventory_adjusted
GROUP BY `Product Family`
ORDER BY Total_Products DESC;

-- Customer Region Analysis
SELECT 
`Cust Region`,
COUNT(*) AS Total_Customers
FROM customer
GROUP BY `Cust Region`
ORDER BY Total_Customers DESC;

-- Customer Gender Analysis
SELECT 
`Cust Gender`,
COUNT(*) AS Total_Customers
FROM customer
GROUP BY `Cust Gender`;

-- Age Group Analysis
SELECT 
`Age Group`,
COUNT(*) AS Total_Customers
FROM customer
GROUP BY `Age Group`
ORDER BY Total_Customers DESC;

-- Loyalty Program Analysis
SELECT 
`Loyalty Program`,
COUNT(*) AS Total_Customers
FROM customer
GROUP BY `Loyalty Program`;

-- Store Region Analysis
SELECT 
`Store Region`,
COUNT(*) AS Total_Stores
FROM d_store
GROUP BY `Store Region`
ORDER BY Total_Stores DESC;

-- Store Size Analysis
SELECT 
`Store Size`,
COUNT(*) AS Total_Stores
FROM d_store
GROUP BY `Store Size`;

-- Online Ordering Analysis
SELECT 
`Online Ordering`,
COUNT(*) AS Total_Stores
FROM d_store
GROUP BY `Online Ordering`;

-- Average Product Price
SELECT 
ROUND(AVG(Price),2) AS Avg_Product_Price
FROM f_inventory_adjusted;

-- Highest Inventory Products
SELECT 
`Product Name`,
Quantity_on_Hand
FROM f_inventory_adjusted
ORDER BY Quantity_on_Hand DESC
LIMIT 10;

-- Product Cost vs Price Analysis
SELECT 
`Product Name`,
Price,
`Cost Amount`,
(Price - `Cost Amount`) AS Profit_Margin
FROM f_inventory_adjusted
ORDER BY Profit_Margin DESC;

-- Complete Sales + Customer Analysis
SELECT 
c.`Cust Name`,
c.`Cust Region`,
f.`Transaction Type`,
f.`Purchase Method`
FROM f_sales f
JOIN customer c
ON f.`Cust Key` = c.`Cust Key`;

-- here are the some advanced analysis use with joins

-- Customer Purchase Analysis
SELECT 
c.`Cust Name`,
c.`Cust Region`,
COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
JOIN customer c
ON f.`Cust Key` = c.`Cust Key`
GROUP BY c.`Cust Name`, c.`Cust Region`
ORDER BY Total_Orders DESC
LIMIT 10;

-- Region Wise Customer Orders
SELECT 
c.`Cust Region`,
COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
JOIN customer c
ON f.`Cust Key` = c.`Cust Key`
GROUP BY c.`Cust Region`
ORDER BY Total_Orders DESC;

-- Store Wise Sales Orders
SELECT 
d.`Store Name`,
COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
JOIN d_store d
ON f.`Store Key` = d.`Store Key`
GROUP BY d.`Store Name`
ORDER BY Total_Orders DESC
LIMIT 10;

-- Purchase Method Analysis by Region
SELECT 
c.`Cust Region`,
f.`Purchase Method`,
COUNT(*) AS Total_Orders
FROM f_sales f
JOIN customer c
ON f.`Cust Key` = c.`Cust Key`
GROUP BY c.`Cust Region`, f.`Purchase Method`
ORDER BY Total_Orders DESC;

-- Fiscal Quarter Orders
SELECT 
c.`Fiscal Quarter`,
COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
JOIN `calendar`c
ON f.Date = c.Date
GROUP BY c.`Fiscal Quarter`
ORDER BY Total_Orders DESC;

-- Seasonal Order Analysis
SELECT 
c.Season,
COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
JOIN `calendar` c
ON f.Date = c.Date
GROUP BY c.Season
ORDER BY Total_Orders DESC;

-- Store Performance by Employees
SELECT 
d.`Store Name`,
d.`Number of Employees`,
COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
JOIN d_store d
ON f.`Store Key` = d.`Store Key`
GROUP BY d.`Store Name`, d.`Number of Employees`
ORDER BY Total_Orders DESC;

-- Monthly Order Trend
SELECT 
cal.`Fiscal Period`,
COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
JOIN `calendar` cal
ON f.Date = cal.Date
GROUP BY cal.`Fiscal Period`
ORDER BY cal.`Fiscal Period`;

-- Customer + Store Combined Analysis
SELECT 
c.`Cust Region`,
d.`Store Region`,
COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
JOIN customer c
ON f.`Cust Key` = c.`Cust Key`
JOIN d_store d
ON f.`Store Key` = d.`Store Key`
GROUP BY c.`Cust Region`, d.`Store Region`
ORDER BY Total_Orders DESC;

-- Complete Business Analysis Query
SELECT 
f.`Order Number`,
c.`Cust Name`,
c.`Cust Region`,
c.`Cust Gender`,
d.`Store Name`,
d.`Store Region`,
f.`Transaction Type`,
f.`Purchase Method`,
cal.Season,
cal.`Fiscal Quarter`
FROM f_sales f
JOIN customer c
ON f.`Cust Key` = c.`Cust Key`
JOIN d_store d
ON f.`Store Key` = d.`Store Key`
JOIN `calendar` cal
ON f.Date = cal.Date;

-- Customer Segmentation Analysis
SELECT 
c.`Cust Name`,
COUNT(f.`Order Number`) AS Total_Orders,
CASE
    WHEN COUNT(f.`Order Number`) >= 20 THEN 'High Value'
    WHEN COUNT(f.`Order Number`) >= 10 THEN 'Medium Value'
    ELSE 'Low Value'
END AS Customer_Category
FROM f_sales f
JOIN customer c
ON f.`Cust Key` = c.`Cust Key`
GROUP BY c.`Cust Name`
ORDER BY Total_Orders DESC;

-- Repeat vs New Customers
SELECT 
CASE
    WHEN Order_Count = 1 THEN 'New Customer'
    ELSE 'Repeat Customer'
END AS Customer_Type,
COUNT(*) AS Total_Customers
FROM (
    SELECT 
    `Cust Key`,
    COUNT(`Order Number`) AS Order_Count
    FROM f_sales
    GROUP BY `Cust Key`
) t
GROUP BY Customer_Type;

-- Customer Retention Analysis
SELECT 
c.`Cust Name`,
COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
JOIN customer c
ON f.`Cust Key` = c.`Cust Key`
GROUP BY c.`Cust Name`
HAVING COUNT(f.`Order Number`) > 5
ORDER BY Total_Orders DESC;

-- Product Profitability Analysis
SELECT 
`Product Name`,
Price,
`Cost Amount`,
(Price - `Cost Amount`) AS Profit_Margin
FROM f_inventory_adjusted
ORDER BY Profit_Margin DESC
LIMIT 10;





select * from f_sales;
desc f_sales;
desc f_inventory_adjusted;
select * from f_inventory_adjusted;
desc d_store;
desc d_geojson_us_counties;
desc customer;
desc calendar;
