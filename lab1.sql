--1

SELECT CompanyName, Address
FROM Customers
WHERE City LIKE 'London'

--2

SELECT CompanyName, Address
FROM Customers
WHERE City LIKE 'London' OR City LIKE 'Madrid'

--3

SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice>40

--4

SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice>40
ORDER BY UnitPrice

--5

SELECT COUNT(UnitPrice)
FROM Products
WHERE UnitPrice>40

--6

SELECT COUNT(UnitPrice)
FROM Products
WHERE UnitPrice>40 AND UnitsInStock>100

--7

SELECT COUNT(CategoryID)
FROM Products
WHERE UnitPrice>40 AND UnitsInStock>100 AND CategoryID BETWEEN 2 AND 3

--8

SELECT ProductName, UnitPrice
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE CategoryName LIKE 'Seafood'

--9

SELECT COUNT(BirthDate)
FROM Employees
WHERE BirthDate<'1960' AND City LIKE 'Lodon'

--10

SELECT TOP 5 *
FROM Employees
ORDER BY BirthDate

--11

SELECT COUNT(BirthDate)
FROM Employees
WHERE (BirthDate BETWEEN '1950-01-01' AND '1955-12-31') OR ( (BirthDate BETWEEN '1958-01-01' AND '1960-12-31') AND City LIKE 'London')

--12

SELECT *
FROM Products
WHERE Discontinued=0

--13

SELECT OrderID, CustomerID
FROM Orders
WHERE OrderDate < '1996-09-01'

--14

SELECT *
FROM Customers
WHERE CompanyName LIKE '%the%'

--15

SELECT *
FROM Customers
WHERE CompanyName LIKE '[BW]%'

--16

SELECT *
FROM Products
WHERE ProductName LIKE 'C%' OR (ProductID<40 AND UnitPrice>20)

--17a

SELECT CustomerID, YEAR(OrderDate) AS 'YEAR', SUM(UnitPrice*Quantity*(1-Discount)) AS 'Sale'
FROM Orders, [Order Details]
WHERE Orders.OrderID = [Order Details].OrderID
Group BY YEAR(OrderDate), CustomerID
ORDER BY CustomerID

--17b

SELECT YEAR(OrderDate) AS 'YEAR', SUM(UnitPrice*Quantity*(1-Discount)) AS 'Sale'
FROM Orders, [Order Details]
WHERE Orders.OrderID = [Order Details].OrderID
Group BY YEAR(OrderDate)

--18

SELECT SUM(Quantity), YEAR(OrderDate) AS 'YEAR', SUM(UnitPrice*Quantity*(1-Discount)) AS 'Sale'
FROM Orders, [Order Details]
WHERE Orders.OrderID = [Order Details].OrderID
Group BY YEAR(OrderDate)

--19a

SELECT SUM(Quantity), YEAR(OrderDate) AS 'YEAR',DATEPART(QUARTER, OrderDate) AS [Quarter], SUM(UnitPrice*Quantity*(1-Discount)) AS 'Sale'
FROM Orders, [Order Details]
WHERE Orders.OrderID = [Order Details].OrderID
Group BY YEAR(OrderDate), DATEPART(QUARTER, OrderDate)
ORDER BY 2,3

--19b

SELECT SUM(Quantity), YEAR(OrderDate) AS 'YEAR',(DATEPART(QUARTER, OrderDate)+1)/2 AS [SEMESTER], SUM(UnitPrice*Quantity*(1-Discount)) AS 'Sale'
FROM Orders, [Order Details]
WHERE Orders.OrderID = [Order Details].OrderID
Group BY YEAR(OrderDate), DATEPART(QUARTER, OrderDate)
ORDER BY 2,3

--20

SELECT *
FROM Suppliers
WHERE HomePage IS NULL AND Fax IS NULL AND (Country LIKE 'Germany' OR Country LIKE 'USA')

--21

SELECT COUNT(QuantityPerUnit)
FROM Products
WHERE QuantityPerUnit LIKE '%bottle%' OR QuantityPerUnit LIKE '%glass%'

--22

SELECT Top 1 CategoryID
FROM Products
GROUP BY CategoryID
ORDER BY COUNT(ProductName) DESC

--23

SELECT CategoryID, SUM(UnitsInStock)
FROM Products
GROUP BY CategoryID
ORDER BY CategoryID