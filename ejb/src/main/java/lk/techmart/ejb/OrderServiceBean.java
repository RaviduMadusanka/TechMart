package lk.techmart.ejb;

import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.techmart.core.dto.OrderDTO;
import lk.techmart.core.entity.*;
import lk.techmart.core.service.InventoryService;
import lk.techmart.core.service.OrderService;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Stateless
public class OrderServiceBean implements OrderService {

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

    @EJB
    private InventoryService inventoryService;

    @EJB
    private NotificationServiceBean notificationService;

    @Override
    public List<OrderDTO> getAllOrders() {
        List<Orders> ordersList = em.createQuery("SELECT o FROM Orders o ORDER BY o.orderId DESC", Orders.class).getResultList();
        List<OrderDTO> dtos = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");

        for (Orders o : ordersList) {
            OrderDTO dto = new OrderDTO();
            dto.setOrderId(o.getOrderId());

            if (o.getCustomer() != null) {
                String fName = o.getCustomer().getFirstName() != null ? o.getCustomer().getFirstName() : "";
                String lName = o.getCustomer().getLastName() != null ? o.getCustomer().getLastName() : "";
                dto.setCustomerName((fName + " " + lName).trim());
                dto.setCustomerEmail(o.getCustomer().getEmail());
            }

            if (o.getOrderDate() != null) {
                dto.setOrderDate(sdf.format(o.getOrderDate()));
            }

            dto.setTotalAmount(o.getTotalAmount());
            dto.setShipping_address(o.getShipping_address() == null ? "None Shipping Address" : o.getShipping_address());

            if (o.getOrderStatus() != null) {
                dto.setStatus(o.getOrderStatus().getStatusName());
            } else {
                dto.setStatus("Pending");
            }

            dtos.add(dto);
        }
        return dtos;
    }

    @Override
    public OrderDTO getOrderById(Long orderId) {

        Orders o = em.find(Orders.class, orderId);

        if (o == null) {
            return null;
        }

        OrderDTO dto = new OrderDTO();

        dto.setOrderId(o.getOrderId());

        if (o.getCustomer() != null) {
            dto.setCustomerName(o.getCustomer().getFirstName() + " " +o.getCustomer().getLastName());

            dto.setCustomerEmail(o.getCustomer().getEmail());
            dto.setPhone(o.getCustomer().getPhone());
        }

        dto.setShipping_address(o.getShipping_address());

        if (o.getOrderDate() != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
            dto.setOrderDate(sdf.format(o.getOrderDate()));
        }

        dto.setTotalAmount(o.getTotalAmount());

        if (o.getOrderStatus() != null) {
            dto.setStatus(o.getOrderStatus().getStatusName());
        }

        return dto;
    }

    @Override
    public boolean updateOrderStatus(Long orderId, String newStatus) {
        try {
            Orders order = em.find(Orders.class, orderId);
            if (order == null) return false;

            OrderStatus statusObj = em.createQuery("SELECT s FROM OrderStatus s WHERE s.statusName = :name", OrderStatus.class)
                    .setParameter("name", newStatus)
                    .getSingleResult();

            order.setOrderStatus(statusObj);
            em.merge(order);
            em.flush();

            notificationService.sendOrderNotification(order.getCustomer().getCustomerId(),"ORD-" + orderId, newStatus);

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<String> getAllOrderStatuses() {
        return em.createQuery("SELECT s.statusName FROM OrderStatus s", String.class).getResultList();
    }

    @Override
    public Long placeOrder(Long customerId, Map<Long, Integer> cartItems, String address) throws Exception {

        Customer customer = em.find(Customer.class, customerId);
        if (customer == null) {
            throw new RuntimeException("No Customer! ID: " + customerId);
        }

        OrderStatus pendingStatus = em.createQuery("SELECT s FROM OrderStatus s WHERE s.statusName = 'Pending'", OrderStatus.class).getSingleResult();

        Orders order = new Orders();
        order.setCustomer(customer);
        order.setTotalAmount(BigDecimal.ZERO);
        order.setOrderStatus(pendingStatus);
        order.setShipping_address(address);

        em.persist(order);
        em.flush();

        BigDecimal totalAmount = BigDecimal.ZERO;

        for (Map.Entry<Long, Integer> entry : cartItems.entrySet()) {
            Long productId = entry.getKey();
            Integer quantity = entry.getValue();

            Product product = em.find(Product.class, productId);
            if (product == null) {
                throw new RuntimeException("None product id! ID: " + productId);
            }

            try {
                Inventory inventory = em.createQuery("SELECT i FROM Inventory i WHERE i.product.productId = :pid", Inventory.class)
                        .setParameter("pid", productId)
                        .getSingleResult();

                if (inventory == null || inventory.getQuantity() < quantity) {
                    throw new RuntimeException("Sorry! Product ID: " + productId + " No Stock!");
                }
            } catch (Exception e) {
                throw new RuntimeException("Product not found in inventory! ID: " + productId);
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

    @Override
    public boolean processPaymentSuccess(Long orderId) {

        try {
            Orders order = em.find(Orders.class, orderId);
            if (order == null) {
                return false;
            }

            if ("Processing".equals(order.getOrderStatus().getStatusName())) {
                return true;
            }

            OrderStatus paidStatus = em.createQuery("SELECT s FROM OrderStatus s WHERE s.statusName = 'Processing'", OrderStatus.class).getSingleResult();
            order.setOrderStatus(paidStatus);

            List<OrderItem> items = em.createQuery("SELECT i FROM OrderItem i WHERE i.order.orderId = :oid", OrderItem.class)
                    .setParameter("oid", orderId)
                    .getResultList();

            for (OrderItem item : items) {
                Long productId = item.getProduct().getProductId();
                int purchasedQty = item.getQuantity();
                try {
                    Inventory inventory = em.createQuery("SELECT i FROM Inventory i WHERE i.product.productId = :pid", Inventory.class)
                            .setParameter("pid", productId)
                            .getSingleResult();

                    inventory.setQuantity(inventory.getQuantity() - purchasedQty);
                    em.merge(inventory);

                    int currentQty = inventory.getQuantity();
                    int reorderLevel = inventory.getReorderLevel() != null ? inventory.getReorderLevel() : 10;

                    if (currentQty <= reorderLevel) {
                        notificationService.sendInventoryAlert(item.getProduct().getProductName(), currentQty, reorderLevel);
                    }

                } catch (Exception e) {
                    System.out.println("Could not update inventory for Product ID: " + productId);
                }
            }

            try {
                Long customerId = order.getCustomer().getCustomerId();
                String deleteQuery = "DELETE FROM cart_items WHERE cart_id = (SELECT cart_id FROM shopping_cart WHERE customer_id = ?)";
                int deletedCount = em.createNativeQuery(deleteQuery).setParameter(1, customerId).executeUpdate();
            } catch (Exception e) {
                System.out.println("Error deleting from cart_items: " + e.getMessage());
            }

            em.merge(order);
            em.flush();

            notificationService.sendOrderNotification(order.getCustomer().getCustomerId(),"ORD-" + orderId, "Payment Successful / Processing");
            notificationService.sendEmailDirectAsync(order.getCustomer().getEmail(),
                    "Payment for your order ORD-" + orderId + " was successful. We are processing it now!");
            return true;

        } catch (Exception e) {
            System.out.println("Error in processing payment success: " + e.getMessage());
            return false;
        }
    }

    @Override
    public Long getCustomerIdByOrderId(Long orderId) {
        Orders order = em.find(Orders.class, orderId);
        return (order != null) ? order.getCustomer().getCustomerId() : null;
    }


}
