package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.techmart.core.dto.PerformanceMetricDTO;
import lk.techmart.core.service.PerformanceMonitorService;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/performance")
public class PerformanceApiServlet extends HttpServlet {

    @EJB
    private PerformanceMonitorService performanceMonitorService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if ("reset".equalsIgnoreCase(req.getParameter("action"))) {
                performanceMonitorService.reset();
                resp.getWriter().write(Json.createObjectBuilder().add("status", "reset").build().toString());
                return;
            }

            List<PerformanceMetricDTO> metrics = performanceMonitorService.getMetrics();

            JsonArrayBuilder metricsArray = Json.createArrayBuilder();
            for (PerformanceMetricDTO m : metrics) {
                JsonObjectBuilder obj = Json.createObjectBuilder();
                obj.add("methodName", m.getMethodName());
                obj.add("invocationCount", m.getInvocationCount());
                obj.add("avgTimeMs", Math.round(m.getAvgTimeMs() * 100.0) / 100.0);
                obj.add("minTimeMs", Math.round(m.getMinTimeMs() * 100.0) / 100.0);
                obj.add("maxTimeMs", Math.round(m.getMaxTimeMs() * 100.0) / 100.0);
                obj.add("totalTimeMs", m.getTotalTimeMs());
                metricsArray.add(obj);
            }

            JsonObjectBuilder root = Json.createObjectBuilder();
            root.add("metrics", metricsArray);
            root.add("methodCount", metrics.size());

            resp.getWriter().write(root.build().toString());
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
