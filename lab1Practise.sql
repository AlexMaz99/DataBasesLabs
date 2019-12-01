--1

SELECT title, title_no
FROM title

--2

SELECT title, title_no
FROM title
WHERE title_no=10

--3

SELECT member_no, fine_assessed
FROM loanhist
WHERE fine_assessed BETWEEN 8 AND 9

--4

SELECT title_no, author
FROM title
WHERE author LIKE 'Charles Dickens' OR author LIKE 'Jane Austen'

--5

SELECT title_no, title
FROM title
WHERE title LIKE '%adventures%'

--6

SELECT member_no, fine_assessed, fine_paid, fine_waived
FROM loanhist
WHERE isnull(fine_assessed,0)>isnull(fine_paid,0)+isnull(fine_waived,0)

--7

SELECT DISTINCT city, state
FROM adult

--8

SELECT title
FROM title
ORDER BY title

--9 

SELECT member_no, isbn, fine_assessed, fine_assessed*2 AS 'double fine'
FROM loanhist
WHERE isnull (fine_assessed,0) > 0

--10

SELECT LOWER(firstname+middleinitial+SUBSTRING(lastname,1,2)) AS 'email_name'
FROM member
WHERE lastname LIKE 'Anderson'

--11

SELECT 'The title is: ' + title + 'title number ' + cast(title_no as varchar) AS 'Title and number'
FROM title