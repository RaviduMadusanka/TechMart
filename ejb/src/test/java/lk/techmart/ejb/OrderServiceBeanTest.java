package lk.techmart.ejb;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import lk.techmart.core.entity.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("OrderServiceBean - business logic tests")
class OrderServiceBeanTest {

    @Mock
    private EntityManager em;

    @Mock
    private NotificationServiceBean notificationService;

    private OrderServiceBean orderServiceBean;

    @BeforeEach
    void setUp() throws Exception {
        orderServiceBean = new OrderServiceBean();
        setField(orderServiceBean, "em", em);
        setField(orderServiceBean, "notificationService", notificationService);
    }

    private void setField(Object target, String fieldName, Object value) throws Exception {
        Field f = target.getClass().getDeclaredField(fieldName);
        f.setAccessible(true);
        f.set(target, value);
    }

    @Test
    @DisplayName("updateOrderStatus() returns false when order does not exist")
    void updateOrderStatus_orderNotFound_returnsFalse() {
        when(em.find(Orders.class, 999L)).thenReturn(null);

        boolean result = orderServiceBean.updateOrderStatus(999L, "Shipped");

        assertFalse(result);
        verifyNoInteractions(notificationService);
    }

    @Test
    @DisplayName("updateOrderStatus() persists new status and triggers a JMS order notification")
    void updateOrderStatus_success_sendsNotification() {
        Orders order = new Orders();
        order.setOrderId(1L);
        Customer customer = new Customer();
        customer.setCustomerId(5L);
        order.setCustomer(customer);

        OrderStatus shipped = new OrderStatus();
        shipped.setStatusName("Shipped");

        TypedQuery<OrderStatus> statusQuery = mock(TypedQuery.class);
        when(em.find(Orders.class, 1L)).thenReturn(order);
        when(em.createQuery(anyString(), eq(OrderStatus.class))).thenReturn(statusQuery);
        when(statusQuery.setParameter(anyString(), any())).thenReturn(statusQuery);
        when(statusQuery.getSingleResult()).thenReturn(shipped);

        boolean result = orderServiceBean.updateOrderStatus(1L, "Shipped");

        assertTrue(result);
        assertEquals("Shipped", order.getOrderStatus().getStatusName());
        verify(em).merge(order);
        verify(notificationService).sendOrderNotification(5L, "ORD-1", "Shipped");
    }

    @Test
    @DisplayName("placeOrder() throws when a cart item references a non-existent product")
    void placeOrder_invalidProduct_throws() {
        Customer customer = new Customer();
        customer.setCustomerId(1L);
        when(em.find(Customer.class, 1L)).thenReturn(customer);

        TypedQuery<OrderStatus> statusQuery = mock(TypedQuery.class);
        OrderStatus pending = new OrderStatus();
        pending.setStatusName("Pending");
        when(em.createQuery(anyString(), eq(OrderStatus.class))).thenReturn(statusQuery);
        when(statusQuery.getSingleResult()).thenReturn(pending);

        when(em.find(Product.class, 42L)).thenReturn(null);

        Map<Long, Integer> cart = new HashMap<>();
        cart.put(42L, 2);

        assertThrows(RuntimeException.class, () -> orderServiceBean.placeOrder(1L, cart, "123 Galle Rd"));
    }

    @Test
    @DisplayName("placeOrder() throws when customer does not exist")
    void placeOrder_unknownCustomer_throws() {
        when(em.find(Customer.class, 77L)).thenReturn(null);

        assertThrows(RuntimeException.class,
                () -> orderServiceBean.placeOrder(77L, new HashMap<>(), "addr"));
    }

    @Test
    @DisplayName("processPaymentSuccess() triggers a low-stock JMS inventory alert when reorder level is breached")
    void processPaymentSuccess_lowStock_triggersInventoryAlert() {
        Orders order = new Orders();
        order.setOrderId(10L);
        Customer customer = new Customer();
        customer.setCustomerId(3L);
        customer.setEmail("test@techmart.lk");
        order.setCustomer(customer);
        order.setOrderStatus(new OrderStatus());
        order.getOrderStatus().setStatusName("Pending");

        when(em.find(Orders.class, 10L)).thenReturn(order);

        OrderStatus processing = new OrderStatus();
        processing.setStatusName("Processing");
        TypedQuery<OrderStatus> statusQuery = mock(TypedQuery.class);
        when(em.createQuery(startsWith("SELECT s FROM OrderStatus"), eq(OrderStatus.class))).thenReturn(statusQuery);
        when(statusQuery.getSingleResult()).thenReturn(processing);

        Product product = new Product();
        product.setProductId(100L);
        product.setProductName("USB Cable");

        OrderItem item = new OrderItem();
        item.setProduct(product);
        item.setQuantity(5);

        TypedQuery<OrderItem> itemQuery = mock(TypedQuery.class);
        when(em.createQuery(startsWith("SELECT i FROM OrderItem"), eq(OrderItem.class))).thenReturn(itemQuery);
        when(itemQuery.setParameter(anyString(), any())).thenReturn(itemQuery);
        when(itemQuery.getResultList()).thenReturn(java.util.List.of(item));

        Inventory inventory = new Inventory();
        inventory.setQuantity(8);
        inventory.setReorderLevel(10);

        TypedQuery<Inventory> invQuery = mock(TypedQuery.class);
        when(em.createQuery(startsWith("SELECT i FROM Inventory"), eq(Inventory.class))).thenReturn(invQuery);
        when(invQuery.setParameter(anyString(), any())).thenReturn(invQuery);
        when(invQuery.getSingleResult()).thenReturn(inventory);

        boolean result = orderServiceBean.processPaymentSuccess(10L);

        assertTrue(result);
        verify(notificationService).sendInventoryAlert(eq("USB Cable"), eq(3), eq(10));
        verify(notificationService).sendOrderNotification(eq(3L), eq("ORD-10"), anyString());
        verify(notificationService).sendEmailDirectAsync(eq("test@techmart.lk"), anyString());
    }
}
