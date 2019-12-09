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

--4 Klienci, którzy nie zamówili nigdy nic z kategorii 'Seafood' w trzech wersjach

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

SELECT c.CompanyName
FROM Customers c
except
SELECT c.CompanyName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Categories ct ON p.CategoryID = ct.CategoryID AND CategoryName LIKE 'Seafood'

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

--10 Wypisz klientow, ktorzy w lipcu 1997 roku zamowili tylko produkty z kategorii 'Seafood', podaj sume wartosci ich zamowien z tego okresu

SELECT c.companyName, 
	(SELECT SUM(ord.UnitPrice*ord.Quantity*(1-ord.Discount)) 
	FROM [Order Details] ord
	INNER JOIN Orders orders ON orders.orderID = ord.OrderID
	WHERE orders.CustomerID = c.CustomerID AND YEAR(orders.OrderDate)=1997 AND MONTH(orders.OrderDate)=6) sum
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON p.ProductID = od.ProductID
INNER JOIN Categories ct ON ct.CategoryID = p.CategoryID
WHERE ct.CategoryName LIKE 'Seafood' AND YEAR(o.OrderDate)=1997 AND MONTH(o.OrderDate)=6
except
SELECT c.companyName,
	(SELECT SUM(ord.UnitPrice*ord.Quantity*(1-ord.Discount)) 
	FROM [Order Details] ord
	INNER JOIN Orders orders ON orders.orderID = ord.OrderID
	WHERE orders.CustomerID = c.CustomerID AND YEAR(orders.OrderDate)=1997 AND MONTH(orders.OrderDate)=6) sum
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON p.ProductID = od.ProductID
INNER JOIN Categories ct ON ct.CategoryID = p.CategoryID
WHERE ct.CategoryName <> 'Seafood' AND YEAR(o.OrderDate)=1997 AND MONTH(o.OrderDate)=6

--11 Kateogoria, ktora w grudniu 1997 roku byla obsluzona wylacznie przez United Package

SELECT ct.CategoryName
FROM Categories ct
INNER JOIN Products p ON p.CategoryID = ct.CategoryID
INNER JOIN [Order Details] od ON od.ProductID = od.ProductID
INNER JOIN Orders o ON o.OrderID = od.OrderID
INNER JOIN Shippers s ON s.ShipperID = o.ShipVia
WHERE s.CompanyName LIKE 'United Package' AND YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate)=12
except
SELECT ct.CategoryName
FROM Categories ct
INNER JOIN Products p ON p.CategoryID = ct.CategoryID
INNER JOIN [Order Details] od ON od.ProductID = od.ProductID
INNER JOIN Orders o ON o.OrderID = od.OrderID
INNER JOIN Shippers s ON s.ShipperID = o.ShipVia
WHERE s.CompanyName <> 'United Package' AND YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate)=12

--12 Wybierz klientow, ktorzy kupili przedmioty wylacznie z jednej kategorii w marcu 1997 i wypisz nazwe tej kategorii

SELECT c.companyName
FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
INNER JOIN Products p ON p.ProductID = od.ProductID
WHERE YEAR(o.OrderDate)=1997 AND MONTH(o.OrderDate)=3
GROUP BY c.CompanyName
HAVING COUNT(DISTINCT p.CategoryID) = 1
ORDER BY 1

--13 Nazwy dostawcow ktorzy dostarzcyli produkty w dniu 23/05/1997 oraz jesli obslugiwali te zamowienia pracownicy, ktorzy nie maja podwladnych to wypisz ich imie i nazwisko

SELECT s.companyName, IIF(es.employeeID IS NULL,e.lastname + ' ' + e.firstname,'null') Employee
FROM Employees e
INNER JOIN Orders o ON o.EmployeeID = e.EmployeeID
INNER JOIN Shippers s ON s.ShipperID = o.ShipVia
LEFT OUTER JOIN Employees es ON es.ReportsTo = e.EmployeeID
WHERE o.OrderDate = '1997-05-23'

--14 Dla kazdego pracownika wypisz wartosc zamowien osbluzonych przez niego w 1997 roku, dodatkowo wypisz wartosc zamowien dla poszczegolnych klientow i dla poszczegolmych zamowien

SELECT e.firstName + ' ' + e.lastName employee, c.CompanyName, o.OrderID, SUM(UnitPrice*Quantity*(1-Discount)) total
FROM Employees e
INNER JOIN Orders o ON o.EmployeeID = e.EmployeeID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY e.firstName + ' ' + e.lastName, c.CompanyName, o.OrderID WITH ROLLUP
ORDER BY 1,2,3

--15 Wypisz wszystkich klientow, ktorzy nie kupili produktow z kategorii 'Confections' w 1996 roku, ktore byly tansze od sredniej ceny produktow z tej kategorii

SELECT c.companyName
FROM Customers c
WHERE c.CustomerID NOT IN 
	(SELECT o.CustomerID
	FROM Orders o
	INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
	INNER JOIN Products p ON p.ProductID = od.ProductID
	INNER JOIN Categories ct ON ct.CategoryID = p.CategoryID
	WHERE YEAR(o.OrderDate)=1996 AND ct.CategoryName LIKE 'Confections' AND p.UnitPrice < (SELECT AVG(pp.UnitPrice)
																							FROM Products pp
																							WHERE pp.CategoryID = p.CategoryID))

--16 Dla kazdego dostawcy wyswietl sumaryczna wartosc dokonanych zamowien w okresie 1996-1998. Podziel informacje na lata i miesiace.

SELECT s.companyName, YEAR(o.orderDate) year, MONTH(o.orderDate) month, SUM(UnitPrice*Quantity*(1-Discount)) total
FROM Shippers s
INNER JOIN Orders o ON s.ShipperID = o.ShipVia
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE YEAR(OrderDate) BETWEEN 1996 AND 1998
GROUP BY s.CompanyName, YEAR(o.orderDate), MONTH(o.orderDate)													
ORDER BY 1,2,3