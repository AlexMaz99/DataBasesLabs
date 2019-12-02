--1 Podaj wykaz wszystkich produktów, których cena jest mniejsza ni¿ œrednia cena produktu danej kategorii

USE Northwind
SELECT t1.ProductName
FROM
	(SELECT ProductName, CategoryID, UnitPrice
	FROM Products) AS t1,

	(SELECT AVG(UnitPrice) AS srednia, CategoryID
	FROM Products
	GROUP BY CategoryID) AS t2

WHERE t1.CategoryID = t2.CategoryID AND t1.UnitPrice < t2.srednia
ORDER BY t1.ProductName

--2 Dla ka¿dego produktu podaj jego nazwê kategorii, nazwê produktu, cenê, œredni¹ cenê wszystkich produktów danej kategorii oraz ró¿nicê miêdzy cen¹ produktu a œredni¹ cen¹ wszystkich produktów

USE Northwind
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

--3 Podaj ³¹czn¹ wartoœæ zamówieñ ka¿dego zamówienia (uwzglêdnij cenê za przesy³kê)

USE Northwind
SELECT OrderID,
(
	SELECT sum(UnitPrice * Quantity * (1 - Discount))
	FROM [Order Details]  AS OD
	WHERE OD.OrderID = O.OrderID
) + Freight as total

FROM Orders AS O

--4 Dla ka¿dego pracownika (imiê i nazwisko) podaj ³¹czn¹ wartoœæ zamówieñ obs³u¿onych przez tego pracownika (przy obliczaniu wartoœci zamówieñ uwzglêdnij cenê za przesy³kê), którzy nie maj¹ podw³adnych

USE Northwind
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

--5a Wyœwietl imiê, nazwisko, dane adresowe oraz iloœæ wypo¿yczonych ksi¹¿ek dla ka¿dego cz³onka biblioteki. Iloœæ wypo¿yczonych ksi¹¿ek nie mo¿e byæ nullem, co najwy¿ej zerem.

USE library
SELECT m.member_no, m.firstname, m.lastname, a.city,a.street,
	(SELECT COUNT(*)
	FROM loan l
	where l.member_no = m.member_no) as 'wypozyczone'
FROM member m
INNER JOIN juvenile j on m.member_no = j.member_no
INNER JOIN adult a on a.member_no = j.adult_member_no

UNION 

SELECT m.member_no, m.firstname, m.lastname, a.city,a.street,
	(SELECT COUNT(*)
	FROM loan l
	where l.member_no = m.member_no) as 'wypozyczone'
FROM member m
INNER JOIN adult a on a.member_no = m.member_no

--5b czy dany cz³onek jest dzieckiem

USE library
SELECT m.member_no, m.firstname, m.lastname, 'adult', a.city,a.street,
	(SELECT COUNT(*)
	FROM loan l
	where l.member_no = m.member_no) as 'wypozyczone'
FROM member m
INNER JOIN juvenile j on m.member_no = j.member_no
INNER JOIN adult a on a.member_no = j.adult_member_no

UNION 

SELECT m.member_no, m.firstname, m.lastname, 'child',a.city,a.street,
	(SELECT COUNT(*)
	FROM loan l
	where l.member_no = m.member_no) as 'wypozyczone'
FROM member m
INNER JOIN adult a on a.member_no = m.member_no

--6 Wyœwietl imiona i nazwiska osób, które nigdy nie wypo¿yczy³y ¿adnej ksi¹¿ki
--a) bez podzapytañ

USE library
SELECT m.member_no, m.lastname, m.firstname
FROM member m
LEFT OUTER JOIN loan l ON m.member_no = l.member_no
LEFT OUTER JOIN loanhist lh ON m.member_no = lh.member_no
WHERE lh.out_date IS NULL AND l.out_date IS NULL

--b) z podzapytaniami

USE library
SELECT m.member_no, m.lastname, m.firstname
FROM member m
WHERE m.member_no NOT IN 
	(SELECT member_no
	FROM loanhist
	UNION
	SELECT member_no
	FROM loan)

