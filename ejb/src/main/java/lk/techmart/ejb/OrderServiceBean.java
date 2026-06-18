package lk.techmart.ejb;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.techmart.core.entity.Customer;
import lk.techmart.core.entity.Orders;
import lk.techmart.core.entity.OrderItem;
import lk.techmart.core.entity.Product;

import java.math.BigDecimal;
import java.util.Map;

@Stateless
public class OrderServiceBean {

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

    public Long placeOrder(Long customerId, Map<Long, Integer> cartItems) throws Exception {

        Customer customer = em.find(Customer.class, customerId);
        if (customer == null) {
            throw new Exception("Customer kenek na! ID: " + customerId);
        }

        Orders order = new Orders();
        order.setCustomer(customer);
        order.setOrderStatus("PENDING");
        order.setTotalAmount(BigDecimal.ZERO);

        em.persist(order);
        em.flush();

        BigDecimal totalAmount = BigDecimal.ZERO;

        for (Map.Entry<Long, Integer> entry : cartItems.entrySet()) {
            Long productId = entry.getKey();
            Integer quantity = entry.getValue();

            Product product = em.find(Product.class, productId);
            if (product == null) {
                throw new Exception("Product eka na! ID: " + productId);
            }

            OrderItem item = new OrderItem();
            item.setOrder(order);
            item.setProduct(product);
            item.setQuantity(quantity);
            item.setUnitPrice(product.getPrice());

            em.persist(item);


            BigDecimal itemTotal = product.getPrice().multiply(new BigDecimal(quantity));
            totalAmount = totalAmount.add(itemTotal);
        }

        order.setTotalAmount(totalAmount);
        em.merge(order);
        em.flush();

        return order.getOrderId();
    }

}
