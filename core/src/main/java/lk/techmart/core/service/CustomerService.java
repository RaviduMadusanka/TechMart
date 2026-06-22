package lk.techmart.core.service;

import jakarta.ejb.Local;
import lk.techmart.core.dto.CustomerDTO;

@Local
public interface CustomerService {

    boolean registerCustomer(CustomerDTO dto);
    CustomerDTO loginCustomer(String email, String password);
}
