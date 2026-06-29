package lk.techmart.ejb;

import jakarta.ejb.Remove;
import jakarta.ejb.Stateful;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

@Stateful
public class ShoppingCartBean implements Serializable {

    private Map<Long, Integer> cart = new HashMap<>();

    public void addItem(Long productId, int quantity) {
        cart.put(productId, cart.getOrDefault(productId, 0) + quantity);
    }

    public void updateQuantity(Long productId, int quantity) {
        if (quantity > 0) {
            cart.put(productId, quantity);
        } else {
            removeItem(productId);
        }
    }

    public void removeItem(Long productId) {
        cart.remove(productId);
    }

    public Map<Long, Integer> getCartItems() {
        return cart;
    }

    public void clearCart() {
        cart.clear();
    }

    @Remove
    public void removeBean() {
        cart.clear();
        System.out.println("ShoppingCart Stateful Bean removed from memory!");
    }
}