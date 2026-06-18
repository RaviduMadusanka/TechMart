package lk.techmart.ejb;

import jakarta.ejb.Stateful;
import java.util.HashMap;
import java.util.Map;

@Stateful
public class ShoppingCartBean {

    private Map<Long, Integer> cartItems = new HashMap<>();

    public void addItem(Long productId, int quantity) {
        if (cartItems.containsKey(productId)) {
            int currentQty = cartItems.get(productId);
            cartItems.put(productId, currentQty + quantity);
        } else {

            cartItems.put(productId, quantity);
        }
    }

    public void removeItem(Long productId) {
        cartItems.remove(productId);
    }

    public Map<Long, Integer> getCartItems() {
        return cartItems;
    }


    public void clearCart() {
        cartItems.clear();
    }

}
