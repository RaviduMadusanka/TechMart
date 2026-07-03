package lk.techmart.ejb;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import lk.techmart.core.dto.ProductDTO;
import lk.techmart.core.dto.CategoryDTO;
import lk.techmart.core.dto.BrandDTO;
import lk.techmart.core.entity.Brand;
import lk.techmart.core.entity.Category;
import lk.techmart.core.entity.Product;
import lk.techmart.core.service.SearchService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Arrays;

@Stateless
public class SearchServiceBean implements SearchService {

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

    @Override
    public List<ProductDTO> advancedSearch(String keyword, String[] categories, String[] brands, Double minPrice, Double maxPrice, String sort, int offset, int limit) {
        StringBuilder jpql = new StringBuilder("SELECT p FROM Product p WHERE 1=1 ");
        Map<String, Object> parameters = buildFilterQuery(jpql, keyword, categories, brands, minPrice, maxPrice);

        if ("Price: Low to High".equals(sort)) jpql.append("ORDER BY p.price ASC ");
        else if ("Price: High to Low".equals(sort)) jpql.append("ORDER BY p.price DESC ");
        else if ("Newest First".equals(sort)) jpql.append("ORDER BY p.productId DESC ");

        TypedQuery<Product> query = em.createQuery(jpql.toString(), Product.class);
        for (Map.Entry<String, Object> entry : parameters.entrySet()) {
            query.setParameter(entry.getKey(), entry.getValue());
        }

        query.setFirstResult(offset);
        query.setMaxResults(limit);

        List<Product> entities = query.getResultList();
        List<ProductDTO> dtos = new ArrayList<>();
        for (Product p : entities) {
            ProductDTO dto = new ProductDTO();
            dto.setProductId(p.getProductId());
            dto.setProductName(p.getProductName());
            dto.setPrice(p.getPrice());
            dto.setImageUrl(p.getImageUrl());
            if (p.getCategory() != null) {
                lk.techmart.core.dto.CategoryDTO catDto = new lk.techmart.core.dto.CategoryDTO();
                catDto.setName(p.getCategory().getName());
                dto.setCategory(catDto);
            }
            if (p.getBrand() != null) {
                lk.techmart.core.dto.BrandDTO brandDto = new lk.techmart.core.dto.BrandDTO();
                brandDto.setName(p.getBrand().getName());
                dto.setBrand(brandDto);
            }
            dtos.add(dto);
        }
        return dtos;
    }

    @Override
    public long getAdvancedSearchCount(String keyword, String[] categories, String[] brands, Double minPrice, Double maxPrice) {
        StringBuilder jpql = new StringBuilder("SELECT COUNT(p) FROM Product p WHERE 1=1 ");
        Map<String, Object> parameters = buildFilterQuery(jpql, keyword, categories, brands, minPrice, maxPrice);

        TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
        for (Map.Entry<String, Object> entry : parameters.entrySet()) {
            query.setParameter(entry.getKey(), entry.getValue());
        }
        return query.getSingleResult();
    }

    private Map<String, Object> buildFilterQuery(StringBuilder jpql, String keyword, String[] categories, String[] brands, Double minPrice, Double maxPrice) {
        Map<String, Object> parameters = new HashMap<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            jpql.append("AND (LOWER(p.productName) LIKE :kw OR LOWER(p.category.name) LIKE :kw) ");
            parameters.put("kw", "%" + keyword.toLowerCase() + "%");
        }
        if (minPrice != null) {
            jpql.append("AND p.price >= :minP ");
            parameters.put("minP", minPrice);
        }
        if (maxPrice != null) {
            jpql.append("AND p.price <= :maxP ");
            parameters.put("maxP", maxPrice);
        }
        if (categories != null && categories.length > 0) {
            jpql.append("AND p.category.name IN :cats ");
            parameters.put("cats", Arrays.asList(categories));
        }
        if (brands != null && brands.length > 0) {
            jpql.append("AND p.brand.name IN :brnds ");
            parameters.put("brnds", Arrays.asList(brands));
        }
        return parameters;
    }

    @Override
    public List<CategoryDTO> getAllCategories() {
        List<Category> cats = em.createQuery("SELECT c FROM Category c", Category.class).getResultList();
        List<CategoryDTO> dtos = new ArrayList<>();
        for(Category c : cats) {
            CategoryDTO dto = new CategoryDTO();
            dto.setCategoryId(c.getCategoryId());
            dto.setName(c.getName());
            dtos.add(dto);
        }
        return dtos;
    }

    @Override
    public List<BrandDTO> getAllBrands() {
        List<Brand> brands = em.createQuery("SELECT b FROM Brand b", Brand.class).getResultList();
        List<BrandDTO> dtos = new ArrayList<>();
        for(Brand b : brands) {
            BrandDTO dto = new BrandDTO();
            dto.setBrandId(b.getBrandId());
            dto.setName(b.getName());
            dtos.add(dto);
        }
        return dtos;
    }
}