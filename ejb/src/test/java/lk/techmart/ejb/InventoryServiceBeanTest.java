package lk.techmart.ejb;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("InventoryServiceBean - Singleton lifecycle & stock cache tests")
class InventoryServiceBeanTest {

    private InventoryServiceBean bean;

    @BeforeEach
    void setUp() {
        bean = new InventoryServiceBean();
        bean.init();
    }

    @Test
    @DisplayName("init() (@PostConstruct) pre-populates the in-memory stock cache")
    void postConstruct_populatesInitialStock() {
        assertEquals(50, bean.getAvailableStock(1L));
        assertEquals(30, bean.getAvailableStock(2L));
    }

    @Test
    @DisplayName("getAvailableStock() returns 0 for a product that was never cached")
    void getAvailableStock_unknownProduct_returnsZero() {
        assertEquals(0, bean.getAvailableStock(999L));
    }

    @Test
    @DisplayName("addStock() increments the in-memory cache for an existing product")
    void addStock_incrementsExistingStock() {
        bean.addStock(1L, 20);
        assertEquals(70, bean.getAvailableStock(1L));
    }

    @Test
    @DisplayName("addStock() creates a new cache entry for a previously unseen product")
    void addStock_newProduct_createsEntry() {
        bean.addStock(500L, 15);
        assertEquals(15, bean.getAvailableStock(500L));
    }
}
