import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int ProductId;
    private String ProductName;
    private int UnitsOnStock;

    @ManyToOne
    @JoinColumn(name="SUPPLIED_BY")
    private Supplier supplier;

    @ManyToOne
    @JoinColumn(name="CATEGORY")
    private Category category;

    @ManyToMany(mappedBy = "includesProducts", fetch = FetchType.EAGER, cascade = CascadeType.PERSIST)
    private Set<Invoice> canBeSoldIn = new HashSet<>();

    public Product(String productName, int unitsOnStock) {
        ProductName = productName;
        UnitsOnStock = unitsOnStock;
    }

    public Product() {
        // for Hibernate
    }

    public Product(String productName, int unitsOnStock, Supplier supplier) {
        ProductName = productName;
        UnitsOnStock = unitsOnStock;
        this.supplier = supplier;
    }

    public void setSupplier(Supplier supplier){
        this.supplier = supplier;
        if (!supplier.suppliesProduct(this)){
            supplier.addProduct(this);
        }
    }

    public Category getCategory(){ return this.category; }

    public void setCategory(Category category){
        this.category = category;
        if (!category.getProducts().contains(this))
            category.addProduct(this);
    }

    @Override
    public String toString() {
        return "Product{" +
                "ProductName='" + ProductName + '\'' +
                ", UnitsOnStock=" + UnitsOnStock +
                '}';
    }

    public String getProductName() {
        return ProductName;
    }

    public Set<Invoice> getCanBeSoldIn() {
        return canBeSoldIn;
    }
}
