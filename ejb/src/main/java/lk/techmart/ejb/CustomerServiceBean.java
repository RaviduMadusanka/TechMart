package lk.techmart.ejb;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.techmart.core.dto.CustomerDTO;
import lk.techmart.core.entity.Customer;
import lk.techmart.core.entity.User;
import lk.techmart.core.service.CustomerService;

import java.util.List;

@Stateless
public class CustomerServiceBean implements CustomerService {

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

    @Override
    public boolean registerCustomer(CustomerDTO dto) {
        try {
            Customer customer = new Customer();
            customer.setFirstName(dto.getFirstName());
            customer.setLastName(dto.getLastName());
            customer.setEmail(dto.getEmail());
            customer.setPassword(dto.getPassword());
            customer.setPhone(dto.getPhone());
            customer.setAddress(dto.getAddress());
            customer.setStatus("ACTIVE");

            em.persist(customer);
            em.flush();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public CustomerDTO loginCustomer(String email, String password) {

        List<Customer> customers = em.createQuery("SELECT c FROM Customer c WHERE c.email = :email AND c.password = :password", Customer.class)
                .setParameter("email", email)
                .setParameter("password", password)
                .getResultList();

        if (!customers.isEmpty()) {
            Customer c = customers.get(0);
            CustomerDTO dto = new CustomerDTO();
            dto.setCustomerId(c.getCustomerId());
            dto.setFirstName(c.getFirstName());
            dto.setLastName(c.getLastName());
            dto.setEmail(c.getEmail());
            return dto;
        }
        return null;
    }

}
