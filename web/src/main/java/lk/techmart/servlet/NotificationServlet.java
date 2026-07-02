package lk.techmart.servlet;

import com.google.gson.Gson;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.techmart.ejb.NotificationServiceBean;
import lk.techmart.core.entity.Customer;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/api/notifications"})
public class NotificationServlet extends HttpServlet {

    @EJB
    private NotificationServiceBean notificationService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        String orderIdStr = request.getParameter("orderId");

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedUserId") != null) {
            Long customerId = (Long) session.getAttribute("loggedUserId");

            if (orderIdStr != null) {
                Long orderId = Long.parseLong(orderIdStr);
                String message = notificationService.getLatestNotification(orderId);
                System.out.println("DEBUG: Message from Service: " + message);

                response.setContentType("application/json");
                response.getWriter().write(new Gson().toJson(message));
            }

        } else {
            response.getWriter().write("[]");
        }
    }
}