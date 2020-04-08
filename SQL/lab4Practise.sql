-- Æwiczenie 1
--1

SELECT DISTINCT C.CompanyName, C.Phone
FROM Customers AS C
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
INNER JOIN Shippers AS S ON O.ShipVia = S.ShipperID
WHERE YEAR(ShippedDate) = 1997 AND S.CompanyName LIKE 'United Package'
ORDER BY C.CompanyName

--2

SELECT DISTINCT C.CompanyName, C.Phone
FROM Customers AS C
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON OD.ProductID = P.ProductID
INNER JOIN Categories AS CT ON P.CategoryID = CT.CategoryID
WHERE CategoryName LIKE 'Confections'

--3

SELECT DISTINCT C.CompanyName, C.Phone
FROM Customers AS C
WHERE C.CustomerID NOT IN(
	SELECT C.CustomerID
	FROM Customers AS C
	INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P ON OD.ProductID = P.ProductID
	INNER JOIN Categories AS CT ON P.CategoryID = CT.CategoryID
	WHERE CategoryName LIKE 'Confections')

-- Æwiczenie 2
--1

SELECT P.ProductID, ProductName, MAX(Quantity) AS Max
FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
GROUP BY P.ProductID, ProductName
ORDER BY P.ProductID

--2

SELECT ProductID, ProductName
FROM Products
WHERE UnitPrice < (
	SELECT AVG(UnitPrice)
	FROM Products)

--3

SELECT ProductID, ProductName
FROM Products AS P
WHERE UnitPrice < (
	SELECT AVG(UnitPrice)
	FROM Products
	WHERE CategoryID = P.CategoryID)

--4

SELECT ProductName, UnitPrice, 
	(SELECT AVG(UnitPrice)
	FROM Products) AS AvgPrice,
	abs(UnitPrice - (SELECT AVG(UnitPrice)
				FROM Products)) AS Difference
FROM Products

--5

SELECT CategoryName, ProductName, UnitPrice, 
	(SELECT AVG(UnitPrice)
	FROM Products
	WHERE P.CategoryID = CategoryID) AS AvgPrice,
	abs(UnitPrice - (SELECT AVG(UnitPrice)
					FROM Products
					WHERE P.CategoryID = CategoryID)) AS Difference
FROM Products AS P
INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID

-- Æwiczenie 3
--1

SELECT SUM(UnitPrice*Quantity*(1-Discount)) + 
	(SELECT Freight FROM Orders AS O WHERE O.OrderID = 10250)
FROM [Order Details] AS OD
WHERE OD.OrderID = 10250

--2

SELECT OD.OrderID, SUM(UnitPrice*Quantity*(1-Discount)) + 
	(SELECT Freight 
	FROM Orders AS O 
	WHERE O.OrderID = OD.OrderID)
FROM [Order Details] AS OD
GROUP BY OD.OrderID

--3

SELECT C.CompanyName
FROM Customers AS C
WHERE C.CustomerID NOT IN 
	(SELECT CustomerID
	FROM Orders
	WHERE YEAR(OrderDate)=1997)

--4

SELECT ProductID, COUNT(DISTINCT CustomerID)
FROM [Order Details] AS OD
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
GROUP BY ProductID
HAVING COUNT(CustomerID) > 1

-- Æwiczenie 4
 --1

 SELECT E.FirstName, E.LastName, 
	(SELECT SUM(UnitPrice*Quantity*(1-Discount))
	FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE O.EmployeeID = E.EmployeeID)
	+ 
	(SELECT SUM(Freight)
	FROM Orders AS O
	WHERE O.EmployeeID = E.EmployeeID)
 FROM Employees AS E
 
 --2

 SELECT TOP 1 E.FirstName, E.LastName, 
	(SELECT SUM(UnitPrice*Quantity*(1-Discount))
	FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE O.EmployeeID = E.EmployeeID AND YEAR(OrderDate) = 1997)
	+ 
	(SELECT SUM(Freight)
	FROM Orders AS O
	WHERE O.EmployeeID = E.EmployeeID AND YEAR(OrderDate) = 1997) AS total
 FROM Employees AS E
 ORDER BY 3 DESC
 
 --3a

 SELECT DISTINCT E.FirstName, E.LastName, 
	(SELECT SUM(UnitPrice*Quantity*(1-Discount))
	FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE O.EmployeeID = E.EmployeeID)
	+ 
	(SELECT SUM(Freight)
	FROM Orders AS O
	WHERE O.EmployeeID = E.EmployeeID)
 FROM Employees AS E
 INNER JOIN Employees AS ES ON ES.ReportsTo = E.EmployeeID
 
 --3b

 SELECT DISTINCT E.FirstName, E.LastName, 
	(SELECT SUM(UnitPrice*Quantity*(1-Discount))
	FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE O.EmployeeID = E.EmployeeID)
	+ 
	(SELECT SUM(Freight)
	FROM Orders AS O
	WHERE O.EmployeeID = E.EmployeeID)
 FROM Employees AS E
 LEFT OUTER JOIN Employees AS ES ON ES.ReportsTo = E.EmployeeID
 WHERE ES.EmployeeID IS NULL
 
 --4a

 SELECT DISTINCT E.FirstName, E.LastName, 
	(SELECT SUM(UnitPrice*Quantity*(1-Discount))
	FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE O.EmployeeID = E.EmployeeID)
	+ 
	(SELECT SUM(Freight)
	FROM Orders AS O
	WHERE O.EmployeeID = E.EmployeeID) AS total,
	(SELECT TOP 1 OrderDate
	FROM Orders AS O
	WHERE O.EmployeeID = E.EmployeeID
	ORDER BY OrderDate DESC) AS lastOrder
 FROM Employees AS E
 INNER JOIN Employees AS ES ON ES.ReportsTo = E.EmployeeID
 
 --4b

 SELECT DISTINCT E.FirstName, E.LastName, 
	(SELECT SUM(UnitPrice*Quantity*(1-Discount))
	FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE O.EmployeeID = E.EmployeeID)
	+ 
	(SELECT SUM(Freight)
	FROM Orders AS O
	WHERE O.EmployeeID = E.EmployeeID) AS total,
	(SELECT TOP 1 OrderDate
	FROM Orders AS O
	WHERE O.EmployeeID = E.EmployeeID
	ORDER BY OrderDate DESC) AS lastOrder
 FROM Employees AS E
 LEFT OUTER JOIN Employees AS ES ON ES.ReportsTo = E.EmployeeID
 WHERE ES.EmployeeID IS NULL