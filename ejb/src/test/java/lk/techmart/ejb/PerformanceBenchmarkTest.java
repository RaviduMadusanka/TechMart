package lk.techmart.ejb;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import lk.techmart.core.entity.Product;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("Performance benchmark - ProductServiceBean & ShoppingCartBean")
class PerformanceBenchmarkTest {

    private static final int ITERATIONS = 2000;

    @Mock
    private EntityManager em;

    private ProductServiceBean productServiceBean;
    private ShoppingCartBean shoppingCartBean;
    private MetricsCollectorBean metricsCollector;

    @BeforeEach
    void setUp() throws Exception {
        productServiceBean = new ProductServiceBean();
        setField(productServiceBean, "em", em);
        setField(productServiceBean, "notificationService", mock(NotificationServiceBean.class));

        shoppingCartBean = new ShoppingCartBean();

        metricsCollector = new MetricsCollectorBean();
        metricsCollector.init();
    }

    private void setField(Object target, String fieldName, Object value) throws Exception {
        Field f = target.getClass().getDeclaredField(fieldName);
        f.setAccessible(true);
        f.set(target, value);
    }

    private void timed(String methodKey, Runnable call) {
        long start = System.nanoTime();
        call.run();
        long durationNanos = System.nanoTime() - start;
        metricsCollector.record(methodKey, durationNanos);
    }

    @Test
    @DisplayName("Benchmark ProductServiceBean.getAllProducts() and ShoppingCartBean cart operations")
    void runBenchmark() {
        List<Product> mockProducts = new ArrayList<>();
        for (int i = 0; i < 25; i++) {
            Product p = new Product();
            p.setProductId((long) i);
            p.setProductName("Benchmark Product " + i);
            mockProducts.add(p);
        }

        TypedQuery<Product> query = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(Product.class))).thenReturn(query);
        when(query.getResultList()).thenReturn(mockProducts);

        for (int i = 0; i < 200; i++) {
            productServiceBean.getAllProducts();
            shoppingCartBean.addItem((long) i, 1);
        }
        shoppingCartBean.clearCart();

        for (int i = 0; i < ITERATIONS; i++) {
            timed("ProductServiceBean.getAllProducts", () -> productServiceBean.getAllProducts());

            long productId = i % 25;
            timed("ShoppingCartBean.addItem", () -> shoppingCartBean.addItem(productId, 1));
            timed("ShoppingCartBean.getCartItems", () -> shoppingCartBean.getCartItems());
        }
        timed("ShoppingCartBean.clearCart", () -> shoppingCartBean.clearCart());

        printReport();
    }

    private void printReport() {
        System.out.println();
        System.out.println("================ PERFORMANCE BENCHMARK REPORT ================");
        System.out.printf("%-38s %10s %10s %10s %10s %12s%n",
                "Method", "Calls", "Avg(ms)", "Min(ms)", "Max(ms)", "Total(ms)");
        System.out.println("----------------------------------------------------------------------------------");
        metricsCollector.getMetrics().forEach(m ->
                System.out.printf("%-38s %10d %10.3f %10.3f %10.3f %12d%n",
                        m.getMethodName(),
                        m.getInvocationCount(),
                        m.getAvgTimeMs(),
                        m.getMinTimeMs(),
                        m.getMaxTimeMs(),
                        m.getTotalTimeMs()));
        System.out.println("====================================================================================");
        System.out.println("Iterations per method: " + ITERATIONS + " (after 200 warm-up calls, JIT-settled)");
        System.out.println();
    }
}
