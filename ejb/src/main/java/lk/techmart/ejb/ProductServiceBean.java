package lk.techmart.ejb;

import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import lk.techmart.core.dto.*;
import lk.techmart.core.entity.*;
import lk.techmart.core.service.ProductService;

import java.util.ArrayList;
import java.util.List;

@Stateless
public class ProductServiceBean implements ProductService {

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

    @EJB
    private NotificationServiceBean notificationService;

    @Override
    public void addProduct(ProductDTO dto,Long userId) {
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

        if (dto.getQuantity() != null && dto.getWarehouse() != null) {
            Inventory inventory = new Inventory();
            inventory.setProduct(entity);

            Warehouse warehouse = em.find(Warehouse.class, dto.getWarehouse().getWarehouseId());
            if (warehouse != null) {
                inventory.setWarehouse(warehouse);
            }

            User user = em.find(User.class, userId);
            if (user != null) {
                inventory.setUser(user);
            }

            inventory.setQuantity(dto.getQuantity());
            inventory.setReorderLevel(20);

            em.persist(inventory);
        }
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
    public boolean updateInventoryQuantity(Long inventoryId, Integer newQuantity,Long userId) {
        try {
            Inventory inv = em.find(Inventory.class, inventoryId);
            User user = em.find(User.class, userId);

            if (inv != null) {
                inv.setQuantity(newQuantity);
                inv.setUser(user);
                em.merge(inv);
                em.flush();
                return true;
            }
            return false;
        } catch (Exception e) {

            return false;
        }
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
    public List<WarehousesDTO> getAllWarehouses() {
        List<Warehouses> warehouse = em.createQuery("SELECT w FROM Warehouses w", Warehouses.class).getResultList();
        List<WarehousesDTO> dtos = new ArrayList<>();
        for(Warehouses w : warehouse) {
            WarehousesDTO dto = new WarehousesDTO();
            dto.setWarehouseId(w.getWarehouseId());
            dto.setWarehouseName(w.getWarehouseName());
            dto.setLocation(w.getLocation());
            dtos.add(dto);
        }
        return dtos;
    }

    @Override
    public List<InventoryDTO> getAllInventory() {
        List<Inventory> inventories = em.createQuery("SELECT i FROM Inventory i", Inventory.class).getResultList();
        List<InventoryDTO> dtos = new ArrayList<>();

        for(Inventory i : inventories) {
            InventoryDTO dto = new InventoryDTO();
            dto.setInventoryId(i.getInventoryId());
            dto.setQuantity(i.getQuantity());
            dto.setReorderLevel(i.getReorderLevel());

            if (i.getProduct() != null) {
                Product p = i.getProduct();
                ProductDTO pDto = new ProductDTO();
                pDto.setProductId(p.getProductId());
                pDto.setProductName(p.getProductName());
                pDto.setProductCode(p.getProductCode());
                pDto.setPrice(p.getPrice());
                pDto.setImageUrl(p.getImageUrl());

                if (p.getBrand() != null) {
                    BrandDTO bDto = new BrandDTO();
                    bDto.setName(p.getBrand().getName());
                    pDto.setBrand(bDto);
                }

                if (p.getCategory() != null) {
                    CategoryDTO cDto = new CategoryDTO();
                    cDto.setName(p.getCategory().getName());
                    pDto.setCategory(cDto);
                }

                pDto.setStatus(p.getStatus() != null ? p.getStatus().getStatusName() : "ACTIVE");
                dto.setProduct(pDto);
            }
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