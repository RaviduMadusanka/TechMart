package lk.techmart.ejb;

import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import lk.techmart.core.dto.AdminDTO;
import lk.techmart.core.entity.User;
import lk.techmart.core.service.AdminService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.techmart.core.service.InventoryService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Stateless
public class AdminServiceBean implements AdminService {

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

    @EJB
    private InventoryService inventoryService;


    @Override
    public AdminDTO loginAdmin(String username, String password) {

        List<User> admins = em.createQuery("SELECT u FROM User u WHERE u.username = :username AND u.password = :password", User.class)
                .setParameter("username", username)
                .setParameter("password", password)
                .getResultList();

        if (!admins.isEmpty()) {
            User admin = admins.get(0);
            AdminDTO dto = new AdminDTO();
            dto.setUserId(admin.getUserId());
            dto.setUsername(admin.getUsername());
            dto.setRole(admin.getRole());
            return dto;
        }

        return null;
    }

    @Override
    public Map<String, Long> getDashboardMetrics() {
        Map<String, Long> metrics = new HashMap<>();
        try {
            Object products = em.createNativeQuery("SELECT COUNT(*) FROM products").getSingleResult();
            metrics.put("totalProducts", products != null ? ((Number) products).longValue() : 0L);

            Object customers = em.createNativeQuery("SELECT COUNT(*) FROM customers").getSingleResult();
            metrics.put("totalCustomers", customers != null ? ((Number) customers).longValue() : 0L);

            Object orders = em.createNativeQuery("SELECT COUNT(*) FROM orders WHERE DATE(order_date) = CURRENT_DATE").getSingleResult();
            metrics.put("ordersToday", orders != null ? ((Number) orders).longValue() : 0L);

            long lowStock = inventoryService.getLowStockCount(15);
            metrics.put("lowStockItems", lowStock);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return metrics;
    }
}
