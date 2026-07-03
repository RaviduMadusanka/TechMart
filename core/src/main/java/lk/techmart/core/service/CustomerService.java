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

    CustomerDTO updateProfile(Long customerId, String firstName, String lastName, String email, String phone, String address) throws Exception;
    void updatePassword(Long customerId, String currentPassword, String newPassword) throws Exception;
    CustomerDTO getCustomerById(Long customerId) throws Exception;
}
