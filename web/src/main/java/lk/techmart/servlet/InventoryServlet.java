package lk.techmart.servlet;

import com.google.gson.Gson;
import jakarta.annotation.Resource;
import jakarta.ejb.EJB;
import jakarta.inject.Inject;
import jakarta.jms.JMSContext;
import jakarta.jms.Topic;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.techmart.core.dto.InventoryDTO;
import lk.techmart.core.service.ProductService;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/inventory")
public class InventoryServlet extends HttpServlet {

    @EJB
    private ProductService productService;

    @Inject
    private JMSContext jmsContext;

    @Resource(lookup = "jms/InventoryAlertTopic")
    private Topic inventoryTopic;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if ("get_all".equals(action)) {
                List<InventoryDTO> inventoryList = productService.getAllInventory();
                String json = new Gson().toJson(inventoryList);
                resp.getWriter().write(json);
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"Error loading inventory\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("update_stock".equals(action)) {
            Long inventoryId = Long.parseLong(req.getParameter("inventoryId"));
            Integer newQuantity = Integer.parseInt(req.getParameter("quantity"));
            Long userId = (Long) req.getSession().getAttribute("loggedUserId");

            boolean isUpdated = productService.updateInventoryQuantity(inventoryId, newQuantity,userId);

            if (isUpdated) {
                System.out.println("JMSContext = " + jmsContext);
                System.out.println("Topic = " + inventoryTopic);
                String alert = "ALERT: Stock for inventory ID " + inventoryId + " is now " + newQuantity;
                jmsContext.createProducer().send(inventoryTopic, alert);

                resp.getWriter().write("{\"status\": \"success\"}");
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"status\": \"error\", \"message\": \"Update failed\"}");
            }
        }
    }
}