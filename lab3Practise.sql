-- Æwiczenie 1
--1

SELECT OD.OrderID, SUM(Quantity), C.CompanyName
FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
GROUP BY OD.OrderID, C.CompanyName


--2

SELECT OD.OrderID, SUM(Quantity), C.CompanyName
FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
GROUP BY OD.OrderID, C.CompanyName
HAVING SUM(Quantity) > 250


--3

SELECT OD.OrderID, SUM(UnitPrice*Quantity*(1-Discount)), C.CompanyName
FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
GROUP BY OD.OrderID, C.CompanyName


--4

SELECT OD.OrderID, SUM(UnitPrice*Quantity*(1-Discount)), C.CompanyName
FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
GROUP BY OD.OrderID, C.CompanyName
HAVING SUM(Quantity) > 250


--5

SELECT OD.OrderID, SUM(UnitPrice*Quantity*(1-Discount)), C.CompanyName, E.FirstName, E.LastName
FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
INNER JOIN Employees AS E ON O.EmployeeID = E.EmployeeID
GROUP BY OD.OrderID, C.CompanyName, E.FirstName, E.LastName
HAVING SUM(Quantity) > 250


-- Æwiczenie 2
--1

SELECT CategoryName, SUM(Quantity)
FROM Categories AS C
INNER JOIN Products AS P ON C.CategoryID = P.CategoryID
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
GROUP BY CategoryName


--2

SELECT CategoryName, SUM(OD.UnitPrice*Quantity*(1-Discount))
FROM Categories AS C
INNER JOIN Products AS P ON C.CategoryID = P.CategoryID
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
GROUP BY CategoryName


--3a

SELECT CategoryName, SUM(OD.UnitPrice*Quantity*(1-Discount)) AS total
FROM Categories AS C
INNER JOIN Products AS P ON C.CategoryID = P.CategoryID
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
GROUP BY CategoryName
ORDER BY total


--3b

SELECT CategoryName, SUM(OD.UnitPrice*Quantity*(1-Discount))
FROM Categories AS C
INNER JOIN Products AS P ON C.CategoryID = P.CategoryID
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
GROUP BY CategoryName
ORDER BY SUM(Quantity)

-- Æwiczenie 3
--1

SELECT S.CompanyName, COUNT(OrderID)
FROM Shippers AS S
INNER JOIN Orders AS O ON S.ShipperID = O.ShipVia
WHERE YEAR(ShippedDate) = 1997
GROUP BY S.CompanyName, S.ShipperID


--2

SELECT TOP 1 S.CompanyName, COUNT(OrderID)
FROM Shippers AS S
INNER JOIN Orders AS O ON S.ShipperID = O.ShipVia
WHERE YEAR(ShippedDate) = 1997
GROUP BY S.CompanyName, S.ShipperID
ORDER BY 2 DESC


--3

SELECT TOP 1 FirstName, LastName, COUNT(OrderID)
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
WHERE YEAR(ShippedDate)=1997
GROUP BY FirstName, LastName
ORDER BY 3 DESC


-- Æwiczenie 4
--1

SELECT FirstName, LastName, SUM(UnitPrice*Quantity*(1-Discount))
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY FirstName, LastName


--2

SELECT TOP 1 FirstName, LastName, SUM(UnitPrice*Quantity*(1-Discount))
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE YEAR(OrderDate) = 1997
GROUP BY FirstName, LastName
ORDER BY 3 DESC


--3a

SELECT E.LastName, E.FirstName, SUM(UnitPrice*Quantity*(1-Discount)) AS total
FROM Employees AS E 
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID 
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID 
INNER JOIN Employees AS ES ON ES.ReportsTo = E.EmployeeID
GROUP BY E.LastName, E.FirstName, E.EmployeeID

--3b

SELECT E.LastName, E.FirstName, E.EmployeeID, SUM(UnitPrice*Quantity*(1 - Discount)) AS total
FROM Employees AS E 
LEFT OUTER JOIN Employees AS ES ON ES.ReportsTo = E.EmployeeID 
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID 
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID 
WHERE ES.EmployeeID IS NULL                      
GROUP BY E.LastName, E.FirstName, E.EmployeeID