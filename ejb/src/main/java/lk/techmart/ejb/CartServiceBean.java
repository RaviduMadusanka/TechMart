package lk.techmart.ejb;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.techmart.core.entity.CartItem;
import lk.techmart.core.entity.Customer;
import lk.techmart.core.entity.Product;
import lk.techmart.core.entity.ShoppingCart;
import lk.techmart.core.service.CartService;

@Stateless
public class CartServiceBean implements CartService {

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

    @Override
    public ShoppingCart getCartByCustomer(Long customerId) {
        try {
            return em.createQuery(
                            "SELECT c FROM ShoppingCart c WHERE c.customer.customerId = :id",
                            ShoppingCart.class)
                    .setParameter("id", customerId)
                    .getSingleResult();

        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public ShoppingCart createCart(Long customerId) {
        Customer customer = em.find(Customer.class, customerId);

        ShoppingCart cart = new ShoppingCart();
        cart.setCustomer(customer);

        em.persist(cart);

        return cart;
    }

    @Override
    public void addItem(Long customerId, Long productId, int quantity) {
        ShoppingCart cart = getCartByCustomer(customerId);

        if (cart == null) {
            cart = createCart(customerId);
        }

        Product product = em.find(Product.class, productId);

        CartItem item = null;

        for (CartItem c : cart.getItems()) {
            if (c.getProduct().getProductId().equals(productId)) {
                item = c;
                break;
            }
        }

        if (item == null) {

            item = new CartItem();
            item.setCart(cart);
            item.setProduct(product);
            item.setQuantity(quantity);

            em.persist(item);

            cart.getItems().add(item);

        } else {

            item.setQuantity(item.getQuantity() + quantity);
            em.merge(item);

        }

        em.merge(cart);
    }

    @Override
    public void updateItem(Long customerId, Long productId, int quantity) {

        ShoppingCart cart = getCartByCustomer(customerId);
        if (cart == null) return;

        CartItem itemToRemove = null;

        for (CartItem item : cart.getItems()) {
            if (item.getProduct().getProductId().equals(productId)) {
                if (quantity <= 0) {
                    itemToRemove = item;
                } else {
                    item.setQuantity(quantity);
                    em.merge(item);
                }
                break;
            }
        }

        if (itemToRemove != null) {
            cart.getItems().remove(itemToRemove);
            em.remove(em.contains(itemToRemove) ? itemToRemove : em.merge(itemToRemove));

        }

        em.merge(cart);
        em.flush();

    }

    @Override
    public void removeItem(Long customerId, Long productId) {

        updateItem(customerId, productId, 0);

    }

    @Override
    public void clearCart(Long customerId) {

        ShoppingCart cart = getCartByCustomer(customerId);

        if (cart == null) return;

        for (CartItem item : cart.getItems()) {
            em.remove(em.contains(item) ? item : em.merge(item));
        }

        cart.getItems().clear();

        em.merge(cart);

    }
}
