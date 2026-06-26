package lk.techmart.core.service;

import jakarta.ejb.Local;
import lk.techmart.core.dto.AdminDTO;

import java.util.List;
import java.util.Map;

@Local
public interface AdminService {

    AdminDTO loginAdmin(String email, String password);
    Map<String, Long> getDashboardMetrics();
    boolean addAdmin(AdminDTO dto);
    List<Map<String, Object>> getUserTypes();
    List<Map<String, Object>> getAllAdminsData();
    boolean updateAdminStatus(Long adminId, String newStatusName);


}
