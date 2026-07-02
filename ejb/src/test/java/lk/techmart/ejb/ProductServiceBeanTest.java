package lk.techmart.ejb;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import lk.techmart.core.dto.*;
import lk.techmart.core.entity.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.lang.reflect.Field;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ProductServiceBean - business logic tests")
class ProductServiceBeanTest {

    @Mock
    private EntityManager em;

    @Mock
    private NotificationServiceBean notificationService;

    private ProductServiceBean productServiceBean;

    @BeforeEach
    void setUp() throws Exception {
        productServiceBean = new ProductServiceBean();
        setField(productServiceBean, "em", em);
        setField(productServiceBean, "notificationService", notificationService);
    }

    private void setField(Object target, String fieldName, Object value) throws Exception {
        Field f = target.getClass().getDeclaredField(fieldName);
        f.setAccessible(true);
        f.set(target, value);
    }


    @Test
    @DisplayName("addProduct() persists product with category, brand and initial inventory")
    void addProduct_withCategoryBrandAndInventory_persistsAll() {
        ProductDTO dto = new ProductDTO();
        dto.setProductCode("P-001");
        dto.setProductName("Wireless Mouse");
        dto.setDescription("A mouse");
        dto.setPrice(new BigDecimal("1500.0"));
        dto.setCostPrice(new BigDecimal("900.0"));
        dto.setImageUrl("mouse.png");
        dto.setWeight(new BigDecimal("0.2"));
        dto.setQuantity(50);

        CategoryDTO catDto = new CategoryDTO();
        catDto.setCategoryId(1L);
        dto.setCategory(catDto);

        BrandDTO brandDto = new BrandDTO();
        brandDto.setBrandId(2L);
        dto.setBrand(brandDto);

        WarehousesDTO warehouseDto = new WarehousesDTO();
        warehouseDto.setWarehouseId(3L);
        dto.setWarehouse(warehouseDto);

        Category category = new Category();
        category.setCategoryId(1L);
        Brand brand = new Brand();
        brand.setBrandId(2L);
        Warehouse warehouse = new Warehouse();
        User user = new User();

        when(em.find(Category.class, 1L)).thenReturn(category);
        when(em.find(Brand.class, 2L)).thenReturn(brand);
        when(em.find(Warehouse.class, 3L)).thenReturn(warehouse);
        when(em.find(User.class, 99L)).thenReturn(user);

        TypedQuery<Status> statusQuery = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(Status.class))).thenReturn(statusQuery);
        when(statusQuery.setParameter(anyString(), any())).thenReturn(statusQuery);
        when(statusQuery.getSingleResult()).thenThrow(new NoResultException());

        productServiceBean.addProduct(dto, 99L);

        // Status (new, via findOrCreateStatus) + Product + Inventory = 3 persist calls
        verify(em, times(3)).persist(any());
        verify(em).persist(any(Product.class));
        verify(em).persist(any(Inventory.class));
        verify(em).persist(any(Status.class));
        verify(em, atLeastOnce()).flush();
    }

    @Test
    @DisplayName("addProduct() skips inventory creation when quantity or warehouse is missing")
    void addProduct_withoutQuantityOrWarehouse_skipsInventory() {
        ProductDTO dto = new ProductDTO();
        dto.setProductCode("P-002");
        dto.setProductName("Keyboard");

        TypedQuery<Status> statusQuery = mock(TypedQuery.class);
        Status active = new Status();
        active.setStatusName("ACTIVE");
        when(em.createQuery(anyString(), eq(Status.class))).thenReturn(statusQuery);
        when(statusQuery.setParameter(anyString(), any())).thenReturn(statusQuery);
        when(statusQuery.getSingleResult()).thenReturn(active);

        productServiceBean.addProduct(dto, 1L);

        // Only the product itself should be persisted, no inventory record
        verify(em, times(1)).persist(any(Product.class));
        verify(em, never()).persist(any(Inventory.class));
    }


    @Test
    @DisplayName("updateProduct() updates fields and merges when product exists")
    void updateProduct_existingProduct_updatesAndMerges() {
        Product existing = new Product();
        existing.setProductId(10L);
        when(em.find(Product.class, 10L)).thenReturn(existing);

        ProductDTO dto = new ProductDTO();
        dto.setProductId(10L);
        dto.setProductName("Updated Name");
        dto.setDescription("Updated description");
        dto.setPrice(new BigDecimal("2000.0"));
        dto.setCostPrice(new BigDecimal("1200.0"));
        dto.setWeight(new BigDecimal("0.5"));
        dto.setImageUrl("new.png");

        TypedQuery<Status> statusQuery = mock(TypedQuery.class);
        Status active = new Status();
        active.setStatusName("ACTIVE");
        when(em.createQuery(anyString(), eq(Status.class))).thenReturn(statusQuery);
        when(statusQuery.setParameter(anyString(), any())).thenReturn(statusQuery);
        when(statusQuery.getSingleResult()).thenReturn(active);

        productServiceBean.updateProduct(dto);

        assertEquals("Updated Name", existing.getProductName());
        assertEquals("new.png", existing.getImageUrl());
        verify(em).merge(existing);
        verify(em).flush();
    }

    @Test
    @DisplayName("updateProduct() does nothing when product does not exist")
    void updateProduct_missingProduct_doesNothing() {
        when(em.find(Product.class, 404L)).thenReturn(null);

        ProductDTO dto = new ProductDTO();
        dto.setProductId(404L);

        productServiceBean.updateProduct(dto);

        verify(em, never()).merge(any());
        verify(em, never()).flush();
    }


    @Test
    @DisplayName("getProductById() maps entity to DTO including category, brand and status")
    void getProductById_found_mapsAllFields() {
        Product p = new Product();
        p.setProductId(1L);
        p.setProductCode("P-100");
        p.setProductName("Monitor");

        Category category = new Category();
        category.setCategoryId(5L);
        category.setName("Electronics");
        p.setCategory(category);

        Brand brand = new Brand();
        brand.setBrandId(7L);
        brand.setName("Dell");
        p.setBrand(brand);

        Status status = new Status();
        status.setStatusName("ACTIVE");
        p.setStatus(status);

        when(em.find(Product.class, 1L)).thenReturn(p);

        ProductDTO dto = productServiceBean.getProductById(1L);

        assertNotNull(dto);
        assertEquals("Monitor", dto.getProductName());
        assertEquals("Electronics", dto.getCategory().getName());
        assertEquals("Dell", dto.getBrand().getName());
        assertEquals("ACTIVE", dto.getStatus());
    }

    @Test
    @DisplayName("getProductById() returns null when product does not exist")
    void getProductById_notFound_returnsNull() {
        when(em.find(Product.class, 999L)).thenReturn(null);

        ProductDTO dto = productServiceBean.getProductById(999L);

        assertNull(dto);
    }


    @Test
    @DisplayName("updateInventoryQuantity() updates quantity and returns true when inventory exists")
    void updateInventoryQuantity_found_returnsTrue() {
        Inventory inv = new Inventory();
        inv.setInventoryId(1L);
        User user = new User();

        when(em.find(Inventory.class, 1L)).thenReturn(inv);
        when(em.find(User.class, 50L)).thenReturn(user);

        boolean result = productServiceBean.updateInventoryQuantity(1L, 30, 50L);

        assertTrue(result);
        assertEquals(30, inv.getQuantity());
        verify(em).merge(inv);
        verify(em).flush();
    }

    @Test
    @DisplayName("updateInventoryQuantity() returns false when inventory does not exist")
    void updateInventoryQuantity_notFound_returnsFalse() {
        when(em.find(Inventory.class, 2L)).thenReturn(null);
        when(em.find(User.class, 50L)).thenReturn(new User());

        boolean result = productServiceBean.updateInventoryQuantity(2L, 30, 50L);

        assertFalse(result);
        verify(em, never()).merge(any());
    }

    @Test
    @DisplayName("updateInventoryQuantity() returns false when an exception occurs")
    void updateInventoryQuantity_exceptionThrown_returnsFalse() {
        when(em.find(Inventory.class, 3L)).thenThrow(new RuntimeException("DB error"));

        boolean result = productServiceBean.updateInventoryQuantity(3L, 10, 1L);

        assertFalse(result);
    }


    @Test
    @DisplayName("getAllProducts() maps every entity in the result list to a DTO")
    void getAllProducts_returnsMappedList() {
        Product p1 = new Product();
        p1.setProductId(1L);
        p1.setProductName("Item 1");

        TypedQuery<Product> query = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(Product.class))).thenReturn(query);
        when(query.getResultList()).thenReturn(List.of(p1));

        List<ProductDTO> result = productServiceBean.getAllProducts();

        assertEquals(1, result.size());
        assertEquals("Item 1", result.get(0).getProductName());
    }

    @Test
    @DisplayName("getAllCategories() maps every category entity to a DTO")
    void getAllCategories_returnsMappedList() {
        Category c = new Category();
        c.setCategoryId(1L);
        c.setName("Accessories");

        TypedQuery<Category> query = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(Category.class))).thenReturn(query);
        when(query.getResultList()).thenReturn(List.of(c));

        List<CategoryDTO> result = productServiceBean.getAllCategories();

        assertEquals(1, result.size());
        assertEquals("Accessories", result.get(0).getName());
    }

    @Test
    @DisplayName("getAllBrands() maps every brand entity to a DTO")
    void getAllBrands_returnsMappedList() {
        Brand b = new Brand();
        b.setBrandId(1L);
        b.setName("HP");

        TypedQuery<Brand> query = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(Brand.class))).thenReturn(query);
        when(query.getResultList()).thenReturn(List.of(b));

        List<BrandDTO> result = productServiceBean.getAllBrands();

        assertEquals(1, result.size());
        assertEquals("HP", result.get(0).getName());
    }

    @Test
    @DisplayName("getAllWarehouses() maps every warehouse entity to a DTO")
    void getAllWarehouses_returnsMappedList() {
        Warehouses w = new Warehouses();
        w.setWarehouseId(1L);
        w.setWarehouseName("Main Store");
        w.setLocation("Colombo");

        TypedQuery<Warehouses> query = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(Warehouses.class))).thenReturn(query);
        when(query.getResultList()).thenReturn(List.of(w));

        List<WarehousesDTO> result = productServiceBean.getAllWarehouses();

        assertEquals(1, result.size());
        assertEquals("Main Store", result.get(0).getWarehouseName());
        assertEquals("Colombo", result.get(0).getLocation());
    }

    @Test
    @DisplayName("getAllInventory() maps inventory including nested product, brand and category")
    void getAllInventory_returnsMappedListWithNestedProduct() {
        Product p = new Product();
        p.setProductId(1L);
        p.setProductName("Cable");
        p.setProductCode("C-1");

        Brand brand = new Brand();
        brand.setName("Generic");
        p.setBrand(brand);

        Category category = new Category();
        category.setName("Cables");
        p.setCategory(category);

        Status status = new Status();
        status.setStatusName("ACTIVE");
        p.setStatus(status);

        Inventory inv = new Inventory();
        inv.setInventoryId(1L);
        inv.setQuantity(15);
        inv.setReorderLevel(10);
        inv.setProduct(p);

        TypedQuery<Inventory> query = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(Inventory.class))).thenReturn(query);
        when(query.getResultList()).thenReturn(List.of(inv));

        List<InventoryDTO> result = productServiceBean.getAllInventory();

        assertEquals(1, result.size());
        InventoryDTO dto = result.get(0);
        assertEquals(15, dto.getQuantity());
        assertNotNull(dto.getProduct());
        assertEquals("Cable", dto.getProduct().getProductName());
        assertEquals("Generic", dto.getProduct().getBrand().getName());
        assertEquals("Cables", dto.getProduct().getCategory().getName());
    }


    @Test
    @DisplayName("addCategory() persists and returns true when the name is not already used")
    void addCategory_newName_returnsTrue() {
        CategoryDTO dto = new CategoryDTO();
        dto.setName("New Category");

        TypedQuery<Category> query = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(Category.class))).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getResultList()).thenReturn(List.of());

        boolean result = productServiceBean.addCategory(dto);

        assertTrue(result);
        verify(em).persist(any(Category.class));
    }

    @Test
    @DisplayName("addCategory() returns false when a category with the same name (case-insensitive) exists")
    void addCategory_duplicateName_returnsFalse() {
        CategoryDTO dto = new CategoryDTO();
        dto.setName("Electronics");

        TypedQuery<Category> query = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(Category.class))).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getResultList()).thenReturn(List.of(new Category()));

        boolean result = productServiceBean.addCategory(dto);

        assertFalse(result);
        verify(em, never()).persist(any());
    }


    @Test
    @DisplayName("addBrand() persists and returns true for a new, non-blank brand name")
    void addBrand_newName_returnsTrue() {
        BrandDTO dto = new BrandDTO();
        dto.setName("Samsung");

        TypedQuery<Long> query = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(Long.class))).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(0L);

        boolean result = productServiceBean.addBrand(dto);

        assertTrue(result);
        verify(em).persist(any(Brand.class));
    }

    @Test
    @DisplayName("addBrand() returns false when the brand name already exists")
    void addBrand_duplicateName_returnsFalse() {
        BrandDTO dto = new BrandDTO();
        dto.setName("Samsung");

        TypedQuery<Long> query = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(Long.class))).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1L);

        boolean result = productServiceBean.addBrand(dto);

        assertFalse(result);
        verify(em, never()).persist(any());
    }

    @Test
    @DisplayName("addBrand() returns false for a null or blank name without touching the EntityManager")
    void addBrand_blankName_returnsFalse() {
        BrandDTO dto = new BrandDTO();
        dto.setName("   ");

        boolean result = productServiceBean.addBrand(dto);

        assertFalse(result);
        verifyNoInteractions(em);
    }
}
