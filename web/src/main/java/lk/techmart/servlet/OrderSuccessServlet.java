package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.techmart.core.service.OrderService;
import lk.techmart.ejb.ShoppingCartBean;

import java.io.IOException;

@WebServlet("/order-success")
public class OrderSuccessServlet extends HttpServlet {

    @EJB
    private OrderService orderService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String orderId = request.getParameter("orderId");

        if (orderId != null && !orderId.trim().isEmpty()) {
            try {
                Long parsedOrderId = Long.parseLong(orderId);

                boolean success = orderService.processPaymentSuccess(parsedOrderId);

                if(success) {
                    System.out.println("Payment Processed: Status Updated, Stock Reduced & Cart Cleared for Order ID: " + orderId);
                } else {
                    System.out.println("Failed to process payment completely for Order ID: " + orderId);
                }
            } catch (Exception e) {
                System.out.println("Error updating status on success redirect: " + e.getMessage());
            }
        }

        if (session != null) {
            ShoppingCartBean shoppingCart = (ShoppingCartBean) session.getAttribute("shoppingCart");
            if (shoppingCart != null) {
                shoppingCart.clearCart();
            }

            session.removeAttribute("shoppingCart");
        }

        request.setAttribute("orderId", orderId);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
}