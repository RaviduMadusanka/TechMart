package lk.techmart.core.service;

import jakarta.ejb.Local;
import lk.techmart.core.dto.BrandDTO;
import lk.techmart.core.dto.CategoryDTO;
import lk.techmart.core.dto.ProductDTO;

import java.util.List;

@Local
public interface ProductService {

    void addProduct(ProductDTO productDTO);
    void updateProduct(ProductDTO productDTO);
    ProductDTO getProductById(Long productId);

    List<ProductDTO> getAllProducts();
    List<CategoryDTO> getAllCategories();
    List<BrandDTO> getAllBrands();

}
