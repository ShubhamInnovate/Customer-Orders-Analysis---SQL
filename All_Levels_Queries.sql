--🔹 Easy Level (Basics & Aggregations)



--1.List all customers with their country and city.
SELECT CONCAT(FirstName,' ',LastName) as Name ,City, Country from P1_Customers;


--2.Get all products in the “Electronics” category.
SELECT ProductID, ProductName, UnitPrice 
FROM P1_Products
WHERE Category = 'Electronics';


--3.Find the total number of customers from India.
SELECT COUNT(*) AS Total_Indian_Customers
FROM P1_Customers
WHERE Country = 'India';

--4.Get the total number of orders placed.
SELECT COUNT(*) AS Total_Orders
FROM P1_Orders;


--5.Find the total sales amount (UnitPrice * Quantity) for all orders.
SELECT SUM(p.UnitPrice * o.Quantity) AS Total_Sales
FROM P1_Orders o
JOIN P1_Products p ON o.ProductID = p.ProductID;




--🔹 Medium Level (Joins, Group By, Conditions)

--1.List each customer with the products they purchased.
SELECT CONCAT(Firstname,' ',Lastname) as Name, ProductName From P1_Products p
JOIN P1_Orders o ON p.ProductID=o.ProductID
JOIN P1_Customers c ON c.CustomerID=o.CustomerID;


--2.Show total sales per country.
SELECT Country, SUM(Quantity*UnitPrice) as Total_Sales  FROM P1_Products p
JOIN P1_Orders o ON p.ProductID=o.ProductID
JOIN P1_Customers c ON c.CustomerID=o.CustomerID
GROUP BY Country
ORDER BY Total_Sales DESC;


--3.Find the average order value per customer.
SELECT CONCAT(Firstname,' ',Lastname) as Name,
       AVG(p.UnitPrice * o.Quantity) AS Avg_Order_Value
FROM P1_Orders o
JOIN P1_Customers c ON o.CustomerID = c.CustomerID
JOIN P1_Products p ON o.ProductID = p.ProductID
GROUP BY CONCAT(Firstname,' ',Lastname)
ORDER BY Avg_Order_Value DESC;


--4.List customers who have never placed an order.           
SELECT CONCAT(Firstname,' ',Lastname) as Name FROM P1_Customers c
LEFT JOIN P1_Orders o ON c.CustomerID=o.CustomerID
WHERE o.OrderID is NULL;


--5.Find the top 3 products by total quantity sold.
SELECT top 3 ProductName,SUM(Quantity) Total_QTY  FROM P1_Products p
JOIN P1_Orders  o ON p.ProductID=o.ProductID
GROUP BY ProductName
ORDER BY SUM(Quantity) DESC;




--🔹 Advanced Level (Window Functions, Subqueries, Date Analysis)

--1.Find the 2nd most expensive product.
SELECT ProductName, UnitPrice
FROM (
    SELECT ProductName, UnitPrice,
           DENSE_RANK() OVER (ORDER BY UnitPrice DESC) AS rnk
    FROM P1_Products
) x
WHERE rnk = 2;


--2.List the top 2 customers per country based on total spend.
SELECT * from
(
  SELECT CONCAT(Firstname,' ',Lastname) as Name,Country,SUM(Quantity*UnitPrice) as Total_Spend,
  DENSE_RANK() OVER(PARTITION BY Country ORDER BY SUM(Quantity*UnitPrice)) as RNK
  FROM P1_Customers c
  JOIN P1_Orders o ON c.CustomerID=o.CustomerID
  JOIN P1_Products p ON p.ProductID=o.ProductID
  GROUP BY CONCAT(Firstname,' ',Lastname),Country
) as x
WHERE RNK<=2;


--3.Find customers who spent above the average spending.

  SELECT CONCAT(Firstname,' ',Lastname) as Name,SUM(Quantity*UnitPrice) as Total_Spend 
    FROM P1_Customers c
    JOIN P1_Orders o ON c.CustomerID=o.CustomerID
    JOIN P1_Products p ON p.ProductID=o.ProductID
    GROUP BY CONCAT(Firstname,' ',Lastname)

