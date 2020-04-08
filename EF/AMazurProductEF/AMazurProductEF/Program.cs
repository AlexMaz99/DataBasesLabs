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

            // exercise Vc
            /*Category category = context.Categories.Where(s => s.Name == "Electronics").FirstOrDefault();
            Product prod1 = context.Products.Where(s => s.Name == "TV").FirstOrDefault();

            context.Entry(prod1).Reference(prod => prod.Category).Load();

            if (prod1.Category == null)
            {
                context.Entry(prod1).Property("CategoryID").CurrentValue = category.CategoryID;
                category.Products.Add(prod1);
                context.SaveChanges();
            }*/



            // exercise Vd
            /*Category category = context.Categories.Include(c => c.Products).ToList().Where(s => s.Name == "Electronics").FirstOrDefault();
            Console.WriteLine(category.Name + ": ");
            foreach (Product p in category.Products)
            {
                Console.WriteLine(p.Name);
            }

            Product prod = context.Products.Where(s => s.Name == "TV").FirstOrDefault();

            context.Entry(prod).Reference(prod => prod.Category).Load();

            if (prod.Category != null)
            {
                Console.WriteLine(prod.Name + " in " + prod.Category.Name);
            }*/



            // exercise VIa
            /*Product product1 = new Product { Name = "Turkey" };
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

            context.SaveChanges();*/



            // exercise VIb
            /*ProdContext context = new ProdContext();
            Console.WriteLine("Invoice number = 1");
            Console.WriteLine("Products: ");
            var products = context.InvoiceProducts.Include(ip => ip.Product).Where(ip => ip.InvoiceID == 1).Select(ip => ip.Product.Name).ToList();

            foreach (var p in products)
            {
                Console.WriteLine("- " + p);
            }*/



            // exercise VId
            /*ProdContext context = new ProdContext();
            Console.WriteLine("Product name: Orange");
            Console.WriteLine("Invoices numbers: ");
            var invoices = context.InvoiceProducts.Include(ip => ip.Invoice).Where(ip => ip.ProductID == 3).Select(ip => ip.Invoice.InvoiceNumber).ToList();

            foreach (var i in invoices)
            {
                Console.WriteLine("- " + i);
            }*/



            // exercise VIIb
            /*Supplier supplier1 = new Supplier
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



            var customers = context.Companies.OfType<Customer>().ToList();
            var suppliers = context.Companies.OfType<Supplier>().ToList();
            Console.WriteLine("Customers: ");
            foreach (var c in customers)
            {
                Console.WriteLine("- " + c.CompanyName + " with discount = " + c.Discount);
            }
            Console.WriteLine("Suppliers: ");
            foreach (var s in suppliers)
            {
                Console.WriteLine("- " + s.CompanyName + " with bank account number = " + s.BackAccountNumber); ;
            }*/

        }
    }
}
