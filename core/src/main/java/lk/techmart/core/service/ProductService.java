package lk.techmart.core.service;

import jakarta.ejb.Local;
import lk.techmart.core.dto.BrandDTO;
import lk.techmart.core.dto.CategoryDTO;
import lk.techmart.core.dto.ProductDTO;
import lk.techmart.core.dto.WarehousesDTO;

import java.util.List;

@Local
public interface ProductService {

    void addProduct(ProductDTO productDTO);
    void updateProduct(ProductDTO productDTO);
    ProductDTO getProductById(Long productId);

    List<ProductDTO> getAllProducts();
    List<CategoryDTO> getAllCategories();
    List<BrandDTO> getAllBrands();
    List<WarehousesDTO> getAllWarehouses();

    boolean addCategory(CategoryDTO categoryDTO);
    boolean addBrand(BrandDTO brandDTO);

}
