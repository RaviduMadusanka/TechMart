package lk.techmart.ejb;

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

import static org.junit.jupiter.api.Assertions.assertNotNull;

@ExtendWith(ArquillianExtension.class)
public class ProductServiceIT {

    @Deployment
    public static JavaArchive createDeployment() {
        return ShrinkWrap.create(JavaArchive.class)
                // EJB ටික
                .addPackage(ProductServiceBean.class.getPackage())

                // අලුතින් එකතු කළේ: Interceptor Package එක (නැත්නම් ShoppingCartBean එක වැඩ කරන්නේ නෑ)
                .addPackage("lk.techmart.ejb.interceptor")

                // Entities සහ Interfaces
                .addPackage(Product.class.getPackage())
                .addPackage(ProductService.class.getPackage())

                // EJB Scanning වලට අදාළ XML ෆයිල්
                .addAsManifestResource("META-INF/persistence.xml", "persistence.xml")
                .addAsManifestResource(EmptyAsset.INSTANCE, "beans.xml");
    }

    @EJB
    private ProductService productService;

    @Test
    public void testProductServiceIsInjected() {
        assertNotNull(productService, "ProductService should be successfully injected by Arquillian!");
        System.out.println("✅ Arquillian successfully deployed the EJB and injected ProductService!");
    }
}