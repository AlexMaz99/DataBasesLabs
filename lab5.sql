--1

SELECT DISTINCT C.CompanyName, C.Phone
FROM Customers AS C
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
INNER JOIN Shippers AS S ON S.ShipperID = O.ShipVia
WHERE YEAR(ShippedDate)=1997 AND S.CompanyName LIKE 'United Package'

--2

SELECT DISTINCT C.CompanyName, C.Phone
FROM Customers AS C
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON OD.ProductID = P.ProductID
INNER JOIN Categories AS CG ON P.CategoryID = CG.CategoryID
WHERE CategoryName LIKE 'Confections'

--3

SELECT DISTINCT C.CompanyName, C.Phone
FROM Customers AS C
WHERE C.CustomerID NOT IN (
	SELECT C.CustomerID
	FROM Customers AS C
	INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P ON OD.ProductID = P.ProductID
	INNER JOIN Categories AS CG ON P.CategoryID = CG.CategoryID
	WHERE CategoryName LIKE 'Confections'
	)

--4 

SELECT ProductID, MAX(Quantity) AS MAX
FROM [Order Details]
GROUP BY ProductID
ORDER BY ProductID

--5

SELECT ProductID
FROM Products
WHERE UnitPrice < (
	SELECT AVG(UnitPrice)
	FROM Products
	)

--6

SELECT t1.ProductName
FROM
	(SELECT ProductName, CategoryID, UnitPrice
	FROM Products) AS t1,

	(SELECT AVG(UnitPrice) AS srednia, CategoryID
	FROM Products
	GROUP BY CategoryID) AS t2

WHERE t1.CategoryID = t2.CategoryID AND t1.UnitPrice < t2.srednia
ORDER BY t1.ProductName

--7

SELECT ProductName, UnitPrice, 
	( SELECT AVG(UnitPrice) FROM Products), 
	UnitPrice - (SELECT AVG(UnitPrice) FROM Products)
FROM Products

--8

SELECT t1.ProductName,t1.CategoryName,t1.UnitPrice,t2.srednia, (t1.UnitPrice-t2.srednia)AS roznica 
FROM
	(SELECT Products.ProductName, Products.UnitPrice, Categories.CategoryName, Products.CategoryID
	FROM     Categories 
	INNER JOIN Products ON Categories.CategoryID = Products.CategoryID)
	AS t1,

	(SELECT Categories.CategoryName, Categories.CategoryID, AVG(Products.UnitPrice) AS srednia
	FROM     Categories 
	INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
	GROUP BY Categories.CategoryName, Categories.CategoryID)
	AS t2
WHERE t1.CategoryID=t2.CategoryID

--9

SELECT OD.OrderID, SUM(UnitPrice*Quantity*(1-Discount)) + 
	(SELECT Freight FROM Orders WHERE OrderID=10250)
FROM [Order Details] AS OD
WHERE OD.OrderID=10250
GROUP BY OD.OrderID

--10

SELECT OrderID,
(
	SELECT sum(UnitPrice * Quantity * (1 - Discount))
	FROM [Order Details]  AS OD
	WHERE OD.OrderID = O.OrderID
) + Freight as total

FROM Orders AS O

--11

SELECT CustomerID, CompanyName, Address  
FROM Customers
WHERE CustomerID NOT IN (
	SELECT CustomerID
	FROM Orders
	WHERE YEAR(OrderDate)=1997
	)

--12

SELECT ProductName, COUNT(O.CustomerID)
FROM Products
INNER JOIN [Order Details] AS OD ON Products.ProductID = OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
GROUP BY ProductName
HAVING COUNT(O.CustomerID) >=2

--13

SELECT FirstName, LastName, 
	((SELECT SUM(UnitPrice*Quantity*(1-DISCOUNT))
	FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE O.EmployeeID = E.EmployeeID
	)
	+
	(SELECT SUM(Freight)
	FROM Orders
	WHERE EmployeeID = E.EmployeeID
	))
	as total
FROM Employees AS E

--14a

SELECT DISTINCT E.FirstName, E.LastName, 
	((SELECT SUM(UnitPrice*Quantity*(1-DISCOUNT))
	FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE O.EmployeeID = E.EmployeeID
	)
	+
	(SELECT SUM(Freight)
	FROM Orders
	WHERE EmployeeID = E.EmployeeID
	))
	as total
FROM Employees AS E
INNER JOIN Employees AS ES ON ES.ReportsTo = E.EmployeeID

--14b

SELECT E.FirstName, E.LastName, 
	((SELECT SUM(UnitPrice*Quantity*(1-DISCOUNT))
	FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE O.EmployeeID = E.EmployeeID
	)
	+
	(SELECT SUM(Freight)
	FROM Orders
	WHERE EmployeeID = E.EmployeeID
	))
	as total
FROM Employees AS E
LEFT OUTER JOIN Employees AS ES ON ES.ReportsTo = E.EmployeeID
WHERE ES.EmployeeID IS NULL

--15

SELECT TOP 1 FirstName, LastName, 
	((SELECT SUM(UnitPrice*Quantity*(1-DISCOUNT))
	FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE O.EmployeeID = E.EmployeeID AND YEAR(O.OrderDate) = 1997
	)
	+
	(SELECT SUM(Freight)
	FROM Orders
	WHERE EmployeeID = E.EmployeeID AND YEAR(Orders.OrderDate) = 1997
	))
	as total
FROM Employees AS E
ORDER BY total DESC

--16a

SELECT DISTINCT E.FirstName, E.LastName, 
	((SELECT SUM(UnitPrice*Quantity*(1-DISCOUNT))
	FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE O.EmployeeID = E.EmployeeID
	)
	+
	(SELECT SUM(Freight)
	FROM Orders
	WHERE EmployeeID = E.EmployeeID
	))
	as total,
	(SELECT TOP 1 ShippedDate
	FROM Orders
	WHERE EmployeeID = E.EmployeeID
	ORDER BY ShippedDate DESC) as last
FROM Employees AS E
INNER JOIN Employees AS ES ON ES.ReportsTo = E.EmployeeID

--16b

SELECT TOP 1 FirstName, LastName, 

	((SELECT SUM(UnitPrice*Quantity*(1-DISCOUNT))
	FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE O.EmployeeID = E.EmployeeID AND YEAR(O.OrderDate) = 1997
	)

	+

	(SELECT SUM(Freight)
	FROM Orders
	WHERE EmployeeID = E.EmployeeID AND YEAR(Orders.OrderDate) = 1997
	))
	as total,

	(SELECT TOP 1 ShippedDate
	FROM Orders
	WHERE EmployeeID = E.EmployeeID
	ORDER BY ShippedDate DESC) as last

FROM Employees AS E
ORDER BY total DESC