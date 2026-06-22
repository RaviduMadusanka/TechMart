package lk.techmart.core.service;

import jakarta.ejb.Local;
import lk.techmart.core.dto.AdminDTO;

@Local
public interface AdminService {

    AdminDTO loginAdmin(String username, String password);

}
