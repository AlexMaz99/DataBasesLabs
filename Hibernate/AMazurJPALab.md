# Hibernate
## Aleksandra Mazur

### Zadanie II. Basics
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

### Zadanie III. Dodanie produktu

W klasie `Main` stworzono przykładowy produkt i zapisano go do bazy danych.

![](res/2020-04-28-09-11-26.png)

![](res/2020-04-28-09-12-11.png)

Schemat w bazie danych wygląda następująco:

![](res/2020-04-28-09-13-28.png)

Skrypt tworzący tabelę `Product`:

![](res/2020-04-28-09-14-14.png)
 
 Jak widać produkt dodał się poprawnie:

![](res/2020-04-28-09-15-23.png)

### Zadanie IV. Klasa Supplier

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

Do pliku `hibernate.cfg.xml` dodano Suppliera.

![](res/2020-04-28-14-10-28.png)

Utworzono nowego dostawcę i przypisano go do wcześniej dodanego produktu.

![](res/2020-04-28-10-09-29.png)

Schemat bazy danych wygląda następująco:

![](res/2020-04-28-10-13-59.png)

Jak widać dane dodały się poprawnie.

![](res/2020-04-28-10-10-52.png)

![](res/2020-04-28-10-11-29.png)

### Zadanie V. Odwrócona relacja Supplier - Product

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

### Zadanie VI. Relacja dwustronna
Zamodelowano relację dwustronną jak poniżej.

![](res/2020-04-28-14-08-43.png)

Metody dodane/zmodyfikowane w klasie `Supplier`:
* `suppliesProduct(Product product)` zwracającą prawdę, jeżeli dostawca ma dany produkt w zbiorze dostarczanych produktów i fałsz w przeciwnym przypadku.
* `addProduct(Product product)` dodającą produkt do zbioru dostarczanych produktów i przypisującą dostawcę produktowi

![](res/2020-04-28-14-31-37.png)

Klasa `Product`:
Dodano do klasy pole `Supplier` i metodę `setSupplier(Supplier supplier)` przypisującą dostawcę do produktu oraz dodającą produkt do zbioru produktów dostarczanych przez dostawcę, jeżeli nie należy on jeszcze do tego zbioru.

![](res/2020-04-28-14-35-58.png)

Schemat bazy danych wygląda następująco.

![](res/2020-04-28-14-40-26.png)

Skrypt tworzący tabele:

![](res/2020-04-28-14-40-53.png)

Dodane dane:

![](res/2020-04-28-14-41-31.png)

![](res/2020-04-28-14-41-52.png)

### Zadanie VII. Klasa Category
#### a) Modyfikacja modelu
Dodano klasę `Category` z polami:
* private int CategoryId
* private String Name
* private List <\Product> Products

Klasa ta posiada metodę `addProduct(Product product)`, która dodaje dany produkt do listy produktów bieżącej kategorii oraz przypisuje kategorię produktowi.

![](res/2020-04-28-16-52-59.png)

Do pliku `hibernate.cfg.xml` dodano Category.

![](res/2020-04-28-16-55-04.png)

Zmodyfikowano klasę `Product`, dodając wskazanie na kategorię, do której należy oraz metodę `setCategory(Category category)` przypisującą daną kategorię produktowi i dodającą produkt do listy produktów kategorii, jeśli jeszcze nie został tam dodany. Co więcej zmieniono dostępność atrybutów we wszystkich klasach na prywatne.

![](res/2020-04-28-16-58-17.png)

Schemat bazy wygląda następująco:

![](res/2020-04-28-16-59-07.png)

Skrypt generujący tabele:

![](res/2020-04-28-17-00-01.png)

#### b), c) Dodanie danych

W `Mainie` dodano dostawcę, kilka produktów i kategorii jak poniżej.

![](res/2020-04-28-17-01-24.png)

Po uruchomieniu powyższego kodu baza danych wygląda następująco:

![](res/2020-04-28-17-03-03.png)

![](res/2020-04-28-17-03-23.png)

![](res/2020-04-28-17-03-40.png)

#### d) Wyciągnięcie danych z bazy

* Produkty z wybranej kategorii:

![](res/2020-04-28-17-11-28.png)

![](res/2020-04-28-17-14-39.png)

* Kategoria, do której należy wybrany produkt:

![](res/2020-04-28-17-17-04.png)

![](res/2020-04-28-17-19-57.png)

