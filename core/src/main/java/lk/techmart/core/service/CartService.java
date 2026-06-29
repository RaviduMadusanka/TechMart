package lk.techmart.core.service;

import lk.techmart.core.entity.ShoppingCart;

public interface CartService {

    ShoppingCart getCartByCustomer(Long customerId);
    ShoppingCart createCart(Long customerId);
    void addItem(Long customerId, Long productId, int quantity);
    void updateItem(Long customerId, Long productId, int quantity);
    void removeItem(Long customerId, Long productId);
    void clearCart(Long customerId);
}
