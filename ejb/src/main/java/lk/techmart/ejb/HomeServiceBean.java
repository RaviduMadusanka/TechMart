package lk.techmart.ejb;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.techmart.core.dto.BrandDTO;
import lk.techmart.core.dto.CategoryDTO;
import lk.techmart.core.dto.ProductDTO;
import lk.techmart.core.entity.Category;
import lk.techmart.core.entity.Product;
import lk.techmart.core.service.HomeService;

import java.util.ArrayList;
import java.util.List;

@Stateless
public class HomeServiceBean implements HomeService {

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

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
    public List<ProductDTO> getLatestProducts(int limit) {

        List<Product> entities = em.createQuery(
                        "SELECT p FROM Product p ORDER BY p.productId DESC",
                        Product.class
                )
                .setMaxResults(limit)
                .getResultList();

        List<ProductDTO> dtos = new ArrayList<>();

        for (Product p : entities) {
            ProductDTO dto = new ProductDTO();
            dto.setProductId(p.getProductId());
            dto.setProductName(p.getProductName());
            dto.setPrice(p.getPrice());
            dto.setImageUrl(p.getImageUrl());
            dtos.add(dto);
        }

        return dtos;
    }
}
