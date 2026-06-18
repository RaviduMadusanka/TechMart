package lk.techmart.ejb;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

@Stateless
public class UserSessionBean {

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

}
