package lk.techmart.ejb;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.techmart.core.entity.Product;
import lk.techmart.core.dto.ProductDTO;
import lk.techmart.core.service.ProductService;

import java.util.ArrayList;
import java.util.List;

@Stateless
public class ProductServiceBean implements ProductService {

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

    @Override
    public void addProduct(ProductDTO dto) {
        Product entity = new Product();
        entity.setProductCode(dto.getProductCode());
        entity.setProductName(dto.getProductName());
        entity.setDescription(dto.getDescription());
        entity.setCategory(dto.getCategory());
        entity.setBrand(dto.getBrand());
        entity.setPrice(dto.getPrice());
        entity.setCostPrice(dto.getCostPrice());
        entity.setImageUrl(dto.getImageUrl());
        entity.setWeight(dto.getWeight());
        entity.setStatus(dto.getStatus() != null ? dto.getStatus() : "ACTIVE");

        em.persist(entity);
        em.flush();
    }

    @Override
    public List<ProductDTO> getAllProducts() {
        List<Product> entities = em.createQuery("SELECT p FROM Product p", Product.class).getResultList();
        List<ProductDTO> dtos = new ArrayList<>();

        for (Product p : entities) {
            ProductDTO dto = new ProductDTO();
            dto.setProductId(p.getProductId());
            dto.setProductCode(p.getProductCode());
            dto.setProductName(p.getProductName());
            dto.setDescription(p.getDescription());
            dto.setCategory(p.getCategory());
            dto.setBrand(p.getBrand());
            dto.setPrice(p.getPrice());
            dto.setCostPrice(p.getCostPrice());
            dto.setImageUrl(p.getImageUrl());
            dto.setWeight(p.getWeight());
            dto.setStatus(p.getStatus());
            dto.setStatus(p.getStatus());
            dtos.add(dto);
        }
        return dtos;
    }
}