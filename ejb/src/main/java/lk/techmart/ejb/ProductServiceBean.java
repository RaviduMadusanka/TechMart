package lk.techmart.ejb;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.techmart.core.entity.Product;

import java.util.List;

@Stateless
public class ProductServiceBean {

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

    public void addProduct(Product product) {
        em.persist(product);
    }

    public List<Product> getAllProducts() {
        return em.createQuery("SELECT p FROM Product p", Product.class).getResultList();
    }

    public Product getProductById(Long productId) {
        return em.find(Product.class, productId);
    }

}
