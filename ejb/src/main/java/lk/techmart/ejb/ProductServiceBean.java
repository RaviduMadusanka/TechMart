package lk.techmart.ejb;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import lk.techmart.core.entity.Brand;
import lk.techmart.core.entity.Category;
import lk.techmart.core.entity.Product;
import lk.techmart.core.dto.ProductDTO;
import lk.techmart.core.entity.Status;
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

        Category category = findOrCreateCategory(dto.getCategory());
        entity.setCategory(category);

        Brand brand = findOrCreateBrand(dto.getBrand());
        entity.setBrand(brand);

        entity.setPrice(dto.getPrice());
        entity.setCostPrice(dto.getCostPrice());
        entity.setImageUrl(dto.getImageUrl());
        entity.setWeight(dto.getWeight());

        String statusName = (dto.getStatus() != null) ? dto.getStatus() : "ACTIVE";
        Status status = findOrCreateStatus(statusName);
        entity.setStatus(status);


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
            dto.setPrice(p.getPrice());
            dto.setCostPrice(p.getCostPrice());
            dto.setImageUrl(p.getImageUrl());
            dto.setWeight(p.getWeight());
            dto.setCategory(p.getCategory() != null ? p.getCategory().getName() : "");
            dto.setBrand(p.getBrand() != null ? p.getBrand().getName() : "");
            dto.setStatus(p.getStatus() != null ? p.getStatus().getStatusName() : "ACTIVE");
            dtos.add(dto);
        }
        return dtos;
    }

    private Category findOrCreateCategory(String name) {
        if (name == null || name.trim().isEmpty()) return null;
        try {
            return em.createQuery("SELECT c FROM Category c WHERE c.name = :name", Category.class)
                    .setParameter("name", name)
                    .getSingleResult();
        } catch (NoResultException e) {
            Category newCategory = new Category();
            newCategory.setName(name);
            em.persist(newCategory);
            return newCategory;
        }
    }

    private Brand findOrCreateBrand(String name) {
        if (name == null || name.trim().isEmpty()) return null;
        try {
            return em.createQuery("SELECT b FROM Brand b WHERE b.name = :name", Brand.class)
                    .setParameter("name", name)
                    .getSingleResult();
        } catch (NoResultException e) {
            Brand newBrand = new Brand();
            newBrand.setName(name);
            em.persist(newBrand);
            return newBrand;
        }
    }

    private Status findOrCreateStatus(String name) {
        try {
            return em.createQuery("SELECT s FROM Status s WHERE s.statusName = :name", Status.class)
                    .setParameter("name", name)
                    .getSingleResult();
        } catch (NoResultException e) {
            Status newStatus = new Status();
            newStatus.setStatusName(name);
            em.persist(newStatus);
            return newStatus;
        }
    }
}