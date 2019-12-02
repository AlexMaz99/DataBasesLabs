--2015/2016
--1a 

USE library
SELECT M.lastname, M.firstname, A.street, A.city, A.state, iif(L.member_no is null , ISNULL(L.member_no,0), count(L.member_no))
FROM adult AS A
INNER JOIN member AS M ON A.member_no = M.member_no
LEFT OUTER JOIN loan AS L ON M.member_no = L.member_no
GROUP BY M.lastname, M.firstname, A.street, A.city, A.state, L.member_no

UNION

SELECT mj.lastname, mj.firstname, ja.street, ja.city, ja.state, iif(l.member_no is null , ISNULL(l.member_no,0), count(l.member_no))
FROM member as mj 
join juvenile as j on mj.member_no=j.member_no
join adult as ja on ja.member_no=j.adult_member_no
left outer join loan as l on l.member_no=mj.member_no
GROUP BY mj.lastname, mj.firstname, ja.street, ja.city, ja.state, l.member_no
ORDER BY iif(l.member_no is null , ISNULL(l.member_no,0), count(l.member_no)) DESC

--1b
USE library
SELECT M.lastname, M.firstname, A.street, A.city, A.state, 'adult', iif(L.member_no is null , ISNULL(L.member_no,0), count(L.member_no))
FROM adult AS A
INNER JOIN member AS M ON A.member_no = M.member_no
LEFT OUTER JOIN loan AS L ON M.member_no = L.member_no
GROUP BY M.lastname, M.firstname, A.street, A.city, A.state, L.member_no

UNION

SELECT mj.lastname, mj.firstname, ja.street, ja.city, ja.state,'juvenile', iif(l.member_no is null , ISNULL(l.member_no,0), count(l.member_no))
FROM member as mj 
join juvenile as j on mj.member_no=j.member_no
join adult as ja on ja.member_no=j.adult_member_no
left outer join loan as l on l.member_no=mj.member_no
GROUP BY mj.lastname, mj.firstname, ja.street, ja.city, ja.state, l.member_no
ORDER BY iif(l.member_no is null , ISNULL(l.member_no,0), count(l.member_no)) DESC

--2a

USE library
SELECT lastname, firstname
FROM member AS M
LEFT OUTER JOIN loan AS L ON M.member_no = L.member_no
LEFT OUTER JOIN loanhist AS LH ON LH.member_no = L.member_no
WHERE LH.member_no IS NULL AND L.member_no IS NULL

 --2b

USE library
SELECT M.lastname, M.firstname
FROM member as M
WHERE M.member_no not in 
		(SELECT member_no 
		FROM loan
		UNION
		SELECT member_no 
		FROM loanhist)
ORDER BY lastname, firstname

--3a

USE Northwind
SELECT O.OrderID, O.Freight
FROM Orders AS O, Orders AS O2
WHERE YEAR(O.OrderDate) = YEAR(O2.OrderDate)
GROUP BY O.OrderID, O.Freight
HAVING O.Freight > AVG(O2.Freight)

--3b

USE Northwind
SELECT O.OrderID
FROM Orders AS O
WHERE O.Freight > 
	(SELECT AVG(Freight) 
	FROM Orders
	WHERE YEAR(OrderDate) = YEAR(O.OrderDate))

--4a

SELECT ShipVia, SUM(Freight), YEAR(OrderDate), MONTH(OrderDate)
FROM Orders
GROUP BY ShipVia, YEAR(OrderDate), MONTH(OrderDate)

--4b

SELECT (SELECT S.ShipperID FROM Shippers AS S WHERE S.ShipperID = O.ShipVia), SUM(O.Freight), YEAR(O.OrderDate), MONTH(O.OrderDate)
FROM Orders AS O
GROUP BY O.ShipVia, YEAR(O.OrderDate), MONTH(O.OrderDate)

--5a

