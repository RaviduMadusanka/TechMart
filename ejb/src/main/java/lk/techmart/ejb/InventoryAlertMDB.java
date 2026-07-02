package lk.techmart.ejb;

import jakarta.ejb.ActivationConfigProperty;
import jakarta.ejb.MessageDriven;
import jakarta.inject.Inject;
import jakarta.jms.JMSException;
import jakarta.jms.Message;
import jakarta.jms.MessageListener;
import jakarta.jms.TextMessage;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;

@MessageDriven(activationConfig = {
        @ActivationConfigProperty(propertyName = "destinationLookup", propertyValue = "jms/InventoryAlertTopic"),
        @ActivationConfigProperty(propertyName = "destinationType", propertyValue = "jakarta.jms.Topic"),
        @ActivationConfigProperty(propertyName = "subscriptionDurability", propertyValue = "NonDurable")
})
public class InventoryAlertMDB implements MessageListener {

    @Inject
    private NotificationServiceBean notificationService;

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

    @Override
    public void onMessage(Message message) {
        try {
            if (message instanceof TextMessage) {
                String content = ((TextMessage) message).getText();
                List<String> adminEmails = em.createQuery("SELECT a.email FROM User a", String.class).getResultList();
                for (String email : adminEmails) {
                    notificationService.sendEmailDirectAsync(email, content, "Stock Alert from TechMart");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}