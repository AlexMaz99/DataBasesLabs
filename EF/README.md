# Entity Framework
## Aleksandra Mazur

### Zadanie I
#### a)
Stworzono projekt typu Console Application .Net Core o nazwie **AMazurProductEF**.

#### b)
Dodano klasę *Product* z polami:
* int ProductID
* string Name
* int UnitsInStock

![](res/2020-04-06-21-54-41.png)

<div style="page-break-after: always;"></div>

#### c), d)
Stworzono klasę *ProdContext* dziedziczącą po *DbContext* i dodano do niej zbiór (*DbSet*) produktów.

![](res/2020-04-06-22-06-33.png)

#### e), f)
W Mainie (plik Program.cs) poproszono użytkownika o podanie nazwy produktu i utworzono obiekt produktu o wczytanej nazwie. Następnie dopisano kod pobierający oraz wyświetlający wszystkie produkty.

![](res/2020-04-07-10-43-59.png)

![](res/2020-04-14-09-58-56.png)


![](res/2020-04-06-23-27-29.png)

![](res/2020-04-06-23-37-20.png)

![](res/2020-04-06-23-37-47.png)

![](res/2020-04-06-23-38-21.png)

![](res/2020-04-06-23-39-44.png)

<div style="page-break-after: always;"></div>

### Zadanie II

Zmodyfikowano model wprowadzając pojęcie Dostawcy - *Supplier* jak poniżej.

![](res/2020-04-08-17-44-39.png)

Klasa *Supplier* zawiera następujące pola:
* int SupplierID
* string CompanyName
* string Street
* string City

![](res/2020-04-08-17-46-57.png)

<div style="page-break-after: always;"></div>

Do klasy Product dodano pole Supplier.

![](res/2020-04-08-17-47-55.png)

Do klasy *ProdContext* dodano kolejny *DbSet*, reprezentujący wszystkich dostawców.

![](res/2020-04-08-18-02-06.png)

<div style="page-break-after: always;"></div>

Schemat w bazie danych wygląda następująco:

![](res/2020-04-07-10-46-48.png)

![](res/2020-04-07-10-47-56.png)

![](res/2020-04-07-09-38-19.png)

#### d), e), f), g)
Dodano do bazy dwa produkty oraz dostawcę. Następnie znaleziono poprzednio wprowadzone produkty i ustawiono dostawcę każdego z nich na wcześniej stworzonego.

![](res/2020-04-07-10-01-56.png)

Produkty przed dodaniem dostawcy:

![](res/2020-04-07-10-19-32.png)

![](res/2020-04-07-10-19-54.png)

Produkty po przypisaniu dostawcy:

![](res/2020-04-07-10-22-21.png)

#### g)
Wyświetlono wszystkie produkty wraz z nazwą dostawcy.

![](res/2020-04-07-10-35-52.png)

![](res/2020-04-07-10-36-30.png)

<div style="page-break-after: always;"></div>

### Zadanie III
Odwrócono relację zgodnie z poniższym schematem.

![](res/2020-04-08-17-59-14.png)

Z klasy *Product* usunięto wcześniej dodane pole *Supplier*. Natomiast do klasy *Supplier* dodano listę produktów, dostarczanych przez danego dostawcę.

![](res/2020-04-08-18-00-02.png)

![](res/2020-04-08-18-00-32.png)

#### a), b)
Dodano do bazy nowe produkty i stworzono dostawcę. Następnie znaleziono wcześniej wprowadzone produkty i dodano je do produktów dostarczanych przez nowo stworzonego dostawcę.

![](res/2020-04-07-13-24-45.png)

<div style="page-break-after: always;"></div>

Wypisano wszystkie produkty dostarczane przez dostawcę. 

![](res/2020-04-07-13-44-03.png)

![](res/2020-04-07-13-45-29.png)

![](res/2020-04-07-13-46-17.png)

<div style="page-break-after: always;"></div>

Schemat bazy danych wygląda jak poniżej:

![](res/2020-04-07-13-47-13.png)

![](res/2020-04-07-13-48-18.png)

![](res/2020-04-07-13-49-02.png)

<div style="page-break-after: always;"></div>

### Zadanie IV
Zamodelowano relację dwustronną jak poniżej.

![](res/2020-04-08-18-13-17.png)

