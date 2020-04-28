# Hibernate, JPA - laboratorium
## Aleksandra Mazur

### II. Basics
#### a) - h) Konfiguracja
Uruchomiono i podpięto się do serwera *Derby* oraz założono bazę `AMazurJPA`.

Polecenie *show tables* zwróciło poniższe dane.

![](res/2020-04-28-09-16-33.png)

#### i) Projekt Javowy
Utworzono projekt w Intellij o nazwie `AMazurJPAPractice`.

#### j), k) Klasa Product
Stworzono klasę `Product` z polami:
* public int ProductId
* public String ProductName
* public int UnitsOnStock

Uzupełniono w klasie elementy potrzebne do zmapowania jej do bazy danych.

![](res/2020-04-28-09-09-51.png)

#### l), m) Hibernate config
W pliku `hibernate.cfg.xml` uzupełniono potrzebne property.

![](res/2020-04-28-09-10-34.png)

### III. Dodanie produktu

W klasie `Main` stworzono przykładowy produkt i zapisano go do bazy danych.

![](res/2020-04-28-09-11-26.png)

![](res/2020-04-28-09-12-11.png)

Schemat w bazie danych wygląda następująco:

![](res/2020-04-28-09-13-28.png)

Skrypt tworzący tabelę `Product`:

![](res/2020-04-28-09-14-14.png)
 
 Jak widać produkt dodał się poprawnie:

![](res/2020-04-28-09-15-23.png)

### IV. Klasa Supplier

Zmodyfikowano model wprowadzając pojęcie dostawcy jak poniżej.

![](res/2020-04-28-13-33-22.png)

Klasa `Supplier` zawiera pola:
* public int SupplierId
* public String CompanyName
* public String Street
* public String City

![](res/2020-04-28-10-08-18.png)

Zmodyfikowano klasę `Product`, dodając do niej pole `Supplier` i funkcję `setSupplier(Supplier supplier)` przypisującą danego dostawcę do produktu.

![](res/2020-04-28-10-08-39.png)

Utworzono nowego dostawcę i przypisano go do wcześniej dodanego produktu.

![](res/2020-04-28-10-09-29.png)

Schemat bazy danych wygląda następująco:

![](res/2020-04-28-10-13-59.png)

Jak widać dane dodały się poprawnie.

![](res/2020-04-28-10-10-52.png)

![](res/2020-04-28-10-11-29.png)

### V. Odwrócona relacja Supplier - Product

Odwrócono relację zgodnie z poniższym schematem.

![](res/2020-04-28-13-38-24.png)

#### a) Wariant z tabelą łącznikową

Usunięto z klasy `Product` wcześniej dodane pole `Supplier`.

![](res/2020-04-28-10-35-00.png)

Do klasy `Supplier` dodano zbiór produktów i metodę `addProduct(Product product)` dodającą dany produkt do zbioru produktów dostarczanych przez danego dostawcę.

![](res/2020-04-28-10-35-41.png)

Dodano kilka produktów i dostawcę, a następnie przypisano utworzone produkty do zbioru produktów dostarczanych przez dostawcę.

![](res/2020-04-28-10-37-00.png)

Schemat bazy danych wygląda następująco:

![](res/2020-04-28-10-39-43.png)

Jak widać powyżej, dodała się tabela łącznikowa `SUPPLIER_PRODUCT`.

Dodane dane:

![](res/2020-04-28-10-40-48.png)

![](res/2020-04-28-10-41-09.png)

![](res/2020-04-28-10-41-42.png)

#### b) Wariant bez tabeli łącznikowej

W klasie `Supplier` nad zbiorem produktów dopisano *@JoinColumn(name="Supplier_FK")*.

![](res/2020-04-28-13-58-22.png)

Schemat bazy danych wygląda jak poniżej.

![](res/2020-04-28-13-59-46.png)

Jak widać nie dodała się tabela łącznikowa. Zamiast niej w tabeli `Product` jest pole `SUPPLIER_FK`.

Skrypt generujący tabele:

![](res/2020-04-28-14-01-09.png)

Dane dodane do bazy:

![](res/2020-04-28-14-01-59.png)

![](res/2020-04-28-14-02-20.png)