package lk.techmart.core.service;

import lk.techmart.core.dto.ProductDTO;

import java.util.List;

public interface SearchService {
    List<ProductDTO> advancedSearch(String keyword, String[] categories, String[] brands, Double minPrice, Double maxPrice, String sort);
}