HAVING SUM(Quantity*UnitPrice) > (SELECT AVG(Quantity*UnitPrice)  FROM
  (SELECT SUM(Quantity*UnitPrice) as Total_Spend FROM P1_Orders o 
   JOIN P1_Products p ON p.ProductID=o.ProductID
  ) as x
  ) ;


--4.Calculate the month-over-month sales growth.
WITH MonthlySales AS (
    SELECT FORMAT(OrderDate, 'yyyy-MM') AS MonthYear,
           SUM(p.UnitPrice * o.Quantity) AS TotalSales
    FROM P1_Orders o
    JOIN P1_Products p ON o.ProductID = p.ProductID
    GROUP BY FORMAT(OrderDate, 'yyyy-MM')
)
SELECT MonthYear, TotalSales,
       LAG(TotalSales) OVER (ORDER BY MonthYear) AS PrevMonthSales,
       (TotalSales - LAG(TotalSales) OVER (ORDER BY MonthYear)) * 100.0 /
       NULLIF(LAG(TotalSales) OVER (ORDER BY MonthYear),0) AS GrowthPercent
FROM MonthlySales;


--5.List all customers and classify them:   
--High Spender (> $1000 total spend)
--Medium Spender ($500–1000)
--Low Spender (< $500)
SELECT CONCAT(Firstname,' ',Lastname) as Name,SUM(Quantity*UnitPrice) as Total_Spend,
case 
WHEN SUM(Quantity*UnitPrice)>1000 THEN 'High Spender'
WHEN SUM(Quantity*UnitPrice)BETWEEN 500 and 1000 THEN 'Medium Spender'
ELSE 'Low Spender' end as Customer_Category
FROM P1_Customers c
JOIN P1_Orders o ON c.CustomerID=o.CustomerID
JOIN P1_Products p ON p.ProductID=o.ProductID
GROUP BY  CONCAT(Firstname,' ',Lastname)
ORDER BY Total_Spend;




--🔹 Expert Level

--1.Find the product category with the highest revenue.                   
SELECT TOP 1 Category,SUM(Unitprice*Quantity) as Revenue FROM P1_Products p
JOIN P1_Orders o ON p.ProductID=o.ProductID
GROUP BY Category
ORDER BY Revenue DESC;



--2.Show the running total of sales month by month.
WITH CTE as(
SELECT FORMAT(OrderDAte,'yyyy-MM') as MonthYear, SUM(Quantity*UnitPrice) as Sales FROM P1_Orders o
JOIN P1_Products p ON o.ProductID=p.ProductID
GROUP BY FORMAT(OrderDAte,'yyyy-MM')
)
SELECT MonthYear, Sales,((Sales-LAG(Sales) OVER(ORDER BY MonthYear))*100)/LAG(Sales) OVER(ORDER BY MonthYear) as x  FROM CTE



--3.Find orders where discount was applied and calculate total savings.
SELECT o.OrderID, c.FirstName, c.LastName, 
       p.ProductName, o.Quantity, o.Discount,
       (p.UnitPrice * o.Quantity * o.Discount) AS TotalSavings
FROM P1_Orders o
JOIN P1_Products p ON o.ProductID = p.ProductID
JOIN P1_Customers c ON o.CustomerID = c.CustomerID
WHERE o.Discount > 0
ORDER BY TotalSavings DESC;



--4.List all customers along with the number of different categories they purchased from.
SELECT c.CustomerID, CONCAT(Firstname,' ',Lastname) as Name, COUNT(DISTINCT p.Category) AS CategoriesBought
FROM P1_Orders o
JOIN P1_Customers c ON o.CustomerID = c.CustomerID
JOIN P1_Products p ON o.ProductID = p.ProductID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY CategoriesBought DESC;



--5.Find customers who bought products in 2022 Q1 but not in Q2.

With Q1 as
(
SELECT DISTINCT CustomerID FROM P1_Orders
WHERE OrderDate BETWEEN '2022-01-01' and '2022-03-31'
),
 Q2 as
(
SELECT DISTINCT CustomerID FROM P1_Orders
WHERE OrderDate BETWEEN '2022-04-01' and '2022-06-30'
)
SELECT q.CustomerID  FROM P1_Orders p
JOIN Q1  q ON p.CustomerID=q.CustomerID
WHERE p.CustomerID NOT IN (SELECT * FROM Q2);
