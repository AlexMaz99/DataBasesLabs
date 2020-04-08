--1 Podaj wykaz wszystkich produkt�w, kt�rych cena jest mniejsza ni� �rednia cena produktu danej kategorii

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

--2 Dla ka�dego produktu podaj jego nazw� kategorii, nazw� produktu, cen�, �redni� cen� wszystkich produkt�w danej kategorii oraz r�nic� mi�dzy cen� produktu a �redni� cen� wszystkich produkt�w

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

--3 Podaj ��czn� warto�� zam�wie� ka�dego zam�wienia (uwzgl�dnij cen� za przesy�k�)

USE Northwind
SELECT OrderID,
(
	SELECT sum(UnitPrice * Quantity * (1 - Discount))
	FROM [Order Details]  AS OD
	WHERE OD.OrderID = O.OrderID
) + Freight as total

FROM Orders AS O

--4 Dla ka�dego pracownika (imi� i nazwisko) podaj ��czn� warto�� zam�wie� obs�u�onych przez tego pracownika (przy obliczaniu warto�ci zam�wie� uwzgl�dnij cen� za przesy�k�), kt�rzy nie maj� podw�adnych

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

--5a Wy�wietl imi�, nazwisko, dane adresowe oraz ilo�� wypo�yczonych ksi��ek dla ka�dego cz�onka biblioteki. Ilo�� wypo�yczonych ksi��ek nie mo�e by� nullem, co najwy�ej zerem.

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

--5b czy dany cz�onek jest dzieckiem

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

--6 Wy�wietl imiona i nazwiska os�b, kt�re nigdy nie wypo�yczy�y �adnej ksi��ki
--a) bez podzapyta�

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

--7 wy�wietl numery zam�wie�, kt�rych cena dostawy by�a wi�ksza ni� �rednia cena za przesy�k� w tym roku
--a) bez podzapyta�

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

--8 wy�wietl ile ka�dy z przewo�nik�w mia� dosta� wynagrodzenia w poszczeg�lnych latach i miesi�cach.
--a) bez podzapyta�

SELECT ShipVia, YEAR(OrderDate), MONTH(OrderDate), SUM(Freight)
FROM Orders
GROUP BY ShipVia, YEAR(OrderDate), MONTH(OrderDate)

--b) z podzapytaniami

SELECT (SELECT ShipperID FROM Shippers WHERE ShipperID = Orders.ShipVia),YEAR(OrderDate), MONTH(OrderDate), SUM(Freight)
FROM Orders
GROUP BY ShipVia, YEAR(OrderDate), MONTH(OrderDate)

--9 Wypisa� czytelnik�w, kt�rzy nie przeczytali �adnej ksi��ki w 1996 roku
--a) bez podzapyta�

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

--10 Wypisa� klient�w wraz z warto�ci� zam�wie� z uwzgl�dnieniem przesy�ki
--a) bez podzapyta�

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

--11 Wypisa� ceny produkt�w, kt�rych cena jednostkowa jest nie mniejsza od �redniej ceny produkt�w tej samej kategorii (z podzapytaniem i bez).
--a) bez podzapyta�

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

--12 Wypisa� imi� i nazwisko pracownika, kt�ry obs�u�y� ��cznie zam�wienia o najwi�kszej warto�ci w 1997.
--a) bez podzapyta�

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

--13 Wypisa� pozycje zam�wienia, kt�rych cena z rabatem jest mniejsza od �redniej ceny z wszystkich pozycji zam�wienia.

SELECT OrderID
FROM [Order Details]
GROUP BY OrderID
Having SUM(UnitPrice*Quantity*(1-Discount)) < 
	(SELECT AVG (Q1.Diff)
	FROM (SELECT SUM(UnitPrice*Quantity*(1-Discount)) AS Diff
		FROM [Order Details]
		GROUP BY OrderID) AS Q1)

--14 Wypisa� klient�w wraz z warto�ci� zam�wie� z uwzgl�dnieniem przesy�ki
--a) bez podzapyta�

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

