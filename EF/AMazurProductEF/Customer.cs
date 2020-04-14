using System;
using System.Collections.Generic;
using System.Text;

namespace AMazurProductEF
{
    //[Table("Customers")]
    class Customer: Company
    {
        public float Discount { get; set; }
    }
}
