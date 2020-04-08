--1

SELECT OrderID, UnitPrice, Quantity, UnitPrice*Quantity*(1-DISCOUNT) AS 'Wartoœæ', UnitPrice*1.15 AS 'New Price', UnitPrice*1.15*Quantity*(1-Discount) AS 'Nowa wartoœæ'
FROM [Order Details]

--2

SELECT Employees.TitleOfCourtesy + FirstName + ' ' + LastName + ', ur. ' + cast(BirthDate as varchar) + ', zatrudniony w dniu ' + cast(HireDate as varchar) + ', adres: ' + Address + ', miasto ' + City + ', kod ' + PostalCode + ', pañstwo ' + country
FROM Employees
ORDER BY BirthDate

--3 

SELECT TOP 3 'Pan/Pani '+FirstName+' '+LastName+', zatrudniony '+cast(HireDate as varchar)
FROM Employees
ORDER BY HireDate DESC

--4

SELECT COUNT(Region)
FROM Employees
WHERE Region IS NOT NULL

--5

SELECT AVG(UnitPrice)
FROM Products

--6

SELECT AVG(UnitPrice)
FROM Products
WHERE UnitsInStock>=30

--7

SELECT AVG(UnitPrice)
FROM Products
WHERE UnitsInStock > (
		SELECT AVG(UnitsInStock)
		FROM Products
)

--8

SELECT SUM(Quantity)
FROM [Order Details]
WHERE UnitPrice*(1-DISCOUNT)>30

--9

SELECT AVG(UnitPrice) AS 'Avg', MAX(UnitPrice) AS 'Max', MIN(UnitPrice) AS 'Min'
FROM Products
WHERE QuantityPerUnit LIKE '%bottle%'

--10

SELECT * 
FROM Products 
WHERE UnitPrice > (
	SELECT AVG (UnitPrice)
	FROM Products
)