### Zadanie VIII. Klasa Invoice (relacje wiele-do wielu)
#### a) Modyfikacja modelu
Zamodelowano relację wiele-do-wielu jak poniżej.

![](res/2020-04-28-17-22-52.png)

Stworzono klasę `Invoice` o atrybutach:
* private int InvoiceNumber
* private int Quantity
* private Set \<Product> includesProducts

Dodano do niej między innymi metodę `addProduct(Product product)`, dodającą produkt do zbioru produktów faktury i zwiększającą ilość produktów na fakturze o 1.

![](res/2020-04-28-17-52-51.png)

Do klasy `Product` dodano zbiór faktur, które zawierają bieżący produkt:
* private Set\<Invoice> canBeSoldIn

![](res/2020-04-28-17-57-19.png)

Do pliku `hibernate.cfg.xml` dodano Invoice.

![](res/2020-04-28-17-57-40.png)

Schemat bazy dancyh wygląda następująco:

![](res/2020-04-28-17-59-16.png)

Skrypt generujący bazę danych:

```sql
create table CATEGORY
(
    CATEGORYID INTEGER not null
        constraint "SQL0000000007-c6970388-0171-c07e-3180-ffffc71c8945"
            primary key,
    NAME       VARCHAR(255)
);

create table INVOICE
(
    INVOICENUMBER INTEGER not null
        constraint "SQL0000000012-5d5b4477-0171-c07e-3180-ffffc71c8945"
            primary key,
    QUANTITY      INTEGER not null
);

create table SUPPLIER
(
    SUPPLIERID  INTEGER not null
        constraint "SQL0000000009-da248395-0171-c07e-3180-ffffc71c8945"
            primary key,
    CITY        VARCHAR(255),
    COMPANYNAME VARCHAR(255),
    STREET      VARCHAR(255)
);

create table PRODUCT
(
    PRODUCTID    INTEGER not null
        constraint "SQL0000000008-f4ca438f-0171-c07e-3180-ffffc71c8945"
            primary key,
    PRODUCTNAME  VARCHAR(255),
    UNITSONSTOCK INTEGER not null,
    CATEGORY     INTEGER
        constraint FKEDNTEOGHHMGHKELRH3HBU75LP
            references CATEGORY,
    SUPPLIED_BY  INTEGER
        constraint FKRKVCU2QJUUMNU5IHG9CWRBTTN
            references SUPPLIER
);

create table INVOICE_PRODUCT
(
    CANBESOLDIN_INVOICENUMBER  INTEGER not null
        constraint FK3MT734UUBMOS8GVSXV85H0XXJ
            references INVOICE,
    INCLUDESPRODUCTS_PRODUCTID INTEGER not null
        constraint FKBX01IKXFWEBN63V0K8F4L2EDL
            references PRODUCT,
    constraint "SQL0000000013-ad30c47e-0171-c07e-3180-ffffc71c8945"
        primary key (CANBESOLDIN_INVOICENUMBER, INCLUDESPRODUCTS_PRODUCTID)
);

create index "SQL0000000014-cd128485-0171-c07e-3180-ffffc71c8945"
    on INVOICE_PRODUCT (INCLUDESPRODUCTS_PRODUCTID);

create index "SQL0000000015-dabb448a-0171-c07e-3180-ffffc71c8945"
    on INVOICE_PRODUCT (CANBESOLDIN_INVOICENUMBER);

create index "SQL0000000010-b86e839c-0171-c07e-3180-ffffc71c8945"
    on PRODUCT (CATEGORY);

create index "SQL0000000011-1c0c03a0-0171-c07e-3180-ffffc71c8945"
    on PRODUCT (SUPPLIED_BY);
```

#### Dodanie obiektów do bazy

Dodano kilka produktów, faktur, dostawcę i kategorię.

![](res/2020-04-28-18-01-45.png)

Zawartość bazy danych po uruchomieniu powyższego kodu:

![](res/2020-04-28-18-03-06.png)

![](res/2020-04-28-18-03-26.png)

![](res/2020-04-28-18-03-55.png)

![](res/2020-04-28-18-04-15.png)

![](res/2020-04-28-18-04-35.png)

#### b) Wypisanie produktów sprzedanych w ramch wybranej faktury

![](res/2020-04-28-18-07-33.png)

![](res/2020-04-28-18-08-28.png)

#### c) Wypisanie faktur w ramach, których był sprzedany wybrany produkt

![](res/2020-04-28-18-09-28.png)

![](res/2020-04-28-18-11-04.png)