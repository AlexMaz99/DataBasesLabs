import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int InvoiceNumber;
    private int Quantity;

    @ManyToMany(cascade = CascadeType.PERSIST)
    private Set<Product> includesProducts = new HashSet<>();

    public Invoice(int quantity) {
        Quantity = quantity;
    }

    public Invoice() {
    }

    public void addProduct(Product product){
        includesProducts.add(product);
        this.Quantity += 1;
    }

    public int getQuantity() {
        return Quantity;
    }

    public Set<Product> getIncludesProducts() {
        return includesProducts;
    }

    public int getInvoiceNumber() {
        return InvoiceNumber;
    }
}
