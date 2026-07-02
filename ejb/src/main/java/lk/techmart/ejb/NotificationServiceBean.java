package lk.techmart.ejb;

import jakarta.annotation.Resource;
import jakarta.ejb.AsyncResult;
import jakarta.ejb.Asynchronous;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import jakarta.jms.JMSContext;
import jakarta.jms.Queue;
import jakarta.jms.Topic;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Future;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.techmart.core.entity.Notification;

import java.util.Properties;

@Stateless
public class NotificationServiceBean {

    @Inject
    private JMSContext jmsContext;

    @Resource(lookup = "jms/OrderNotificationQueue")
    private Queue orderQueue;

    @Resource(lookup = "jms/InventoryAlertTopic")
    private Topic inventoryTopic;

    @PersistenceContext(unitName = "techmartPU")
    private EntityManager em;

    public void sendOrderNotification(Long customerId, String orderId, String status) {
        try {
            jakarta.jms.MapMessage mapMessage = jmsContext.createMapMessage();
            mapMessage.setLong("customerId", customerId);
            mapMessage.setString("orderId", orderId);
            mapMessage.setString("message", "Order ID: " + orderId + " is now " + status);

            jmsContext.createProducer().send(orderQueue, mapMessage);
            System.out.println("[Producer] MapMessage sent to OrderQueue for Customer: " + customerId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void sendInventoryAlert(String productName, int currentQty, int reorderLevel) {
        String alert = "ALERT: Product '" + productName + "' stock is low! Current: " + currentQty + ", Reorder Level: " + reorderLevel;
        jmsContext.createProducer().send(inventoryTopic, alert);
        System.out.println("[Producer] Alert sent to InventoryTopic: " + alert);
    }

    @Asynchronous
    public Future<Boolean> sendEmailDirectAsync(String toEmail, String content) {

        final String fromEmail = "ravidumadusanka338@gmail.com";
        final String password = "k a e t a w e t s k k w a t j l";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("TechMart - Order Update");
            message.setText(content);

            Transport.send(message);
            return new AsyncResult<>(true);

        } catch (Exception e) {
            e.printStackTrace();
            return new AsyncResult<>(false);
        }
    }

    @Asynchronous
    public Future<Boolean> sendEmailDirectAsync(String toEmail, String content,String subject) {

        final String fromEmail = "ravidumadusanka338@gmail.com";
        final String password = "k a e t a w e t s k k w a t j l";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(content);

            Transport.send(message);
            return new AsyncResult<>(true);

        } catch (Exception e) {
            e.printStackTrace();
            return new AsyncResult<>(false);
        }

    }

    public String getLatestNotification(Long orderId) {
        try {
            return em.createQuery("SELECT n.message FROM Notification n WHERE n.order.orderId = :oId ORDER BY n.notificationId DESC", String.class)
                    .setParameter("oId", orderId)
                    .setMaxResults(1)
                    .getSingleResult();
        } catch (Exception e) {
            System.out.println("DEBUG: Error trying to find notification for order " + orderId + ": " + e.getMessage());
            return null;
        }
    }

}