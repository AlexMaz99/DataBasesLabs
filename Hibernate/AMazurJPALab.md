# Hibernate, JPA - laboratorium
## Aleksandra Mazur

### II. Basics
#### a, b, c, d, e, f)

![](res/2020-04-28-09-16-33.png)

Konfiguracja środowiska powiodła się.

#### g, h) Klasa Product
Stworzono klasę Product z polami ProductName, UnitsOnStock i uzupełniono w klasie elementy potrzebne do zmapowania klasy do bazy danych.

![](res/2020-04-28-09-09-51.png)

#### i, j) Hibernate config
W pliku *hibernate.cfg.xml* uzupełniono potrzebne property.

![](res/2020-04-28-09-10-34.png)

### III. Przykładowy produkt

Klasa Main:

![](res/2020-04-28-09-11-26.png)

![](res/2020-04-28-09-12-11.png)

Schemat w bazie danych:

![](res/2020-04-28-09-13-28.png)

![](res/2020-04-28-09-14-14.png)
 
 Jak widać produkt dodał się poprawnie:

![](res/2020-04-28-09-15-23.png)

### IV. Klasa Supplier

![](res/2020-04-28-10-08-18.png)

Zmodyfikowano klasę Product, dodając do niej pole Supplier.

![](res/2020-04-28-10-08-39.png)

Utworzono nowego dostawcę i przypisano go do wcześniej utworzonego produktu.

![](res/2020-04-28-10-09-29.png)

Schemat bazy danych:

![](res/2020-04-28-10-13-59.png)

Jak widać dane dodały się poprawnie.

![](res/2020-04-28-10-10-52.png)

![](res/2020-04-28-10-11-29.png)

### V. Odwrócona relacja Supplier - Product

#### a) Wariant z tabelą łącznikową

Usunięto z klasy Product pole Supplier.

![](res/2020-04-28-10-35-00.png)

Do klasy Supplier dodano zbiór produktów.

![](res/2020-04-28-10-35-41.png)

Dodano kilka produktów i dostawcę.

![](res/2020-04-28-10-37-00.png)

Schemat bazy danych:

![](res/2020-04-28-10-39-43.png)

![](res/2020-04-28-10-40-48.png)

![](res/2020-04-28-10-41-09.png)

![](res/2020-04-28-10-41-42.png)

Dane dodały się poprawnie.

#### b) Wariant bez tabeli łącznikowej