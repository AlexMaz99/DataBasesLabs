--1 

SELECT ProductName, UnitPrice, Address
FROM Products
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE UnitPrice BETWEEN 20 AND 30

--2

SELECT ProductName, UnitsInStock
FROM Products
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE CompanyName LIKE 'Tokyo Traders'

--3

SELECT CompanyName, Address
FROM Customers
WHERE Customers.CustomerID NOT IN (
	SELECT Customers.CustomerID
	FROM Customers
	INNER JOIN Orders ON Customers.CustomerID=Orders.CustomerID
	WHERE YEAR(OrderDate)=1997
)

--4

SELECT CompanyName, Phone
FROM Suppliers
INNER JOIN Products ON Suppliers.SupplierID = Products.SupplierID
WHERE UnitsInStock=0

--5

SELECT ProductName, UnitPrice, Address, CategoryName
FROM Products
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE (UnitPrice BETWEEN 20 AND 30) AND (CategoryName LIKE 'Meat/Poultry')

--6

SELECT ProductName, UnitPrice, CompanyName
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE CategoryName LIKE 'Confections'

--7

SELECT DISTINCT Customers.CompanyName, Customers.Phone
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN Shippers ON Orders.ShipVia = Shippers.ShipperID
WHERE Shippers.CompanyName LIKE 'United Package' AND YEAR(Orders.OrderDate)=1997

--8

SELECT DISTINCT Customers.CompanyName, Customers.Phone
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE CategoryName LIKE 'Confections'