--7 wyœwietl numery zamówieñ, których cena dostawy by³a wiêksza ni¿ œrednia cena za przesy³kê w tym roku
--a) bez podzapytañ

USE Northwind
SELECT o.OrderID
FROM Orders o, Orders o2
WHERE YEAR(o.OrderDate) = YEAR(o2.OrderDate)
GROUP BY o.OrderID, o.Freight
HAVING o.Freight > AVG(o2.Freight)

--b) z podzapytaniami

USE Northwind
SELECT OrderID
FROM Orders AS o
WHERE o.Freight >	
	(SELECT AVG(Freight)
	FROM Orders AS o2
	WHERE YEAR(o.OrderDate) = YEAR(o2.OrderDate))

--8 wyœwietl ile ka¿dy z przewoŸników mia³ dostaæ wynagrodzenia w poszczególnych latach i miesi¹cach.
--a) bez podzapytañ

SELECT ShipVia, YEAR(OrderDate), MONTH(OrderDate), SUM(Freight)
FROM Orders
GROUP BY ShipVia, YEAR(OrderDate), MONTH(OrderDate)

--b) z podzapytaniami

SELECT (SELECT ShipperID FROM Shippers WHERE ShipperID = Orders.ShipVia),YEAR(OrderDate), MONTH(OrderDate), SUM(Freight)
FROM Orders
GROUP BY ShipVia, YEAR(OrderDate), MONTH(OrderDate)

--9 Wypisaæ czytelników, którzy nie przeczytali ¿adnej ksi¹¿ki w 1996 roku
--a) bez podzapytañ

USE library
SELECT m.member_no
FROM member m
LEFT OUTER JOIN loanhist lh ON lh.member_no = m.member_no AND YEAR(in_date)=2002
WHERE in_date IS NULL

--b) z podzapytaniami

USE library
SELECT DISTINCT member_no
FROM member AS m
WHERE member_no NOT IN
	(SELECT member_no
	FROM loanhist
	WHERE YEAR(in_date) = 2002 AND loanhist.member_no = m.member_no)

--10 Wypisaæ klientów wraz z wartoœci¹ zamówieñ z uwzglêdnieniem przesy³ki
--a) bez podzapytañ

USE Northwind
SELECT CustomerID, SUM(UnitPrice*Quantity*(1-Discount)+Freight)
FROM Orders o
INNER JOIN [Order Details] od ON od.OrderID=o.OrderID
GROUP BY CustomerID

--b) z podzapytaniami

SELECT c.CustomerID, 
	(SELECT ISNULL(SUM(UnitPrice*Quantity*(1-Discount)+Freight),0)
	FROM [Order Details] od
	INNER JOIN Orders o ON od.OrderID = o.orderID
	WHERE o.CustomerID = c.customerID)
FROM Customers c

--11 Wypisaæ ceny produktów, których cena jednostkowa jest nie mniejsza od œredniej ceny produktów tej samej kategorii (z podzapytaniem i bez).
--a) bez podzapytañ

SELECT p.ProductID, p.UnitPrice
FROM Products AS p, Products AS p2
WHERE p.CategoryID = p2.CategoryID
GROUP BY p.ProductID, p2.CategoryID, p.UnitPrice
HAVING p.UnitPrice >= AVG(p2.UnitPrice)

--b) z podzapytaniami

SELECT p.ProductID, p.UnitPrice
FROM Products AS p
WHERE p.UnitPrice >= 
	( SELECT AVG(UnitPrice)
	FROM Products AS p2
	WHERE p.CategoryID = p2.CategoryID)

--12 Wypisaæ imiê i nazwisko pracownika, który obs³u¿y³ ³¹cznie zamówienia o najwiêkszej wartoœci w 1997.
--a) bez podzapytañ

SELECT TOP 1 E.LastName, E.FirstName
FROM Employees E
INNER JOIN Orders o ON E.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(OrderDate)=1997
GROUP BY E.LastName, E.FirstName
ORDER BY SUM(UnitPrice*Quantity*(1-Discount)) DESC

