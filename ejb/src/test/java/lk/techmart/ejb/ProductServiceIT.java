package lk.techmart.ejb;

import lk.techmart.core.dto.ProductDTO;
import lk.techmart.core.entity.Product;
import lk.techmart.core.service.ProductService;
import org.jboss.arquillian.container.test.api.Deployment;
import org.jboss.arquillian.junit5.ArquillianExtension;
import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.jboss.shrinkwrap.api.asset.EmptyAsset;
import org.jboss.shrinkwrap.api.spec.JavaArchive;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import jakarta.ejb.EJB;

import java.io.File;
import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

@ExtendWith(ArquillianExtension.class)
public class ProductServiceIT {

    @Deployment
    public static JavaArchive createDeployment() {
        return ShrinkWrap.create(JavaArchive.class, "product-service-it.jar")
                .addPackage(ProductServiceBean.class.getPackage())

                .addPackage("lk.techmart.ejb.interceptor")

                .addPackage(Product.class.getPackage())
                .addPackage(ProductService.class.getPackage())

                .addPackage(ProductDTO.class.getPackage())

                .addAsManifestResource("META-INF/persistence.xml", "persistence.xml")
                .addAsManifestResource(EmptyAsset.INSTANCE, "beans.xml")
                .addAsManifestResource(new File("src/test/resources/glassfish-resources.xml"), "glassfish-resources.xml");
    }

    @EJB
    private ProductService productService;

    @Test
    public void testProductServiceIsInjected() {
        assertNotNull(productService, "ProductService should be successfully injected by Arquillian!");
        System.out.println("✅ Arquillian successfully deployed the EJB and injected ProductService!");
    }

    @Test
    public void testAddAndFetchProductThroughRealContainer() {
        assertNotNull(productService, "ProductService should be injected before calling business methods");

        ProductDTO dto = new ProductDTO();
        dto.setProductCode("IT-TEST-" + System.currentTimeMillis());
        dto.setProductName("Arquillian Integration Test Product");
        dto.setDescription("Created by ProductServiceIT against a real EJB container + database");
        dto.setPrice(new BigDecimal("1999.00"));
        dto.setCostPrice(new BigDecimal("1500.00"));
        dto.setWeight(new BigDecimal("0.5"));
        dto.setStatus("ACTIVE");

        productService.addProduct(dto, 1L);

        List<ProductDTO> all = productService.getAllProducts();
        assertFalse(all.isEmpty(), "getAllProducts() should return at least the product we just persisted");

        boolean found = all.stream()
                .anyMatch(p -> dto.getProductCode().equals(p.getProductCode()));
        assertTrue(found, "The product created through the real EJB/JPA stack should be retrievable afterwards");
    }
}