package lk.techmart.ejb;

import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import lk.techmart.core.dto.AdminDTO;
import lk.techmart.core.entity.CustomerStatus;
import lk.techmart.core.entity.User;
import lk.techmart.core.entity.UserType;
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
    public AdminDTO loginAdmin(String email, String password) {
        List<User> admins = em.createQuery("SELECT u FROM User u WHERE u.email = :email AND u.password = :password", User.class)
                .setParameter("email", email)
                .setParameter("password", password)
                .getResultList();

        if (!admins.isEmpty()) {
            User admin = admins.get(0);

            if (admin.getStatus() != null && !"ACTIVE".equals(admin.getStatus().getStatusName())) {
                return null;
            }
            AdminDTO dto = new AdminDTO();
            dto.setUserId(admin.getUserId());
            dto.setUsername(admin.getUsername());
            dto.setEmail(admin.getEmail());
            if(admin.getUserType() != null) {
                dto.setUserTypeId(admin.getUserType().getId());
                dto.setUserTypeName(admin.getUserType().getTypeName());
            }
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

    @Override
    public boolean addAdmin(AdminDTO dto) {
        try {

            Long count = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.username = :username OR u.email = :email", Long.class)
                    .setParameter("username", dto.getUsername())
                    .setParameter("email", dto.getEmail())
                    .getSingleResult();

            if (count > 0) return false;

            User admin = new User();
            admin.setUsername(dto.getUsername());
            admin.setEmail(dto.getEmail());
            admin.setPassword(dto.getPassword());

            if (dto.getUserTypeId() != null) {
                UserType ut = em.find(UserType.class, dto.getUserTypeId());
                if (ut != null) {
                    admin.setUserType(ut);
                }
            }

            try {
                CustomerStatus activeStatus = em.createQuery("SELECT c FROM CustomerStatus c WHERE c.statusName = 'ACTIVE'", CustomerStatus.class)
                        .setMaxResults(1)
                        .getSingleResult();

                admin.setStatus(activeStatus);
            } catch (Exception e) {
                System.out.println("Warning: 'ACTIVE' status not found by string, falling back to ID 1");
                CustomerStatus fallbackStatus = em.find(CustomerStatus.class, 1L);
                if (fallbackStatus != null) {
                    admin.setStatus(fallbackStatus);
                }
            }

            em.persist(admin);
            em.flush();

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Map<String, Object>> getUserTypes() {
        try {
            List<UserType> types = em.createQuery("SELECT ut FROM UserType ut", UserType.class).getResultList();
            List<Map<String, Object>> list = new java.util.ArrayList<>();
            for (UserType ut : types) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", ut.getId());
                map.put("type_name", ut.getTypeName());
                list.add(map);
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    @Override
    public List<Map<String, Object>> getAllAdminsData() {
        List<Map<String, Object>> list = new java.util.ArrayList<>();
        try {
            List<User> admins = em.createQuery("SELECT u FROM User u", User.class).getResultList();

            for (User u : admins) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", u.getUserId());
                map.put("username", u.getUsername());
                map.put("email", u.getEmail());
                map.put("role", u.getUserType() != null ? u.getUserType().getTypeName() : "No Role");
                map.put("status", u.getStatus() != null ? u.getStatus().getStatusName() : "UNKNOWN");
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateAdminStatus(Long adminId, String newStatusName) {
        try {
            User admin = em.find(User.class, adminId);
            if (admin == null) return false;

            CustomerStatus newStatus = em.createQuery("SELECT c FROM CustomerStatus c WHERE c.statusName = :name", CustomerStatus.class)
                    .setParameter("name", newStatusName)
                    .setMaxResults(1)
                    .getSingleResult();

            admin.setStatus(newStatus);
            em.merge(admin);
            em.flush();

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