--b) z podzapytaniami

SELECT TOP 1 E.LastName, E.FirstName,
	(SELECT SUM(UnitPrice*Quantity*(1-Discount))
	FROM [Order Details] OD
	INNER JOIN Orders O ON OD.OrderID = O.OrderID
	WHERE O.EmployeeID = E.EmployeeID)
FROM Employees E
ORDER BY 3 DESC

--13 Wypisaæ pozycje zamówienia, których cena z rabatem jest mniejsza od œredniej ceny z wszystkich pozycji zamówienia.

SELECT OrderID
FROM [Order Details]
GROUP BY OrderID
Having SUM(UnitPrice*Quantity*(1-Discount)) < 
	(SELECT AVG (Q1.Diff)
	FROM (SELECT SUM(UnitPrice*Quantity*(1-Discount)) AS Diff
		FROM [Order Details]
		GROUP BY OrderID) AS Q1)

--14 Wypisaæ klientów wraz z wartoœci¹ zamówieñ z uwzglêdnieniem przesy³ki
--a) bez podzapytañ

SELECT CustomerID, SUM(UnitPrice*Quantity*(1-Discount)+Freight)
FROM Orders o
INNER join [Order Details] od ON od.OrderID = o.OrderID
GROUP BY CustomerID
ORDER BY CustomerID

--b) z podzapytaniami

SELECT c.CustomerID, 
	(SELECT SUM(UnitPrice*Quantity*(1-Discount)+Freight)
	FROM [Order Details] od
	INNER JOIN orders o ON od.OrderID = o.OrderID
	WHERE o.CustomerID=c.CustomerID)
FROM Customers c
ORDER BY CustomerID

--15 Wybierz nazwy i numery telefonów klientów, którzy nie kupili ¿adnego produktu z kategorii ‘Confections’. Rozwi¹zaæ u¿ywaj¹c mechanizmu podzapytañ

SELECT C.CompanyName, C.Phone
FROM Customers C
WHERE C.CustomerID NOT IN 
	(SELECT CustomerID
	FROM Orders O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P ON OD.ProductID = P.ProductID
	INNER JOIN Categories AS CG ON P.CategoryID = CG.CategoryID
	WHERE CategoryName LIKE 'Confections')

--16 Dla ka¿dego produktu podaj jego nazwê kategorii, nazwê produktu, cenê, œredni¹ cenê wszystkich produktów danej kategorii oraz ró¿nicê miêdzy cen¹ produktu a œredni¹ cen¹ wszystkich produktów danej kategorii.

SELECT CategoryName, ProductName, UnitPrice,
	(SELECT AVG(UnitPrice)
	FROM Products p2
	WHERE p2.CategoryID = p.CategoryID),
	ABS(UnitPrice - (SELECT AVG(UnitPrice)
	FROM Products p2
	WHERE p2.CategoryID = p.CategoryID))
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID

--17 Dla ka¿dego pracownika wypisz iloœæ zamówieñ, jakie obs³u¿y³ w 1997 roku, podaj tak¿e datê ostatniego obs³ugiwanego przez niego zamówienia (w 1997 r.). Interesuj¹ nas pracownicy, którzy obs³u¿yli wiêcej ni¿ szeœæ zamówieñ.

SELECT e.LastName, e.firstname, 
	(SELECT COUNT(OrderID)
	FROM Orders o
	WHERE o.EmployeeID = e.EmployeeID AND YEAR(OrderDate) = 1997) AS total,
	(SELECT TOP 1 OrderDate
	FROM Orders o2
	WHERE o2.EmployeeID = e.EmployeeID AND YEAR(OrderDate) = 1997
	ORDER BY 1 DESC) AS last
FROM Employees e

WHERE (SELECT COUNT(OrderID)
	FROM Orders o
	WHERE o.EmployeeID = e.EmployeeID AND YEAR(OrderDate) = 1997)>6

--18 Podaj wszystkie zamówienia, dla których op³ata za przesy³kê by³a wiêksza od œredniej op³aty za przesy³kê zamówieñ z³o¿onych w tym samym roku.
--a) bez podzapytañ

