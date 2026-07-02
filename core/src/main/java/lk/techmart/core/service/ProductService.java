package lk.techmart.core.service;

import jakarta.ejb.Local;
import lk.techmart.core.dto.*;

import java.util.List;

@Local
public interface ProductService {

    void addProduct(ProductDTO productDTO,Long userId);
    void updateProduct(ProductDTO productDTO);
    ProductDTO getProductById(Long productId);
    boolean updateInventoryQuantity(Long inventoryId, Integer newQuantity,Long userId);

    List<ProductDTO> getAllProducts();
    List<CategoryDTO> getAllCategories();
    List<BrandDTO> getAllBrands();
    List<WarehousesDTO> getAllWarehouses();
    List<InventoryDTO> getAllInventory();

    boolean addCategory(CategoryDTO categoryDTO);
    boolean addBrand(BrandDTO brandDTO);

}
