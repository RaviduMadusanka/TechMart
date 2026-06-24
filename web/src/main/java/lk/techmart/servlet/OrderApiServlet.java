package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.techmart.core.dto.OrderDTO;
import lk.techmart.core.service.OrderService;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/orders")
public class OrderApiServlet extends HttpServlet {

    @EJB
    private OrderService orderService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        System.out.println("Action = " + action);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if ("get_all".equals(action)) {
                List<OrderDTO> orders = orderService.getAllOrders();
                JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();

                for (OrderDTO o : orders) {
                    JsonObjectBuilder obj = Json.createObjectBuilder();
                    obj.add("orderId", o.getOrderId());
                    obj.add("customerName", o.getCustomerName() != null ? o.getCustomerName() : "Unknown");
                    obj.add("customerEmail", o.getCustomerEmail() != null ? o.getCustomerEmail() : "");
                    obj.add("orderDate", o.getOrderDate() != null ? o.getOrderDate() : "");
                    obj.add("totalAmount", o.getTotalAmount() != null ? o.getTotalAmount().toString() : "0.00");
                    obj.add("status", o.getStatus() != null ? o.getStatus() : "Pending");

                    arrayBuilder.add(obj);
                }
                resp.getWriter().write(arrayBuilder.build().toString());

            }else if ("get_by_id".equals(action)) {

                Long orderId = Long.parseLong(req.getParameter("id"));

                OrderDTO o = orderService.getOrderById(orderId);

                if (o == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }

                JsonObjectBuilder obj = Json.createObjectBuilder();

                obj.add("orderId", o.getOrderId());
                obj.add("customerName",
                        o.getCustomerName() != null ? o.getCustomerName() : "");

                obj.add("customerEmail",
                        o.getCustomerEmail() != null ? o.getCustomerEmail() : "");

                obj.add("phone",
                        o.getPhone() != null ? o.getPhone() : "");

                obj.add("shippingAddress",
                        o.getShipping_address() != null ?
                                o.getShipping_address() : "");

                obj.add("orderDate",
                        o.getOrderDate() != null ? o.getOrderDate() : "");

                obj.add("totalAmount",
                        o.getTotalAmount() != null ?
                                o.getTotalAmount().toString() : "0.00");

                obj.add("status",
                        o.getStatus() != null ? o.getStatus() : "");

                resp.getWriter().write(obj.build().toString());

            }else if ("get_statuses".equals(action)) {
                List<String> statuses = orderService.getAllOrderStatuses();
                JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();

                for (String status : statuses) {
                    arrayBuilder.add(status);
                }
                resp.getWriter().write(arrayBuilder.build().toString());
            }
        } catch (Throwable e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if ("update_status".equals(action)) {
                Long orderId = Long.parseLong(req.getParameter("orderId"));
                String status = req.getParameter("status");

                boolean success = orderService.updateOrderStatus(orderId, status);

                if (success) {
                    resp.getWriter().write("{\"success\": true}");
                } else {
                    resp.getWriter().write("{\"success\": false, \"error\": \"Update failed in database\"}");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }
}