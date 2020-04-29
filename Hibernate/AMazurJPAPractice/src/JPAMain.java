import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;

public class JPAMain {
    private static EntityManagerFactory entityManagerFactory;

    private static EntityManager getEntityManager(){
        if (entityManagerFactory == null)
            entityManagerFactory = Persistence.createEntityManagerFactory("derby");
        return entityManagerFactory.createEntityManager();
    }

    public static void main(String argv[]){
        EntityManager entityManager = getEntityManager();
        EntityTransaction etx = entityManager.getTransaction();

        // EXERCISE XI

//        etx.begin();
//
//        Supplier supplier = new Supplier("Furniture Supplier", "Street 3", "Rome");
//        Category category = new Category("Furniture");
//        Product product1 = new Product("Bed", 3);
//        Product product2 = new Product("Chair", 15);
//        Product product3 = new Product("Table", 2);
//        supplier.addProduct(product1);
//        supplier.addProduct(product2);
//        supplier.addProduct(product3);
//        category.addProduct(product1);
//        category.addProduct(product2);
//        category.addProduct(product3);
//
//        Invoice invoice1 = new Invoice(0);
//        Invoice invoice2 = new Invoice(0);
//
//        invoice1.addProduct(product1);
//        invoice2.addProduct(product1);
//        invoice2.addProduct(product2);
//        invoice2.addProduct(product3);
//
//        entityManager.persist(product1);
//        entityManager.persist(product2);
//        entityManager.persist(product3);
//        entityManager.persist(category);
//        entityManager.persist(supplier);
//
//        etx.commit();
//        entityManager.close();

        // EXERCISE XII a

//        etx.begin();
//
//        Address address1 = new Address("England", "London", "Downing Street", "33-330");
//        Address address2 = new Address("Italy", "Rome", "Street1", "33-395");
//        Supplier supplier1 = new Supplier("Supplier1", address1);
//        Supplier supplier2 = new Supplier("Supplier2", address2);
//        Supplier supplier3 = new Supplier("Supplier3", address1);
//
//        entityManager.persist(supplier1);
//        entityManager.persist(supplier2);
//        entityManager.persist(supplier3);
//
//        etx.commit();
//        entityManager.close();

        // EXERCISE XII c

//        etx.begin();
//
//        Supplier supplier1 = new Supplier("Supplier1", "England", "London", "Downing Street", "33-330");
//        Supplier supplier2 = new Supplier("Supplier2", "Italy", "Rome", "Street1", "33-395");
//        Supplier supplier3 = new Supplier("Supplier3", "Poland", "Cracow", "Kawiory", "33-300");
//
//        entityManager.persist(supplier1);
//        entityManager.persist(supplier2);
//        entityManager.persist(supplier3);
//
//        etx.commit();
//        entityManager.close();

        // EXERCISE XIII

        etx.begin();

        Supplier supplier1 = new Supplier("Supplier1", "England", "London", "Downing Street", "33-330", "123456789");
        Supplier supplier2 = new Supplier("Supplier2", "Italy", "Rome", "Street1", "33-395", "987654321");
        Customer customer1 = new Customer("Customer1", "Poland", "Cracow", "Kawiory", "33-300", 0.5);
        Customer customer2 = new Customer("Customer2", "Poland", "Warsaw", "Street2", "33-360", 0.2);

        entityManager.persist(supplier1);
        entityManager.persist(supplier2);
        entityManager.persist(customer1);
        entityManager.persist(customer2);

        etx.commit();
        entityManager.close();


    }
}
