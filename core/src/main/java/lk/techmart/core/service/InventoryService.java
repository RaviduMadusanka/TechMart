package lk.techmart.core.service;

import jakarta.ejb.Local;

@Local
public interface InventoryService {

    void addStock(Long productId, int quantity);
    boolean reduceStock(Long productId, int quantity);
    int getAvailableStock(Long productId);
    int getLowStockCount(int threshold);

}
