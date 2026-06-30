package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.techmart.core.dto.ProductDTO;
import lk.techmart.core.service.OrderService;
import lk.techmart.core.service.ProductService;
import lk.techmart.ejb.ShoppingCartBean;

import java.io.IOException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @EJB
    private OrderService orderService;

    @EJB
    private ProductService productService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loggedUserId") == null) {
            session.setAttribute("errorMessage", "Please login to proceed to checkout!");
            response.sendRedirect("auth?action=login");
            return;
        }

        Long customerId = (Long) session.getAttribute("loggedUserId");
        ShoppingCartBean shoppingCart = (ShoppingCartBean) session.getAttribute("shoppingCart");

        if (shoppingCart == null || shoppingCart.getCartItems().isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String country = request.getParameter("country");

        try {
            Map<Long, Integer> cartItems = shoppingCart.getCartItems();
            Long orderId = orderService.placeOrder(customerId, cartItems);

            double subtotal = 0.0;
            for (Map.Entry<Long, Integer> entry : cartItems.entrySet()) {
                ProductDTO product = productService.getProductById(entry.getKey());
                if (product != null && product.getPrice() != null) {
                    subtotal += (product.getPrice().doubleValue() * entry.getValue());
                }
            }
            double tax = subtotal * 0.08;
            double total = subtotal + tax;

            String amountFormatted = String.format("%.2f", total);
            String merchantId = "1225567";
            String merchantSecret = "MTM4NjMyNDYyNTU1MDg0NTkyNjEwMjE3MDEzNDE2NDc5MTM5OTc=";
            String currency = "LKR";

            String hashedSecret = getMd5(merchantSecret).toUpperCase();
            String hashString = merchantId + orderId + amountFormatted + currency + hashedSecret;
            String hash = getMd5(hashString).toUpperCase();

            request.setAttribute("merchantId", merchantId);
            request.setAttribute("orderId", orderId);
            request.setAttribute("amount", amountFormatted);
            request.setAttribute("currency", currency);
            request.setAttribute("hash", hash);

            request.setAttribute("firstName", firstName != null ? firstName : session.getAttribute("loggedUserName"));
            request.setAttribute("lastName", lastName != null ? lastName : "");
            request.setAttribute("email", email != null ? email : session.getAttribute("loggedUserEmail"));
            request.setAttribute("phone", phone != null ? phone : "");
            request.setAttribute("address", address != null ? address : "");
            request.setAttribute("city", city != null ? city : "");
            request.setAttribute("country", country != null ? country : "Sri Lanka");

            request.getRequestDispatcher("/payhere_redirect.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error processing checkout: " + e.getMessage());
        }
    }

    private String getMd5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
            BigInteger no = new BigInteger(1, messageDigest);
            String hashtext = no.toString(16);
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}