USE library
SELECT M.member_no, M.firstname, M.lastname
FROM member AS M
LEFT OUTER JOIN loanhist AS LH ON LH.member_no = M.member_no AND YEAR(LH.out_date)=2002
WHERE LH.member_no IS NULL

--5b

USE library
SELECT M.member_no, M.firstname, M.lastname
FROM member AS M
WHERE M.member_no NOT IN 
	(SELECT LH.member_no
	FROM loanhist AS LH
	WHERE YEAR(LH.in_date)=2002 AND LH.member_no = M.member_no)

--6a

USE Northwind
SELECT O.CustomerID, CompanyName, SUM(UnitPrice*Quantity*(1-Discount)+Freight)
FROM Orders AS O
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
GROUP BY O.CustomerID, CompanyName

--6b

USE Northwind
SELECT C.CustomerID, CompanyName, 
	(SELECT SUM(UnitPrice*Quantity*(1-Discount)+Freight) 
	FROM  [Order Details] AS OD
	INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
	WHERE C.CustomerID = O.CustomerID)
FROM Customers AS C

--7a

USE Northwind
SELECT P.ProductID, P.UnitPrice
FROM Products AS P, Products AS P2
WHERE P.CategoryID = P2.CategoryID
GROUP BY P.ProductID, P2.CategoryID, P.UnitPrice
HAVING P.UnitPrice >= AVG(P2.UnitPrice)
--7b

USE Northwind
SELECT ProductID, UnitPrice
FROM Products
WHERE UnitPrice >= 
	(SELECT AVG(UnitPrice)
	FROM Products AS P
	WHERE P.CategoryID = CategoryID)

--8a

SELECT TOP 1 LastName, FirstName, SUM(UnitPrice*Quantity*(1-Discount))
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE YEAR(OrderDate)=1997
GROUP BY LastName, FirstName
ORDER BY 3 DESC

--8b

SELECT TOP 1 LastName, FirstName, 
	(SELECT SUM(UnitPrice*Quantity*(1-Discount))
	FROM [Order Details] AS OD
	INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
	WHERE YEAR(OrderDate)=1997 AND E.EmployeeID = O.EmployeeID)
FROM Employees AS E
ORDER BY 3 DESC

--9

SELECT c.CompanyName, c.phone
FROM Customers AS c
WHERE c.CustomerID NOT IN
	(SELECT o.customerID
	FROM Orders AS o
	INNER JOIN [Order Details] AS od ON o.OrderID = od.OrderID
	INNER JOIN Products AS p ON p.ProductID = od.ProductID
	INNER JOIN Categories AS ct ON p.CategoryID = ct.CategoryID
	WHERE CategoryName LIKE 'Confections')

--2017/2018
--4a

SELECT c.CompanyName
FROM Customers AS c
WHERE c.CustomerID NOT IN
	(SELECT o.customerID
	FROM Orders AS o
	INNER JOIN [Order Details] AS od ON o.OrderID = od.OrderID
	INNER JOIN Products AS p ON p.ProductID = od.ProductID
	INNER JOIN Categories AS ct ON p.CategoryID = ct.CategoryID
	WHERE CategoryName LIKE 'Seafood')

--4b

SELECT CompanyName FROM Customers 
EXCEPT
SELECT c.CompanyName
FROM Customers AS c
INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] AS od ON o.OrderID = od.OrderID
INNER JOIN Products AS p ON p.ProductID = od.ProductID
INNER JOIN Categories AS ct ON p.CategoryID = ct.CategoryID
WHERE CategoryName LIKE 'Seafood'

--5

SELECT S.CompanyName, YEAR(OrderDate), MONTH(OrderDate), SUM(Freight)
FROM Shippers AS S
INNER JOIN Orders AS O ON S.ShipperID = O.ShipVia
GROUP BY S.CompanyName, YEAR(OrderDate), MONTH(OrderDate)
ORDER BY S.CompanyName, YEAR(OrderDate), MONTH(OrderDate)