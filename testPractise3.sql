-- 1 Najczesciej wybierana kategoria w 1997 roku dla kazdego klienta

SELECT c.CompanyName,
		( SELECT TOP 1 CategoryName
		FROM Orders o
		INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
		INNER JOIN Products p ON od.ProductID = p.ProductID
		INNER JOIN Categories ct ON p.CategoryID = ct.CategoryID
		WHERE o.CustomerID = c.CustomerID AND YEAR (o.OrderDate) = 1997
		GROUP BY ct.CategoryName
		ORDER BY COUNT(*) DESC) category
FROM Customers c

--2 Podzial Shippers na Company, year, month, sum freight

SELECT s.CompanyName, YEAR (o.OrderDate) year, MONTH (o.OrderDate) month, SUM(o.freight) freight
FROM Shippers s
INNER JOIN Orders o ON s.ShipperID = o.ShipVia
GROUP BY s.CompanyName, YEAR(o.OrderDate), MONTH (o.OrderDate)
ORDER BY s.CompanyName, YEAR(o.OrderDate), MONTH (o.OrderDate)

--3 Zamówienia z Freight wiêkszym ni¿ AVG danego roku

SELECT o.OrderID, o.Freight, (SELECT AVG(ord.Freight) FROM Orders ord WHERE YEAR(o.OrderDate) = YEAR(ord.OrderDate))
FROM Orders o
WHERE o.Freight > (SELECT AVG(ord.Freight)
					FROM Orders ord
					WHERE YEAR(o.OrderDate) = YEAR(ord.OrderDate)
					)
ORDER BY 1

SELECT o.OrderID
FROM Orders o, Orders ord
WHERE YEAR(o.OrderDate) = YEAR(ord.OrderDate)
GROUP BY o.OrderID, o.Freight
HAVING o.freight > AVG (ord.freight)

--4 Klienci, którzy nie zamówili nigdy nic z kategorii 'Seafood'

SELECT c.CompanyName
FROM Customers c
WHERE c.CustomerID NOT IN 
	(SELECT CustomerID
	FROM Orders o
	INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
	INNER JOIN Products p ON od.ProductID = p.ProductID
	INNER JOIN Categories ct ON p.CategoryID = ct.CategoryID
	WHERE CategoryName LIKE 'Seafood')

SELECT cm.CompanyName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Categories ct ON p.CategoryID = ct.CategoryID AND CategoryName LIKE 'Seafood'
RIGHT OUTER JOIN Customers cm ON cm.CustomerID = c.CustomerID
WHERE C.CustomerID IS NULL

--5 Wybierz kategorie, ktora w 1997 roku najwiecej zarobila

SELECT TOP 1 c.categoryName, SUM(od.UnitPrice * Quantity * (1-Discount)) total
FROM Categories c
INNER JOIN Products p ON p.CategoryID = c.CategoryID
INNER JOIN [Order Details] od ON od.ProductID = p.ProductID
INNER JOIN Orders o ON o.OrderID = od.OrderID AND YEAR (OrderDate) = 1997
GROUP BY c.categoryName
ORDER BY 2 DESC

--6 Dane pracownika, najczêstszy dostawca, pracownicy bez podw³adnych

SELECT e.firstName, e.lastName, 
	(SELECT TOP 1 s.companyName
	FROM Shippers s
	INNER JOIN Orders o ON o.ShipVia = s.ShipperID
	WHERE o.EmployeeID = e.EmployeeID
	GROUP BY s.CompanyName
	ORDER BY COUNT(*) DESC)
FROM Employees e
LEFT OUTER JOIN Employees es ON es.ReportsTo = e.EmployeeID
WHERE es.EmployeeID IS NULL

--7 Nazwy firm (Suppliers.CompanyName), ktorych produktow nie dostarczal przewoznik o nazwie "United Package" w marcu 1997

SELECT s.companyName
FROM Suppliers s
WHERE s.SupplierID NOT IN 
	( SELECT p.SupplierID
	FROM Products p
	INNER JOIN [Order Details] od ON p.productID = od.ProductID
	INNER JOIN Orders o ON o.OrderID = od.OrderID AND YEAR(OrderDate) = 1997 AND MONTH (OrderDate)=3
	INNER JOIN Shippers sp ON sp.ShipperID = o.ShipVia AND sp.CompanyName LIKE 'United Package')
ORDER BY 1

SELECT sup.companyName
FROM Suppliers s
INNER JOIN Products p ON s.SupplierID = p.SupplierID
INNER JOIN [Order Details] od ON p.productID = od.ProductID
INNER JOIN Orders o ON o.OrderID = od.OrderID AND YEAR(OrderDate) = 1997 AND MONTH (OrderDate)=3
INNER JOIN Shippers sp ON sp.ShipperID = o.ShipVia AND sp.CompanyName LIKE 'United Package'
RIGHT OUTER JOIN Suppliers sup ON sup.SupplierID = s.SupplierID
WHERE s.SupplierID IS NULL

--8 Podaj nazwy klientow, ktorzy byli obslugiwani tylko przez jednego pracownika

SELECT c.companyName
FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName
HAVING COUNT(DISTINCT o.employeeID) = 1
ORDER BY 1

--9 Dla kazdego produktu podaj jego nazwe, kategorie, cene, srednia cene produktow z danej kategorii, roznice miedzy cena tego produktu a ta srednia i sume wartosci zamowien tego produktu z jakiegos miesiaca w 1997 roku

SELECT DISTINCT p.productName, CategoryName, p.UnitPrice, 
	(SELECT AVG(pr.unitPrice)
	FROM Products pr
	WHERE pr.CategoryID = p.CategoryID) avg,
	abs(p.UnitPrice - (SELECT AVG(pr.unitPrice)
	FROM Products pr
	WHERE pr.CategoryID = p.CategoryID)) difference,
	(SELECT SUM(odd.UnitPrice*odd.Quantity*(1-odd.Discount))
	FROM [Order Details] odd 
	INNER JOIN Orders ord ON ord.OrderID = odd.OrderID
	WHERE odd.ProductID = p.ProductID AND YEAR(ord.OrderDate)=1997) sum

FROM Products p
INNER JOIN [Order Details] od ON od.ProductID = p.ProductID
INNER JOIN Categories c ON c.CategoryID = p.CategoryID
ORDER BY 1