package lk.techmart.core.service;

import jakarta.ejb.Local;
import lk.techmart.core.dto.AdminDTO;

import java.util.Map;

@Local
public interface AdminService {

    AdminDTO loginAdmin(String username, String password);
    Map<String, Long> getDashboardMetrics();

}
