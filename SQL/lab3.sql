--11

SELECT SUM(UnitPrice*Quantity*(1-DISCOUNT))
FROM [Order Details]
WHERE OrderID=10250

--12

SELECT OrderID, MAX(UnitPrice)
FROM [Order Details]
GROUP BY OrderID
ORDER BY MAX(UnitPrice)

--13

SELECT OrderID, MAX(UnitPrice) AS 'MAX', MIN(UnitPrice) AS 'MIN'
FROM [Order Details]
GROUP BY OrderID

--14

SELECT AVG(diff) FROM (
 SELECT MAX(UnitPrice)-MIN(UnitPrice) AS diff
 FROM [Order Details]
 GROUP BY OrderID
) AS Q1

--15

SELECT SupplierID, COUNT(DISTINCT OrderID)
FROM [Order Details]
INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
GROUP BY SupplierID

--15a

SELECT ShipperID, COUNT(OrderID)
FROM Shippers
INNER JOIN Orders ON Shippers.ShipperID = Orders.ShipVia
GROUP BY ShipperID

--16 

SELECT TOP 1 SupplierID, COUNT(DISTINCT [Order Details].OrderID)
FROM [Order Details]
INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
INNER JOIN Orders ON [Order Details].OrderID=Orders.OrderID
WHERE YEAR(ShippedDate)=1997
GROUP BY SupplierID
ORDER BY COUNT(DISTINCT [Order Details].OrderID) DESC

--16a

SELECT TOP 1 ShipperID, COUNT(OrderID)
FROM Shippers
INNER JOIN Orders ON Shippers.ShipperID = Orders.ShipVia
WHERE YEAR(ShippedDate)=1997
GROUP BY ShipperID
ORDER BY COUNT(OrderID) DESC

--17

SELECT OrderID, COUNT(ProductID)
FROM [Order Details]
GROUP BY OrderID
HAVING COUNT(ProductID)>5

--18

SELECT CustomerID, COUNT(OrderID), SUM(Freight)
FROM Orders
WHERE YEAR(ShippedDate)=1998
GROUP BY CustomerID
HAVING COUNT(OrderID)>8
ORDER BY SUM(Freight) DESC