Klasa *Supplier* pozostała bez zmian (z listą dostarczanych przez dostawcę produktów). Z kolei do klasy *Product* dodano pole *Supplier*.

![](res/2020-04-07-14-17-03.png)

![](res/2020-04-07-14-17-20.png)

#### a), b)
Stworzono kilka produktów oraz dodano je do produktów dostarczanych przez nowo stworzonego dostawcę (pamiętając o dwustronności relacji).

![](res/2020-04-07-14-15-56.png)

<div style="page-break-after: always;"></div>

Następnie wyświetlono wszystkie produkty wraz z nazwą dostawcy.

![](res/2020-04-07-14-19-50.png)

![](res/2020-04-07-14-21-12.png)

![](res/2020-04-07-14-21-59.png)

<div style="page-break-after: always;"></div>

### Zadanie V
Dodano klasę *Category* z polami:
* int CategoryID
* string Name
* List \<Product> Products

![](res/2020-04-07-14-30-46.png)

Schemat bazy danych wygląda jak poniżej.

![](res/2020-04-08-18-30-56.png)

![](res/2020-04-08-18-23-17.png)


Do klasy *ProdContext* dodano kolejny *DbSet*, odwzorowujący zbiór kategorii.

![](res/2020-04-07-14-43-33.png)

<div style="page-break-after: always;"></div>

#### a)
Zmodyfikowano klasę *Product*, dodając do niej pole *Category*.

![](res/2020-04-08-18-31-41.png)

![](res/2020-04-07-14-30-25.png)

<div style="page-break-after: always;"></div>

 #### b)
 Stworzono kilka produktów i kilka kategorii.

 ![](res/2020-04-07-14-50-58.png)
 ![](res/2020-04-07-14-51-30.png)

<div style="page-break-after: always;"></div>

 #### c)
 Dodano kilka produktów do wybranej kategorii.

 ![](res/2020-04-07-14-58-35.png)

 ![](res/2020-04-07-14-59-03.png)

<div style="page-break-after: always;"></div>

 #### d)
 Wypisano wszystkie produkty należące do kategorii *Electronics*.

 ![](res/2020-04-07-15-07-35.png)

  Jak widać produkty zostały wypisane poprawnie:

 ![](res/2020-04-07-15-07-52.png)

Następnie wypisano kategorię, do której należy *TV*.

 ![](res/2020-04-07-15-11-54.png)

 Kategoria produktu również została poprawnie wypisana:

 ![](res/2020-04-07-15-12-37.png)

 <div style="page-break-after: always;"></div>

 ### Zadanie VI
 Zmodyfikowano relację wiele-do-wielu, jak poniżej.

![](res/2020-04-08-18-33-02.png)

W celu wykonania powyższej relacji konieczne było stworzenie nowej klasy *InvoiceProduct*, przechowującej relacje między *Invoice* a *Product*. Co więcej do klasy *Product* i *Invoice* dodano listę obiektów *InvoiceProducts*.

 ![](res/2020-04-08-18-40-03.png)

 ![](res/2020-04-08-18-41-20.png)

 ![](res/2020-04-08-18-47-23.png)

 <div style="page-break-after: always;"></div>

Do klasy *ProdContext* dodano jeden *DbSet* odzwierciedlający zbiór faktur oraz drugi - przedstawiający zbiór relacji między produktami a fakturami. Nadpisano również metodę *OnModelCreating*.

![](res/2020-04-08-18-53-11.png)

<div style="page-break-after: always;"></div>

Schemat bazy danych wygląda następująco:

![](res/2020-04-08-19-03-05.png)

![](res/2020-04-08-19-03-51.png)

![](res/2020-04-08-19-04-20.png)

#### a)
Stworzono kilka produktów, dodano kategorię, dostawcę i "sprzedano" dane produkty na kilku transakcjach.

