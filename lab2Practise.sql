-- Æwiczenie 1
--1

SELECT OrderID, SUM(UnitPrice * Quantity * (1-Discount)) AS Price
FROM [Order Details]
GROUP BY OrderID
ORDER BY OrderID DESC


--2

SELECT TOP 10 OrderID, SUM(UnitPrice * Quantity * (1-Discount)) AS Price
FROM [Order Details]
GROUP BY OrderID
ORDER BY OrderID DESC


--3 

SELECT TOP 10 WITH TIES OrderID, SUM(UnitPrice * Quantity * (1-Discount)) AS Price
FROM [Order Details]
GROUP BY OrderID
ORDER BY OrderID DESC


-- Æwiczenie 2
--1

SELECT ProductID, SUM(Quantity) AS Quantity
FROM [Order Details]
WHERE ProductID < 3
GROUP BY ProductID


--2

SELECT ProductID, SUM(Quantity) AS Quantity
FROM [Order Details]
GROUP BY ProductID


--3

SELECT OrderID, SUM(UnitPrice*Quantity*(1-Discount)), SUM(Quantity)
FROM [Order Details]
GROUP BY OrderID
HAVING SUM(Quantity)>250


-- Æwiczenie 3
--1

SELECT ProductID, OrderID, SUM(Quantity)
FROM [Order Details]
GROUP BY ProductID, OrderID
WITH ROLLUP


--2

SELECT ProductID, OrderID, SUM(Quantity)
FROM [Order Details]
WHERE ProductID = 50
GROUP BY ProductID, OrderID
WITH ROLLUP


--3 
/*
null jest wildcardem
*/

--4

SELECT
   CASE 
	  WHEN GROUPING(ProductID) = 1 THEN 'All products' 
      ELSE CONVERT(varchar, ProductID)
   END ProductID,
   CASE 
	  WHEN GROUPING(OrderID) = 1 THEN 'All orders' 
      ELSE CONVERT(varchar, OrderID)
   END OrderID,
   sum(Quantity) as number
FROM [Order Details]
GROUP BY ProductID, OrderID
WITH CUBE 