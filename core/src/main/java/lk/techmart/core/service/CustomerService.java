package lk.techmart.core.service;

import jakarta.ejb.Local;
import lk.techmart.core.dto.CustomerDTO;

import java.util.List;

@Local
public interface CustomerService {

    boolean registerCustomer(CustomerDTO dto);
    CustomerDTO loginCustomer(String email, String password);
    List<CustomerDTO> getAllCustomers();
    boolean updateCustomerStatus(Long customerId, String newStatus);
}