```csharp
using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace AMazurProductEF
{
    class Program
    {
        static void Main(string[] args)
        {
            ProdContext context = new ProdContext();
            // create products, category, supplier and invoices
            Product product1 = new Product { Name = "Turkey" };
            Product product2 = new Product { Name = "Apple" };
            Product product3 = new Product { Name = "Orange" };
            Product product4 = new Product { Name = "Onion" };
            Product product5 = new Product { Name = "Fish" };
            Supplier supplier = new Supplier { CompanyName = "FoodCompany" };
            Category category = new Category { Name = "Food" };
            Invoice invoice1 = new Invoice { InvoiceNumber = 1, Quantity = 3 };
            Invoice invoice2 = new Invoice { InvoiceNumber = 2, Quantity = 3 };

            // add category to products and products to category
            category.Products.Add(product1);
            category.Products.Add(product2);
            category.Products.Add(product3);
            category.Products.Add(product4);
            category.Products.Add(product5);
            product1.Category = category;
            product2.Category = category;
            product3.Category = category;
            product4.Category = category;
            product5.Category = category;

            // add supplier to products and products to supplier
            supplier.Products.Add(product1);
            supplier.Products.Add(product2);
            supplier.Products.Add(product3);
            supplier.Products.Add(product4);
            supplier.Products.Add(product5);
            product1.Supplier = supplier;
            product2.Supplier = supplier;
            product3.Supplier = supplier;
            product4.Supplier = supplier;
            product5.Supplier = supplier;

            // add products, category, supplier and invoices to ProdContext
            context.Products.Add(product1);
            context.Products.Add(product2);
            context.Products.Add(product3);
            context.Products.Add(product4);
            context.Products.Add(product5);
            context.Categories.Add(category);
            context.Suppliers.Add(supplier);
            context.Invoices.Add(invoice1);
            context.Invoices.Add(invoice2);

            // create invoiceProducts
            InvoiceProduct invoiceProduct1 = new InvoiceProduct { Invoice = invoice1, Product = product1 };
            invoice1.InvoiceProducts.Add(invoiceProduct1);
            InvoiceProduct invoiceProduct2 = new InvoiceProduct { Invoice = invoice1, Product = product2 };
            invoice1.InvoiceProducts.Add(invoiceProduct2);
            InvoiceProduct invoiceProduct3 = new InvoiceProduct { Invoice = invoice1, Product = product3 };
            invoice1.InvoiceProducts.Add(invoiceProduct3);
            InvoiceProduct invoiceProduct4 = new InvoiceProduct { Invoice = invoice2, Product = product3 };
            invoice2.InvoiceProducts.Add(invoiceProduct4);
            InvoiceProduct invoiceProduct5 = new InvoiceProduct { Invoice = invoice2, Product = product4 };
            invoice2.InvoiceProducts.Add(invoiceProduct5);
            InvoiceProduct invoiceProduct6 = new InvoiceProduct { Invoice = invoice2, Product = product5 };
            invoice2.InvoiceProducts.Add(invoiceProduct6);

            // add invoiceProducts to ProdContext
            context.InvoiceProducts.Add(invoiceProduct1);
            context.InvoiceProducts.Add(invoiceProduct2);
            context.InvoiceProducts.Add(invoiceProduct3);
            context.InvoiceProducts.Add(invoiceProduct4);
            context.InvoiceProducts.Add(invoiceProduct5);
            context.InvoiceProducts.Add(invoiceProduct6);

            product1.InvoiceProducts.Add(invoiceProduct1);
            product2.InvoiceProducts.Add(invoiceProduct2);
            product3.InvoiceProducts.Add(invoiceProduct3);
            product3.InvoiceProducts.Add(invoiceProduct4);
            product4.InvoiceProducts.Add(invoiceProduct5);
            product5.InvoiceProducts.Add(invoiceProduct6);

            context.SaveChanges();
        }
    }
}
```
Poniżej widać, że dane poprawnie dodały się do bazy.

![](res/2020-04-08-19-38-07.png)

![](res/2020-04-08-19-38-39.png)

![](res/2020-04-08-19-39-16.png)

![](res/2020-04-08-19-39-57.png)

![](res/2020-04-08-19-40-22.png)

![](res/2020-04-08-19-43-56.png)

#### b)
Wypisano produkty sprzedane w ramach wybranej faktury/transakcji.

![](res/2020-04-08-20-00-19.png)

![](res/2020-04-08-19-59-02.png)

<div style="page-break-after: always;"></div>

#### d)
Wypisano faktury, w ramach których był sprzedany wybrany produkt.

![](res/2020-04-08-20-05-07.png)

![](res/2020-04-08-20-04-52.png)

<div style="page-break-after: always;"></div>

### Zadanie VII
#### Dziedziczenie
#### a)
Wprowadzono do modelu następujące hierarchie.

