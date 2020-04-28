import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int CategoryId;
    private String Name;

    @OneToMany
    @JoinColumn(name="CATEGORY")
    private List<Product> Products = new ArrayList<>();


    public Category(String name) {
        Name = name;
    }

    public Category() {
    }

    public String getName() {
        return Name;
    }

    public List<Product> getProducts() {
        return Products;
    }

    public void addProduct(Product product) {
        this.Products.add(product);
        product.setCategory(this);
    }
}