--15 Wybierz nazwy i numery telefon�w klient�w, kt�rzy nie kupili �adnego produktu z kategorii �Confections�. Rozwi�za� u�ywaj�c mechanizmu podzapyta�

SELECT C.CompanyName, C.Phone
FROM Customers C
WHERE C.CustomerID NOT IN 
	(SELECT CustomerID
	FROM Orders O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P ON OD.ProductID = P.ProductID
	INNER JOIN Categories AS CG ON P.CategoryID = CG.CategoryID
	WHERE CategoryName LIKE 'Confections')

--16 Dla ka�dego produktu podaj jego nazw� kategorii, nazw� produktu, cen�, �redni� cen� wszystkich produkt�w danej kategorii oraz r�nic� mi�dzy cen� produktu a �redni� cen� wszystkich produkt�w danej kategorii.

SELECT CategoryName, ProductName, UnitPrice,
	(SELECT AVG(UnitPrice)
	FROM Products p2
	WHERE p2.CategoryID = p.CategoryID),
	ABS(UnitPrice - (SELECT AVG(UnitPrice)
	FROM Products p2
	WHERE p2.CategoryID = p.CategoryID))
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID

--17 Dla ka�dego pracownika wypisz ilo�� zam�wie�, jakie obs�u�y� w 1997 roku, podaj tak�e dat� ostatniego obs�ugiwanego przez niego zam�wienia (w 1997 r.). Interesuj� nas pracownicy, kt�rzy obs�u�yli wi�cej ni� sze�� zam�wie�.

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

--18 Podaj wszystkie zam�wienia, dla kt�rych op�ata za przesy�k� by�a wi�ksza od �redniej op�aty za przesy�k� zam�wie� z�o�onych w tym samym roku.
--a) bez podzapyta�

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

--19 Dla ka�dego pracownika podaj jego imi� i nazwisko oraz ca�kowit� liczb� zam�wie�, jakie obs�u�y� og�em oraz z rozbiciem na lata, kwarta�y i miesi�ce.

SELECT Lastname, Firstname, YEAR(OrderDate) AS year, DATEPART(Quarter, OrderDate) AS quarter ,MONTH(OrderDate) AS month,COUNT(OrderID) AS orders
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP by LastName, FirstName, YEAR(OrderDate), DATEPART(Quarter, OrderDate),MONTH(OrderDate)

--20 Czy s� jacy� pracownicy, kt�rzy nie obs�u�yli �adnego zam�wienia w 1997 roku je�li tak to podaj ich dane adresowe
--a) bez podzapyta�

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

--21 Podaj liczb� ksi��ek oddanych przez ka�dego czytelnika, dodatkowo dla ka�dego czytelnika podaj informacj� o tym, kiedy odda� ostatni� (najp�niejsza data oddania) ksi��k�. Interesuj� nas tylko czytelnicy o numerach od 1000 do 2000, dla kt�rych ��czna liczba naliczona kara jest wi�ksza od 12.

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

--22 Napisz polecenie, kt�re pokazuje pary pracownik�w mieszkaj�cych w tym samym mie�cie. Interesuj� nas tylko pracownicy zajmuj�cy stanowisko 'Sales Representative'

USE Northwind
SELECT DISTINCT e.LastName, e.firstName, es.lastname, es.firstname, e.city
FROM Employees e
INNER JOIN Employees es ON e.City = es.City
WHERE e.LastName ! = es.LastName AND e.Title LIKE 'Sales Representative' AND es.Title LIKE 'Sales Representative'

--23 Skonstruuj list� adresow� zawieraj�c� dane dostawc�w, klient�w i pracownik�w. Lista ma by� posortowana wg poszczeg�lnych grup (najpierw dostawcy, nast�pnie klienci, a na ko�cu pracownicy) a w ramach poszczeg�lnych grup alfabetycznie.

SELECT '1', 'supplier', s.CompanyName, s.address
FROM Suppliers s

UNION

SELECT '2','customer', c.CompanyName, c.address
FROM Customers c

UNION 
SELECT '3','employee', e.LastName + ' ' +e.FirstName, e.Address
FROM Employees e

ORDER BY 1,3,4