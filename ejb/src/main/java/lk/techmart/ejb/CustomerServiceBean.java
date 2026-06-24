package lk.techmart.ejb;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.techmart.core.dto.CustomerDTO;
import lk.techmart.core.entity.Customer;
import lk.techmart.core.entity.CustomerStatus;
import lk.techmart.core.entity.User;
import lk.techmart.core.service.CustomerService;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
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

            CustomerStatus activeStatus = em.createQuery("SELECT s FROM CustomerStatus s WHERE s.statusName = 'ACTIVE'", CustomerStatus.class)
                    .getSingleResult();

            customer.setStatus(activeStatus);

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

    @Override
    public List<CustomerDTO> getAllCustomers() {
        List<Customer> customers = em.createQuery("SELECT c FROM Customer c ORDER BY c.createdAt DESC", Customer.class).getResultList();
        List<CustomerDTO> dtos = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");

        for (Customer c : customers) {
            CustomerDTO dto = new CustomerDTO();
            dto.setCustomerId(c.getCustomerId());
            dto.setFirstName(c.getFirstName());
            dto.setLastName(c.getLastName());
            dto.setEmail(c.getEmail());
            dto.setPhone(c.getPhone());

            if (c.getCreatedAt() != null) {
                dto.setJoinedDate(sdf.format(c.getCreatedAt()));
            } else {
                dto.setJoinedDate("N/A");
            }

            if (c.getStatus() != null) {
                dto.setStatus(c.getStatus().getStatusName());
            } else {
                dto.setStatus("UNKNOWN");
            }

            dtos.add(dto);
        }
        return dtos;
    }

    @Override
    public boolean updateCustomerStatus(Long customerId, String newStatus) {
        try {
            Customer customer = em.find(Customer.class, customerId);
            if (customer == null) return false;

            CustomerStatus statusObj = em.createQuery("SELECT s FROM CustomerStatus s WHERE s.statusName = :statusName", CustomerStatus.class)
                    .setParameter("statusName", newStatus)
                    .getSingleResult();

            customer.setStatus(statusObj);
            em.merge(customer);
            em.flush();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
