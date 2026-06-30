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
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loggedUserId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Please login to proceed to checkout!\"}");
            return;
        }

        Long customerId = (Long) session.getAttribute("loggedUserId");
        ShoppingCartBean shoppingCart = (ShoppingCartBean) session.getAttribute("shoppingCart");

        if (shoppingCart == null || shoppingCart.getCartItems().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Your cart is empty!\"}");
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
            Long orderId = orderService.placeOrder(customerId, cartItems,address);

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
            String merchantSecret = "Mzk4NjcxODE0MTQyMjU4MzA3NzkzNDY2NTE4ODUwMTk2NDE5OTUwOQ==";
            String currency = "LKR";

            String hashedSecret = getMd5(merchantSecret).toUpperCase();
            String hashString = merchantId + orderId + amountFormatted + currency + hashedSecret;
            String hash = getMd5(hashString).toUpperCase();

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            String jsonResponse = String.format(
                    "{\"merchantId\":\"%s\", \"orderId\":\"%s\", \"amount\":\"%s\", \"currency\":\"%s\", \"hash\":\"%s\", \"firstName\":\"%s\", \"lastName\":\"%s\", \"email\":\"%s\", \"phone\":\"%s\", \"address\":\"%s\", \"city\":\"%s\", \"country\":\"%s\"}",
                    merchantId, orderId, amountFormatted, currency, hash,
                    firstName, lastName, email, phone, address, city, country
            );

            response.getWriter().write(jsonResponse);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Error processing checkout\"}");
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