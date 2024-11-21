USE MaxAB_Extended;
GO

--- Calculate total sales for each merchant Using CTE
;WITH Total_Sales AS (
    SELECT merchant_name, SUM(order_total) AS Total_Revenu
	FROM Orders o
	JOIN Merchants m 
	ON m.merchant_id = o.merchant_id
	GROUP BY merchant_name
)
SELECT merchant_name, Total_Revenu
FROM Total_Sales
WHERE Total_Revenu > 400;

--- Calculate the cumulative total sales for each merchant
SELECT merchant_name, order_date,
       SUM(order_total) OVER(PARTITION BY merchant_name ORDER BY order_date) AS cumulative_sales
FROM Orders o
Join Merchants m
ON m.merchant_id = o.merchant_id

-- Showing the total orders by merchant
SELECT merchant_name, Count (order_total) AS Total_Orders
FROM Orders o
Join Merchants m
ON m.merchant_id = o.merchant_id
GROUP BY merchant_name;

-- Orders Daily Trends Due in month 11
SELECT DAY(order_date) AS day, SUM(order_total) AS Total_Reve
FROM Orders
GROUP BY DAY(order_date)
ORDER BY Total_Reve desc

--Showing me top 5 merchant by monthly revenue
SELECT Top(5) merchant_name, SUM (order_total) AS Monthly_Revenue
FROM Orders o
JOIN Merchants m
ON m.merchant_id = o.merchant_id
WHERE order_date BETWEEN '2024-11-01' AND '2024-11-30'
GROUP BY merchant_name
ORDER BY Monthly_Revenue DESC 

-- AVG Order day by region 
SELECT region_name, AVG(DATEDIFF(DAY, order_date, delivery_date)) AS Avg_delivery_Day
FROM Orders o
JOIN Regions r
ON r.region_id = o.region_id
GROUP BY region_name

--- Calculate the moving average of orders
SELECT merchant_id, order_date, 
       AVG(order_total) OVER(ORDER BY order_date DESC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Avg_Orders
FROM Orders

-- Percentage of orders by online Payment Vs Cash
SELECT payment_method, CONCAT(COUNT (order_id) * 100 / (SELECT COUNT(*) FROM Orders), '%') As Percentage
FROM Orders
GROUP BY payment_method

-- Identify merchants who have not placed orders in the last 30 days?
SELECT merchant_id
FROM Merchants 
WHERE merchant_id NOT IN (SELECT merchant_id FROM Orders WHERE order_date >= DATEADD(DAY, -30, GETDATE()))

---- Store operational performance
SELECT merchant_name, SUM(order_total) AS Total_Orders
FROM Orders o
JOIN Merchants m
ON m.merchant_id = o.merchant_id
GROUP BY merchant_name
HAVING SUM(order_total) < 1000 

--- Identify geographic areas that need improvement
SELECT r.region_name, SUM(o.order_total) AS total_sales
FROM Orders o
JOIN Regions r ON o.region_id = r.region_id
GROUP BY r.region_name
HAVING SUM(o.order_total) < 1000;

--- Times of increase or decrease in orders
SELECT DATEPART(WEEKDAY, order_date)AS Day, COUNT(*) AS Count_Orders
FROM Orders
GROUP BY DATEPART(WEEKDAY, order_date)
HAVING COUNT(*) >1

--- Find recent orders for each merchant
WITH LastOrders AS (
    SELECT merchant_id, order_date,
	ROW_NUMBER() OVER(PARTITION BY merchant_id ORDER BY order_date) AS ROW_NUM 
	FROM Orders
)
SELECT merchant_id, order_date
FROM LastOrders
WHERE ROW_NUM >1

--- Calculate sales ranking for each merchant
SELECT merchant_id, order_total, 
       RANK() OVER(PARTITION BY merchant_id ORDER BY order_total DESC) AS merchant_Rank
FROM Orders;


-- SELECT Count(order_id) AS Total_Orders, 
SELECT SUM(order_total) AS Total_Sales
FROM Orders

SELECT TOP 5 * 
FROM Orders
WHERE region_id = 101; 

SELECT AVG(order_total) AS Mean_Order_Total
FROM Orders;


SELECT TOP 1 order_total AS Mode_Order_Total
FROM Orders
GROUP BY order_total
ORDER BY COUNT(*) DESC;

SELECT 
    region_id, 
    AVG(order_total) AS Mean_Order_Total,
    STDEV(order_total) AS Standard_Deviation,
    VAR(order_total) AS Variance
FROM Orders
GROUP BY region_id;



