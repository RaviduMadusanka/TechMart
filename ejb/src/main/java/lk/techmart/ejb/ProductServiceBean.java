package lk.techmart.ejb;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import lk.techmart.core.dto.BrandDTO;
import lk.techmart.core.dto.CategoryDTO;
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

        if (dto.getCategory() != null && dto.getCategory().getCategoryId() != null) {
            Category category = em.find(Category.class, dto.getCategory().getCategoryId());
            entity.setCategory(category);
        }
        if (dto.getBrand() != null && dto.getBrand().getBrandId() != null) {
            Brand brand = em.find(Brand.class, dto.getBrand().getBrandId());
            entity.setBrand(brand);
        }

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
    public void updateProduct(ProductDTO dto) {

        Product entity = em.find(Product.class, dto.getProductId());

        if (entity != null) {
            entity.setProductName(dto.getProductName());
            entity.setDescription(dto.getDescription());
            entity.setPrice(dto.getPrice());
            entity.setCostPrice(dto.getCostPrice());
            entity.setWeight(dto.getWeight());

            if (dto.getImageUrl() != null && !dto.getImageUrl().isEmpty()) {
                entity.setImageUrl(dto.getImageUrl());
            }

            if (dto.getCategory() != null && dto.getCategory().getCategoryId() != null) {
                Category category = em.find(Category.class, dto.getCategory().getCategoryId());
                entity.setCategory(category);
            }
            if (dto.getBrand() != null && dto.getBrand().getBrandId() != null) {
                Brand brand = em.find(Brand.class, dto.getBrand().getBrandId());
                entity.setBrand(brand);
            }

            String statusName = (dto.getStatus() != null) ? dto.getStatus() : "ACTIVE";
            Status status = findOrCreateStatus(statusName);
            entity.setStatus(status);

            em.merge(entity);
            em.flush();
        }

    }

    @Override
    public ProductDTO getProductById(Long productId) {
        Product p = em.find(Product.class, productId);
        if (p == null) return null;

        ProductDTO dto = new ProductDTO();

        dto.setProductId(p.getProductId());
        dto.setProductCode(p.getProductCode());
        dto.setProductName(p.getProductName());
        dto.setDescription(p.getDescription());
        dto.setPrice(p.getPrice());
        dto.setCostPrice(p.getCostPrice());
        dto.setImageUrl(p.getImageUrl());
        dto.setWeight(p.getWeight());

        if (p.getCategory() != null) {
            CategoryDTO catDto = new CategoryDTO();
            catDto.setCategoryId(p.getCategory().getCategoryId());
            catDto.setName(p.getCategory().getName());
            dto.setCategory(catDto);
        }

        if (p.getBrand() != null) {
            BrandDTO brandDto = new BrandDTO();
            brandDto.setBrandId(p.getBrand().getBrandId());
            brandDto.setName(p.getBrand().getName());
            dto.setBrand(brandDto);
        }

        dto.setStatus(p.getStatus() != null ? p.getStatus().getStatusName() : "ACTIVE");

        return dto;
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

            if (p.getCategory() != null) {
                CategoryDTO catDto = new CategoryDTO();
                catDto.setCategoryId(p.getCategory().getCategoryId());
                catDto.setName(p.getCategory().getName());
                dto.setCategory(catDto);
            }
            if (p.getBrand() != null) {
                BrandDTO brandDto = new BrandDTO();
                brandDto.setBrandId(p.getBrand().getBrandId());
                brandDto.setName(p.getBrand().getName());
                dto.setBrand(brandDto);
            }

            dto.setStatus(p.getStatus() != null ? p.getStatus().getStatusName() : "ACTIVE");
            dtos.add(dto);
        }
        return dtos;
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

    @Override
    public boolean addCategory(CategoryDTO dto) {
        try {
            List<Category> existing = em.createQuery("SELECT c FROM Category c WHERE LOWER(c.name) = LOWER(:name)", Category.class)
                    .setParameter("name", dto.getName().trim())
                    .getResultList();

            if (!existing.isEmpty()) {
                return false;
            }

            Category category = new Category();
            category.setName(dto.getName().trim());
            em.persist(category);
            em.flush();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean addBrand(BrandDTO brandDTO) {
        if (brandDTO.getName() == null || brandDTO.getName().trim().isEmpty()) return false;
        try {
            Long count = em.createQuery("SELECT COUNT(b) FROM Brand b WHERE LOWER(b.name) = LOWER(:name)", Long.class)
                    .setParameter("name", brandDTO.getName().trim())
                    .getSingleResult();

            if (count > 0) return false;

            Brand newBrand = new Brand();
            newBrand.setName(brandDTO.getName().trim());
            em.persist(newBrand);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
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