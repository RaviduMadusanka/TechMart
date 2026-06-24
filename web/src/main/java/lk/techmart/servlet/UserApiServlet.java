package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.techmart.core.dto.CustomerDTO;
import lk.techmart.core.service.CustomerService;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/users")
public class UserApiServlet extends HttpServlet {

    @EJB
    private CustomerService customerService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if ("get_customers".equals(action)) {
                List<CustomerDTO> customers = customerService.getAllCustomers();
                JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();

                for (CustomerDTO c : customers) {
                    JsonObjectBuilder obj = Json.createObjectBuilder();
                    obj.add("customerId", c.getCustomerId() != null ? c.getCustomerId() : 0);
                    obj.add("firstName", c.getFirstName() != null ? c.getFirstName() : "");
                    obj.add("lastName", c.getLastName() != null ? c.getLastName() : "");
                    obj.add("email", c.getEmail() != null ? c.getEmail() : "");
                    obj.add("joinedDate", c.getJoinedDate() != null ? c.getJoinedDate() : "N/A");
                    obj.add("status", c.getStatus() != null ? c.getStatus() : "ACTIVE");

                    arrayBuilder.add(obj);
                }
                resp.getWriter().write(arrayBuilder.build().toString());
            }
        } catch (Throwable e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"" + e.toString() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if ("update_status".equals(action)) {
                String idParam = req.getParameter("customerId");
                String newStatus = req.getParameter("status");

                if (idParam != null && newStatus != null) {
                    Long customerId = Long.parseLong(idParam);
                    boolean success = customerService.updateCustomerStatus(customerId, newStatus);

                    if (success) {
                        resp.getWriter().write("{\"success\": true}");
                    } else {
                        resp.getWriter().write("{\"success\": false, \"error\": \"Update failed\"}");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }
}