![](res/2020-04-08-20-07-22.png)

Klasa *Company* zawiera pola:
* int CompanyID
* string CompanyName
* string Street
* string City
* string ZipCode

![](res/2020-04-14-10-11-00.png)

Klasa *Customer* zawiera pole:
* float Discount

![](res/2020-04-08-20-15-13.png)

<div style="page-break-after: always;"></div>

Klasa *Supplier* zawiera pola:
* string BankAccountNumber
* List \<Product> Products

![](res/2020-04-08-20-29-34.png)

<div style="page-break-after: always;"></div>

Baza danych wygląda następująco:

![](res/2020-04-08-20-52-40.png)

<div style="page-break-after: always;"></div>

#### b) 
##### TablePerHierarchy
W celu dodania i pobrania z bazy firm, stosując strategię mapowania dziedziczenia *TablePerHierarchy*, zmieniono metodę *OnModelCreating* w klasie *ProdContext*. Zastąpiono również wcześniejszy DbSet dostawców, *DbSet'em* firm. 

![](res/2020-04-08-20-27-32.png)

![](res/2020-04-08-20-53-08.png)

Do bazy dodano kilku dostawców i klientów.

```csharp
using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace AMazurProductEF
{
    class Program
    {
        static void Main(string[] args)
        {

            ProdContext context = new ProdContext();
            Supplier supplier1 = new Supplier
            {
                CompanyName = "Supplier1",
                City = "Cracow",
                Street = "Kawiory",
                ZipCode = "30-551",
                BackAccountNumber = "123456789",
            };
            context.Add(supplier1);
            Supplier supplier2 = new Supplier
            {
                CompanyName = "Supplier2",
                City = "Warsaw",
                Street = "Aleja Pokoju",
                ZipCode = "33-330",
                BackAccountNumber = "987654321",
            };
            context.Add(supplier2);
            Customer customer1 = new Customer
            {
                CompanyName = "Customer1",
                City = "Paris",
                Street = "Czarnowiejska",
                ZipCode = "32-360",
                Discount = 0.8f,
            };
            context.Add(customer1);
            Customer customer2 = new Customer
            {
                CompanyName = "Customer1",
                City = "London",
                Street = "Downing Street",
                ZipCode = "31-330",
                Discount = 0.5f,
            };
            context.Add(customer2);
            context.SaveChanges();
        }
    }
}
```

Jak widać dane dodały się prawidłowo.

![](res/2020-04-08-20-49-31.png)

Poniżej pobrano z bazy dane dotyczące dostawców i klientów.

![](res/2020-04-08-21-51-59.png)

![](res/2020-04-08-21-51-38.png)

<div style="page-break-after: always;"></div>

##### TablePerType
Niestety strategia mapowania dziedziczenia *TablePerType* nie jest dostępna w wersjach od *3.0 Entity Framework*, więc nie da się wykonać tego podpunktu. Poniżej jednak zostały przedstawione próby wykonania zadania.

![](res/2020-04-14-11-09-16.png)

![](res/2020-04-14-11-10-16.png)

![](res/2020-04-14-11-31-20.png)

<div style="page-break-after: always;"></div>

Schemat bazy wygląda następująco:

![](res/2020-04-14-11-19-20.png)

![](res/2020-04-14-11-21-00.png)

Można zauważyć, że w tabeli *Companies* brakuje pola *Discount* należącego do klasy *Customer*.

<div style="page-break-after: always;"></div>

Do bazy dodano poniższe dane:

![](res/2020-04-14-11-25-01.png)

![](res/2020-04-14-11-25-27.png)

<div style="page-break-after: always;"></div>

Spróbowano wypisać dodane wcześniej dane.

![](res/2020-04-14-11-36-53.png)

Dostawcy zostali wypisani poprawnie:

![](res/2020-04-14-11-29-10.png)

Z kolei przy próbie wypisania klientów, został wyświetlony poniższy wyjątek:

![](res/2020-04-14-11-30-47.png)

##### TablePerClass
Strategia *TablePerClass* również nie jest możliwa do wykonania, ponieważ metoda *ToTable()*, która jest niezbędna do wykonania tego zadania rzuca błąd od wersji *3.0 Entity Framework*.

![](res/2020-04-14-10-41-50.png)