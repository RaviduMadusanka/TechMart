package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.json.Json;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.techmart.core.service.AdminService;

import java.io.IOException;
import java.util.Map;

@WebServlet("/api/dashboard")
public class DashboardApiServlet extends HttpServlet {

    @EJB
    private AdminService dashboardService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            Map<String, Long> metrics = dashboardService.getDashboardMetrics();

            JsonObjectBuilder obj = Json.createObjectBuilder();
            obj.add("totalProducts", metrics.getOrDefault("totalProducts", 0L));
            obj.add("ordersToday", metrics.getOrDefault("ordersToday", 0L));
            obj.add("lowStockItems", metrics.getOrDefault("lowStockItems", 0L));
            obj.add("totalCustomers", metrics.getOrDefault("totalCustomers", 0L));

            resp.getWriter().write(obj.build().toString());
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}