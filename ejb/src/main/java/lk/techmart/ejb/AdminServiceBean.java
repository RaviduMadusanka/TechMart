package lk.techmart.ejb;

import jakarta.ejb.Stateless;
import lk.techmart.core.dto.AdminDTO;
import lk.techmart.core.entity.User;
import lk.techmart.core.service.AdminService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;

@Stateless
public class AdminServiceBean implements AdminService {

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

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
}
