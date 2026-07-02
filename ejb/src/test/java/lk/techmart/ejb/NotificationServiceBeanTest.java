package lk.techmart.ejb;

import jakarta.jms.JMSContext;
import jakarta.jms.JMSProducer;
import jakarta.jms.MapMessage;
import jakarta.jms.Queue;
import jakarta.jms.Topic;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.lang.reflect.Field;
import java.util.concurrent.Future;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("NotificationServiceBean - JMS producer tests")
class NotificationServiceBeanTest {

    @Mock
    private JMSContext jmsContext;

    @Mock
    private Queue orderQueue;

    @Mock
    private Topic inventoryTopic;

    @Mock
    private JMSProducer jmsProducer;

    @Mock
    private MapMessage mapMessage;

    private NotificationServiceBean bean;

    @BeforeEach
    void setUp() throws Exception {
        bean = new NotificationServiceBean();
        setField(bean, "jmsContext", jmsContext);
        setField(bean, "orderQueue", orderQueue);
        setField(bean, "inventoryTopic", inventoryTopic);
    }

    private void setField(Object target, String fieldName, Object value) throws Exception {
        Field f = target.getClass().getDeclaredField(fieldName);
        f.setAccessible(true);
        f.set(target, value);
    }

    @Test
    @DisplayName("sendOrderNotification() builds a MapMessage and sends it to the Point-to-Point order queue")
    void sendOrderNotification_sendsMapMessageToQueue() throws Exception {
        when(jmsContext.createMapMessage()).thenReturn(mapMessage);
        when(jmsContext.createProducer()).thenReturn(jmsProducer);
        when(jmsProducer.send(eq(orderQueue), eq(mapMessage))).thenReturn(jmsProducer);

        bean.sendOrderNotification(5L, "ORD-1", "Shipped");

        verify(mapMessage).setLong("customerId", 5L);
        verify(mapMessage).setString("orderId", "ORD-1");
        verify(mapMessage).setString(eq("message"), contains("Shipped"));
        verify(jmsProducer).send(orderQueue, mapMessage);
    }

    @Test
    @DisplayName("sendInventoryAlert() publishes a text alert to the Publish/Subscribe inventory topic")
    void sendInventoryAlert_publishesToTopic() {
        when(jmsContext.createProducer()).thenReturn(jmsProducer);
        when(jmsProducer.send(eq(inventoryTopic), anyString())).thenReturn(jmsProducer);

        bean.sendInventoryAlert("USB Cable", 3, 10);

        verify(jmsProducer).send(eq(inventoryTopic), contains("USB Cable"));
    }

    @Test
    @DisplayName("sendOrderNotification() swallows JMS exceptions instead of propagating them")
    void sendOrderNotification_jmsFailure_doesNotThrow() {
        when(jmsContext.createMapMessage()).thenThrow(new RuntimeException("broker unavailable"));

        assertDoesNotThrow(() -> bean.sendOrderNotification(1L, "ORD-1", "Pending"));
    }
}
