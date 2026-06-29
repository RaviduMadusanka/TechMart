package lk.techmart.core.service;

import jakarta.ejb.Local;
import lk.techmart.core.dto.OrderDTO;
import java.util.List;
import java.util.Map;

public interface OrderService {


    List<OrderDTO> getAllOrders();
    OrderDTO getOrderById(Long orderId);
    boolean updateOrderStatus(Long orderId, String newStatus);
    List<String> getAllOrderStatuses();
    Long placeOrder(Long customerId, Map<Long, Integer> cartItems) throws Exception;

}