SELECT o.OrderID
FROM Orders o, Orders o2
WHERE o2.OrderDate = o.OrderDate
GROUP BY o.OrderID, o2.OrderDate, o.Freight
HAVING o.Freight > AVG(o2.Freight)

--b) z podzapytaniami

SELECT o.OrderID 
FROM Orders o
WHERE o.Freight > 
	(SELECT AVG(o2.Freight)
	FROM Orders o2
	WHERE o2.OrderDate = o.OrderDate)

--19 Dla ka¿dego pracownika podaj jego imiê i nazwisko oraz ca³kowit¹ liczbê zamówieñ, jakie obs³u¿y³ ogó³em oraz z rozbiciem na lata, kwarta³y i miesi¹ce.

SELECT Lastname, Firstname, YEAR(OrderDate) AS year, DATEPART(Quarter, OrderDate) AS quarter ,MONTH(OrderDate) AS month,COUNT(OrderID) AS orders
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP by LastName, FirstName, YEAR(OrderDate), DATEPART(Quarter, OrderDate),MONTH(OrderDate)

--20 Czy s¹ jacyœ pracownicy, którzy nie obs³u¿yli ¿adnego zamówienia w 1997 roku jeœli tak to podaj ich dane adresowe
--a) bez podzapytañ

SELECT FirstName, LastName, Address
FROM Employees e
LEFT OUTER JOIN Orders o ON e.EmployeeID = o.EmployeeID AND YEAR(OrderDate)=1997
WHERE OrderDate IS NULL

--b) z podzapytaniami

SELECT FirstName, LastName, Address
FROM Employees
WHERE EmployeeID NOT IN
	(SELECT EmployeeID
	FROM Orders
	WHERE YEAR(OrderDate)=1997)

--21 Podaj liczbê ksi¹¿ek oddanych przez ka¿dego czytelnika, dodatkowo dla ka¿dego czytelnika podaj informacjê o tym, kiedy odda³ ostatni¹ (najpóŸniejsza data oddania) ksi¹¿kê. Interesuj¹ nas tylko czytelnicy o numerach od 1000 do 2000, dla których ³¹czna liczba naliczona kara jest wiêksza od 12.

USE library
SELECT member_no, 
	(SELECT COUNT(in_date)
	FROM loanhist lhhh
	WHERE lhhh.member_no=l.member_no)AS books, 
	(SELECT TOP 1 in_date
	FROM loanhist lh
	WHERE lh.member_no = l.member_no
	ORDER BY 1 DESC) AS lastDate
FROM loanhist l
WHERE l.member_no BETWEEN 1000 AND 2000 
AND
	(SELECT SUM(ISNULL(fine_assessed,0))
	FROM loanhist lhh  
	WHERE lhh.member_no = l.member_no)>0
ORDER BY member_no

--22 Napisz polecenie, które pokazuje pary pracowników mieszkaj¹cych w tym samym mieœcie. Interesuj¹ nas tylko pracownicy zajmuj¹cy stanowisko 'Sales Representative'

USE Northwind
SELECT DISTINCT e.LastName, e.firstName, es.lastname, es.firstname, e.city
FROM Employees e
INNER JOIN Employees es ON e.City = es.City
WHERE e.LastName ! = es.LastName AND e.Title LIKE 'Sales Representative' AND es.Title LIKE 'Sales Representative'

--23 Skonstruuj listê adresow¹ zawieraj¹c¹ dane dostawców, klientów i pracowników. Lista ma byæ posortowana wg poszczególnych grup (najpierw dostawcy, nastêpnie klienci, a na koñcu pracownicy) a w ramach poszczególnych grup alfabetycznie.

SELECT '1', 'supplier', s.CompanyName, s.address
FROM Suppliers s

UNION

SELECT '2','customer', c.CompanyName, c.address
FROM Customers c

UNION 
SELECT '3','employee', e.LastName + ' ' +e.FirstName, e.Address
FROM Employees e

ORDER BY 1,3,4