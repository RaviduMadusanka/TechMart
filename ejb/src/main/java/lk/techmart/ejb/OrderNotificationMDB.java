package lk.techmart.ejb;

import jakarta.ejb.ActivationConfigProperty;
import jakarta.ejb.MessageDriven;
import jakarta.ejb.TransactionManagement;
import jakarta.ejb.TransactionManagementType;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.jms.JMSException;
import jakarta.jms.Message;
import jakarta.jms.MessageListener;
import jakarta.jms.MapMessage;
import lk.techmart.core.entity.Customer;
import lk.techmart.core.entity.Notification;
import lk.techmart.core.entity.Orders;

import java.util.Date;

@MessageDriven(activationConfig = {
        @ActivationConfigProperty(propertyName = "destinationLookup", propertyValue = "jms/OrderNotificationQueue"),
        @ActivationConfigProperty(propertyName = "destinationType", propertyValue = "jakarta.jms.Queue"),
        @ActivationConfigProperty(propertyName = "maxSession", propertyValue = "15")
})
@TransactionManagement(TransactionManagementType.CONTAINER)
public class OrderNotificationMDB implements MessageListener {

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

    @Override
    public void onMessage(Message message) {
        System.out.println("🚀 MDB msg ekak awaaaaaa!");
        try {

            if (message instanceof MapMessage) {
                MapMessage mapMsg = (MapMessage) message;

                Long customerId = mapMsg.getLong("customerId");
                String rawOrderId = mapMsg.getString("orderId");
                String numericId = rawOrderId.replace("ORD-", "");
                Long orderIdLong = Long.parseLong(numericId);
                String text = mapMsg.getString("message");


                Customer customer = em.find(Customer.class, customerId);
                Orders order = em.find(Orders.class, orderIdLong);

                if (customer != null) {
                    Notification notification = new Notification();
                    notification.setCustomer(customer);
                    notification.setNotificationType("ORDER_UPDATE");
                    notification.setMessage(text);
                    notification.setSentTime(new Date());
                    notification.setOrder(order);

                    em.persist(notification);
                    em.flush();
                }
            }
        } catch (JMSException e) {
            System.err.println("[OrderNotificationMDB] JMS Error processing message: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("[OrderNotificationMDB] Database Error: " + e.getMessage());
        }
    }
}