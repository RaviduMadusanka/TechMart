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
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Map;

@WebServlet("/PayHereNotifyServlet")
public class PayHereNotifyServlet extends HttpServlet {

    @EJB
    private OrderService orderService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            String merchantId = request.getParameter("merchant_id");
            String orderId = request.getParameter("order_id");
            String payhereAmount = request.getParameter("payhere_amount");
            String payhereCurrency = request.getParameter("payhere_currency");
            String statusCode = request.getParameter("status_code");
            String md5sig = request.getParameter("md5sig");

            System.out.println("Notify received: " + orderId);

            String merchantSecret = "Mzk4NjcxODE0MTQyMjU4MzA3NzkzNDY2NTE4ODUwMTk2NDE5OTUwOQ==";

            String hashedSecret = getMd5(merchantSecret).toUpperCase();
            String hashString = merchantId + orderId + payhereAmount + payhereCurrency + statusCode + hashedSecret;
            String generatedMd5sig = getMd5(hashString).toUpperCase();

            if (generatedMd5sig.equals(md5sig)) {
                Long parsedOrderId = Long.parseLong(orderId);

                if ("2".equals(statusCode)) {

                    orderService.processPaymentSuccess(parsedOrderId);
                    System.out.println("Payment Success for Order ID: " + orderId + ". Stock reduced and Cart cleared!");

                } else if ("-2".equals(statusCode) || "-1".equals(statusCode) || "-3".equals(statusCode)) {
                    orderService.updateOrderStatus(parsedOrderId, "CANCELLED");
                    System.out.println("Payment Failed/Cancelled for Order ID: " + orderId);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.setStatus(HttpServletResponse.SC_OK);
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().println("Notify URL - Please use POST");
    }
}