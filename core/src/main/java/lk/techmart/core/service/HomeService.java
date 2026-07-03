package lk.techmart.core.service;

import jakarta.ejb.Local;
import lk.techmart.core.dto.CategoryDTO;
import lk.techmart.core.dto.ProductDTO;

import java.util.List;

@Local
public interface HomeService {

    List<CategoryDTO> getAllCategories();
    List<ProductDTO> getLatestProducts(int limit);
    List<ProductDTO> getFilteredProducts(Long categoryId, String sort, int limit);

}
