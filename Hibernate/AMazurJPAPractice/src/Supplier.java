import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Supplier {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int SupplierId;
    private String CompanyName;
    private String Street;
    private String City;

    @OneToMany
    @JoinColumn(name="SUPPLIED_BY")
    private Set<Product> suppliedProducts = new HashSet<>();


    public Supplier(String companyName, String street, String city) {
        CompanyName = companyName;
        Street = street;
        City = city;
    }

    public Supplier() {
    }

    public Supplier(String companyName, String street, String city, Product product) {
        CompanyName = companyName;
        Street = street;
        City = city;
        this.suppliedProducts.add(product);
    }

    public void addProduct(Product product){
        this.suppliedProducts.add(product);
        product.setSupplier(this);
    }

    public boolean suppliesProduct(Product product){
        return suppliedProducts.contains(product);
    }

    @Override
    public String toString() {
        return "Supplier{" +
                "CompanyName='" + CompanyName + '\'' +
                ", Street='" + Street + '\'' +
                ", City='" + City + '\'' +
                ", suppliedProducts=" + suppliedProducts +
                '}';
    }
}
