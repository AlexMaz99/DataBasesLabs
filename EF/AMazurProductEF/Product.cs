using System;
using System.Collections.Generic;
using System.Text;

namespace AMazurProductEF
{
    class Product
    {
        public int ProductID { get; set; }

        public string Name { get; set; }

        public int UnitsInStock { get; set; }

        public Supplier Supplier { get; set; }

        public Category Category { get; set; }

        public List<InvoiceProduct> InvoiceProducts { get; set; }
    }
}

