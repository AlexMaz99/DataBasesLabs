using System;
using System.Collections.Generic;
using System.Text;

namespace AMazurProductEF
{
    //[Table("Suppliers")]
    class Supplier: Company
    {
        public Supplier()
        {
            Products = new List<Product>();
        }

        public string BackAccountNumber { get; set; }

        public virtual List<Product> Products { get; set; }
    }
}