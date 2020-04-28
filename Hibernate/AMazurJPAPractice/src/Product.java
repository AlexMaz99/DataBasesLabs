import javax.persistence.*;

@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public int ProductId;
    public String ProductName;
    public int UnitsOnStock;


    public Product(String productName, int unitsOnStock) {
        ProductName = productName;
        UnitsOnStock = unitsOnStock;
    }

    public Product() {
        // for Hibernate
    }

    @Override
    public String toString() {
        return "Product{" +
                "ProductName='" + ProductName + '\'' +
                ", UnitsOnStock=" + UnitsOnStock +
                '}';
    }
}
