package lk.techmart.web;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import lk.techmart.core.entity.Customer;
import lk.techmart.core.entity.Product;
import lk.techmart.ejb.CustomerServiceBean;
import lk.techmart.ejb.OrderServiceBean;
import lk.techmart.ejb.ProductServiceBean;
import lk.techmart.ejb.ShoppingCartBean;

import jakarta.ejb.EJB;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@WebServlet("/test-cart")
public class CartServlet extends HttpServlet {

    @EJB
    private ProductServiceBean  productServiceBean;

    @EJB
    private ShoppingCartBean   shoppingCartBean;

    @EJB
    private OrderServiceBean orderService;

    @EJB
    private CustomerServiceBean customerService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<html><body>");
        out.println("<h2>TechMart - EJB Test</h2>");

        try {

            String action = request.getParameter("action");

            if ("add_product".equals(action)) {
                Product p = new Product();
                p.setProductCode("PROD-" + System.currentTimeMillis());
                p.setProductName("Test Laptop");
                p.setPrice(new BigDecimal("150000.00"));
                p.setStatus("ACTIVE");

                productServiceBean.addProduct(p);
                out.println("<p style='color:green'>Product added to Database!</p>");
            }


            out.println("<h3>Available Products (From DB):</h3>");
            List<Product> products = productServiceBean.getAllProducts();
            for (Product p : products) {
                out.println("<p>ID: " + p.getProductId() + " | Name: " + p.getProductName() + " | Price: Rs." + p.getPrice() + " </p>");

                out.println("<a href='?action=add_to_cart&pid=" + p.getProductId() + "'>[ Add to Cart ]</a><br>");
            }

            if ("add_to_cart".equals(action)) {
                Long pid = Long.parseLong(request.getParameter("pid"));
                shoppingCartBean.addItem(pid, 1);
                out.println("<p style='color:blue'>Item added to Cart Memory!</p>");
            }

            if ("checkout".equals(action)) {
                Map<Long, Integer> cart = shoppingCartBean.getCartItems();
                if (cart.isEmpty()) {
                    out.println("<p style='color:red'>Cart is empty! Cannot checkout.</p>");
                } else {
                    Customer dummyCustomer = customerService.createTestCustomer();

                    Long orderId = orderService.placeOrder(dummyCustomer.getCustomerId(), cart);

                    shoppingCartBean.clearCart();

                    out.println("<h3 style='color:green; background:#e8f5e9; padding:10px;'>Order Placed Successfully! 🎉 Order ID: " + orderId + "</h3>");
                }
            }


            out.println("<hr><h3>Your Shopping Cart (In Memory):</h3>");
            Map<Long, Integer> cart = shoppingCartBean.getCartItems();
            if (cart.isEmpty()) {
                out.println("<p>Cart is empty.</p>");
            } else {
                for (Map.Entry<Long, Integer> entry : cart.entrySet()) {
                    out.println("<p>Product ID: " + entry.getKey() + " | Qty: " + entry.getValue() + "</p>");
                }
            }


            out.println("<hr>");
            out.println("<a href='?action=add_product'>1. Create New Product</a> | ");
            out.println("<a href='test-cart'>2. Refresh Page</a>");
            out.println("<a href='?action=checkout' style='color:green; font-weight:bold;'>3. Checkout (Place Order)</a>");

        } catch (Exception e) {
            out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");

            Throwable rootCause = e;
            while (rootCause.getCause() != null && rootCause.getCause() != rootCause) {
                rootCause = rootCause.getCause();
            }
            out.println("<p style='color:darkred'><b>Root Cause (Aththama Hethuwa):</b> " + rootCause.getMessage() + "</p>");

            e.printStackTrace();
        }

        out.println("</body></html>");
    }
}
