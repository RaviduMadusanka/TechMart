package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.techmart.core.service.OrderService;

import java.io.IOException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

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

            String merchantSecret = "MTM4NjMyNDYyNTU1MDg0NTkyNjEwMjE3MDEzNDE2NDc5MTM5OTc=";

            String hashedSecret = getMd5(merchantSecret).toUpperCase();
            String hashString = merchantId + orderId + payhereAmount + payhereCurrency + statusCode + hashedSecret;
            String generatedMd5sig = getMd5(hashString).toUpperCase();

            if (generatedMd5sig.equals(md5sig) && "2".equals(statusCode)) {

                Long parsedOrderId = Long.parseLong(orderId);

                orderService.updateOrderStatus(parsedOrderId, "Processing");

                System.out.println("Payment Success for Order ID: " + orderId);
            } else if ("-2".equals(statusCode)) {
                Long parsedOrderId = Long.parseLong(orderId);
                orderService.updateOrderStatus(parsedOrderId, "Cancelled");
                System.out.println("Payment Failed for Order ID: " + orderId);
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
}