package lk.techmart.core.dto;

public class InventoryDTO {
    private Long inventoryId;
    private Integer quantity;
    private Integer reorderLevel;
    private ProductDTO product;
    private WarehousesDTO warehouse;
    private Long userId;

    public Long getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(Long inventoryId) {
        this.inventoryId = inventoryId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Integer getReorderLevel() {
        return reorderLevel;
    }

    public void setReorderLevel(Integer reorderLevel) {
        this.reorderLevel = reorderLevel;
    }

    public ProductDTO getProduct() {
        return product;
    }

    public void setProduct(ProductDTO product) {
        this.product = product;
    }

    public WarehousesDTO getWarehouse() {
        return warehouse;
    }

    public void setWarehouse(WarehousesDTO warehouse) {
        this.warehouse = warehouse;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }
}
