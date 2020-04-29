import org.hibernate.*;
import org.hibernate.query.Query;
import org.hibernate.cfg.Configuration;

import javax.persistence.metamodel.EntityType;

import java.util.Map;

public class Main {
    private static final SessionFactory ourSessionFactory;

    static {
        try {
            Configuration configuration = new Configuration();
            configuration.configure();

            ourSessionFactory = configuration.buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static Session getSession() throws HibernateException {
        return ourSessionFactory.openSession();
    }

    public static void main(final String[] args) throws Exception {
        final Session session = getSession();

        try {

            Transaction transaction = session.beginTransaction();
            Product product1 = new Product("TV", 2);
            Product product2 = new Product("Computer", 1);
            Product product3 = new Product("Telephone", 4);
            //Supplier supplier = new Supplier("Media Supplier", "Country1", "City1", "Street1", "ZipCode1");
            Category category = new Category("Electronics");
            Invoice invoice1 = new Invoice(0);
            Invoice invoice2 = new Invoice(0);

            //supplier.addProduct(product1);
            //supplier.addProduct(product2);
            //supplier.addProduct(product3);
            category.addProduct(product1);
            category.addProduct(product2);
            category.addProduct(product3);
            invoice1.addProduct(product1);
            invoice1.addProduct(product2);
            invoice2.addProduct(product1);
            invoice2.addProduct(product2);
            invoice2.addProduct(product3);

            session.save(product1);
            session.save(product2);
            session.save(product3);
            //session.save(supplier);
            session.save(category);
            session.save(invoice1);
            session.save(invoice2);
            transaction.commit();


//            Transaction transaction = session.beginTransaction();
//            Product product = session.get(Product.class, 8);
//            for (Invoice invoice: product.getCanBeSoldIn())
//                System.out.println("Invoice number: "+ invoice.getInvoiceNumber());
//
//            transaction.commit();

            System.out.println("querying all the managed entities...");
            final Metamodel metamodel = session.getSessionFactory().getMetamodel();
            for (EntityType<?> entityType : metamodel.getEntities()) {
                final String entityName = entityType.getName();
                final Query query = session.createQuery("from " + entityName);
                System.out.println("executing: " + query.getQueryString());
                for (Object o : query.list()) {
                    System.out.println("  " + o);
                }
            }
        } finally {
            session.close();
        }
    }
}