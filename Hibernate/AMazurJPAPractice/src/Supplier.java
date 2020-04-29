import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Supplier extends Company{
    private String bankAccountNumber;

    @OneToMany
    @JoinColumn(name="SUPPLIED_BY")
    private Set<Product> suppliedProducts = new HashSet<>();

    public Supplier() {
    }

    public Supplier(String bankAccountNumber) {
        this.bankAccountNumber = bankAccountNumber;
    }

    public Supplier(String companyName, String country, String city, String street, String zipCode, String bankAccountNumber) {
        super(companyName, country, city, street, zipCode);
        this.bankAccountNumber = bankAccountNumber;
    }


    public void addProduct(Product product){
        this.suppliedProducts.add(product);
        product.setSupplier(this);
    }

    public boolean suppliesProduct(Product product){
        return suppliedProducts.contains(product);
    }

    public Set<Product> getSuppliedProducts() {
        return suppliedProducts;
    }

    public String getBankAccountNumber() {
        return bankAccountNumber;
    }

    public void setBankAccountNumber(String bankAccountNumber) {
        this.bankAccountNumber = bankAccountNumber;
    }
}
