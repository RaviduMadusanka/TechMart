package lk.techmart.ejb;

import jakarta.annotation.PostConstruct;
import jakarta.ejb.Lock;
import jakarta.ejb.LockType;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import lk.techmart.core.service.InventoryService;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Singleton
@Startup
public class InventoryServiceBean implements InventoryService {

    private Map<Long, Integer> stockMap;
    private Map<Long, Integer> stockMemory = new HashMap<>();

    @PostConstruct
    public void init() {
        stockMap = new ConcurrentHashMap<>();
        System.out.println("TechMart Inventory System Started!");

        stockMap.put(1L, 50);
        stockMap.put(2L, 30);
    }

    @Override
    @Lock(LockType.WRITE)
    public void addStock(Long productId, int quantity) {
        int currentStock = stockMap.getOrDefault(productId, 0);
        stockMap.put(productId, currentStock + quantity);
        System.out.println("Stock Added: Product " + productId + " | New Qty: " + stockMap.get(productId));
    }

    @Override
    @Lock(LockType.WRITE)
    public boolean reduceStock(Long productId, int quantity) {
        int currentStock = stockMap.getOrDefault(productId, 0);

        if (currentStock >= quantity) {
            stockMap.put(productId, currentStock - quantity);
            System.out.println("Stock Reduced: Product " + productId + " | Remaining: " + stockMap.get(productId));
            return true;
        }

        System.out.println("Out of Stock: Product " + productId);
        return false;
    }

    @Override
    @Lock(LockType.READ)
    public int getAvailableStock(Long productId) {
        return stockMap.getOrDefault(productId, 0);
    }

    @Override
    public int getLowStockCount(int threshold) {
        int count = 0;
        for (Integer qty : stockMemory.values()) {
            if (qty < threshold) count++;
        }
        return count;
    }

}
