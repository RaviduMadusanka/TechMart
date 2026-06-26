package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.techmart.core.dto.AdminDTO;
import lk.techmart.core.dto.CustomerDTO;
import lk.techmart.core.service.AdminService;
import lk.techmart.core.service.CustomerService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@WebServlet("/api/users")
public class UserApiServlet extends HttpServlet {

    @EJB
    private CustomerService customerService;

    @EJB
    private AdminService adminService;

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
            }else if ("get_user_types".equals(action)) {

                List<Map<String, Object>> userTypes = adminService.getUserTypes();

                String jsonOutput = new com.google.gson.Gson().toJson(userTypes);

                PrintWriter out = resp.getWriter();
                out.print(jsonOutput);
                out.flush();
            }else if ("get_admins".equals(action)) {
            List<Map<String, Object>> admins = adminService.getAllAdminsData();
            String jsonOutput = new com.google.gson.Gson().toJson(admins);
            PrintWriter out = resp.getWriter();
            out.print(jsonOutput);
            out.flush();
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
            } else if ("add_admin".equals(action)) {
            AdminDTO dto = new AdminDTO();
            dto.setUsername(req.getParameter("username"));
            dto.setEmail(req.getParameter("email"));
            dto.setPassword(req.getParameter("password"));

            String userTypeIdStr = req.getParameter("userTypeId");

            System.out.println("Selected User Type ID from Form: " + userTypeIdStr);

            if (userTypeIdStr != null && !userTypeIdStr.isEmpty()) {
                dto.setUserTypeId(Long.parseLong(userTypeIdStr));
            } else {
                System.out.println("Warning: userTypeId is null or empty from frontend!");
            }

            boolean success = adminService.addAdmin(dto);

            if (success) {
                resp.getWriter().write("{\"success\": true, \"message\": \"Admin user created successfully!\"}");
            } else {
                resp.getWriter().write("{\"success\": false, \"message\": \"Failed! Username or Email already exists.\"}");
            }
        }else if ("update_admin_status".equals(action)) {
            String idParam = req.getParameter("adminId");
            String newStatus = req.getParameter("status");

            if (idParam != null && newStatus != null) {
                Long adminId = Long.parseLong(idParam);
                boolean success = adminService.updateAdminStatus(adminId, newStatus);

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