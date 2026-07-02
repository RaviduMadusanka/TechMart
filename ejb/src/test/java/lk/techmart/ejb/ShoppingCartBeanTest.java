package lk.techmart.ejb;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("ShoppingCartBean - business logic tests")
class ShoppingCartBeanTest {

    private ShoppingCartBean cartBean;

    @BeforeEach
    void setUp() {
        cartBean = new ShoppingCartBean();
    }

    @Test
    @DisplayName("addItem() adds a new product with the given quantity")
    void addItem_newProduct_addsWithQuantity() {
        cartBean.addItem(1L, 3);

        Map<Long, Integer> items = cartBean.getCartItems();

        assertEquals(1, items.size());
        assertEquals(3, items.get(1L));
    }

    @Test
    @DisplayName("addItem() accumulates quantity when the product is already in the cart")
    void addItem_existingProduct_accumulatesQuantity() {
        cartBean.addItem(1L, 2);
        cartBean.addItem(1L, 5);

        Map<Long, Integer> items = cartBean.getCartItems();

        assertEquals(1, items.size());
        assertEquals(7, items.get(1L));
    }

    @Test
    @DisplayName("addItem() keeps separate entries for different products")
    void addItem_differentProducts_keptSeparately() {
        cartBean.addItem(1L, 2);
        cartBean.addItem(2L, 4);

        Map<Long, Integer> items = cartBean.getCartItems();

        assertEquals(2, items.size());
        assertEquals(2, items.get(1L));
        assertEquals(4, items.get(2L));
    }

    @Test
    @DisplayName("updateQuantity() sets a new quantity for an existing product")
    void updateQuantity_positiveQuantity_updatesValue() {
        cartBean.addItem(1L, 2);

        cartBean.updateQuantity(1L, 10);

        assertEquals(10, cartBean.getCartItems().get(1L));
    }

    @Test
    @DisplayName("updateQuantity() adds the product if it was not already present")
    void updateQuantity_newProduct_addsProduct() {
        cartBean.updateQuantity(5L, 4);

        assertEquals(4, cartBean.getCartItems().get(5L));
    }

    @Test
    @DisplayName("updateQuantity() removes the product when quantity is zero")
    void updateQuantity_zeroQuantity_removesProduct() {
        cartBean.addItem(1L, 2);

        cartBean.updateQuantity(1L, 0);

        assertFalse(cartBean.getCartItems().containsKey(1L));
    }

    @Test
    @DisplayName("updateQuantity() removes the product when quantity is negative")
    void updateQuantity_negativeQuantity_removesProduct() {
        cartBean.addItem(1L, 2);

        cartBean.updateQuantity(1L, -3);

        assertFalse(cartBean.getCartItems().containsKey(1L));
    }

    @Test
    @DisplayName("removeItem() removes an existing product from the cart")
    void removeItem_existingProduct_removesIt() {
        cartBean.addItem(1L, 2);
        cartBean.addItem(2L, 3);

        cartBean.removeItem(1L);

        Map<Long, Integer> items = cartBean.getCartItems();
        assertFalse(items.containsKey(1L));
        assertTrue(items.containsKey(2L));
    }

    @Test
    @DisplayName("removeItem() does nothing when the product is not in the cart")
    void removeItem_nonExistingProduct_doesNothing() {
        cartBean.addItem(1L, 2);

        cartBean.removeItem(99L);

        assertEquals(1, cartBean.getCartItems().size());
    }

    @Test
    @DisplayName("getCartItems() returns an empty map for a freshly created cart")
    void getCartItems_freshCart_isEmpty() {
        assertTrue(cartBean.getCartItems().isEmpty());
    }

    @Test
    @DisplayName("clearCart() empties all items from the cart")
    void clearCart_removesAllItems() {
        cartBean.addItem(1L, 2);
        cartBean.addItem(2L, 3);

        cartBean.clearCart();

        assertTrue(cartBean.getCartItems().isEmpty());
    }

    @Test
    @DisplayName("removeBean() clears the cart, mirroring @Remove lifecycle behavior")
    void removeBean_clearsCartBeforeRemoval() {
        cartBean.addItem(1L, 2);

        cartBean.removeBean();

        assertTrue(cartBean.getCartItems().isEmpty());
    }
}
