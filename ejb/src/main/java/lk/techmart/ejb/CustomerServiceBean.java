package lk.techmart.ejb;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.techmart.core.entity.Customer;

@Stateless
public class CustomerServiceBean {

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

    public Customer createTestCustomer() {
        Customer c = new Customer();
        c.setFirstName("Kamal");
        c.setLastName("Perera");
        c.setEmail("kamal.test" + System.currentTimeMillis() + "@gmail.com");
        c.setPassword("12345");
        c.setPhone("0771234567");
        c.setAddress("No 10, Kandy Road, Colombo");
        c.setStatus("ACTIVE");

        em.persist(c);
        em.flush();
        return c;
    }

}
