package lk.techmart.web;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import lk.techmart.core.dto.ProductDTO;
import lk.techmart.core.entity.Customer;
import lk.techmart.core.entity.Product;
import lk.techmart.core.service.ProductService;
import lk.techmart.ejb.CustomerServiceBean;
import lk.techmart.ejb.OrderServiceBean;
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
    private ProductService productService;

    @EJB
    private ShoppingCartBean shoppingCart;

    @EJB
    private OrderServiceBean orderService;

    @EJB
    private CustomerServiceBean customerService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<html><body>");
        out.println("<h2>TechMart - EJB Test (DTO Pattern Implemented)</h2>");

        try {
            String action = request.getParameter("action");

            if ("add_product".equals(action)) {
                ProductDTO pDTO = new ProductDTO();
                pDTO.setProductCode("PROD-" + System.currentTimeMillis());
                pDTO.setProductName("Test Laptop DTO");
                pDTO.setDescription("High performance gaming laptop");
                pDTO.setCategory("Laptops");
                pDTO.setBrand("Asus ROG");
                pDTO.setPrice(new BigDecimal("250000.00"));
                pDTO.setCostPrice(new BigDecimal("200000.00"));
                pDTO.setImageUrl("images/rog_laptop.png");
                pDTO.setWeight(new BigDecimal("2.5"));
                pDTO.setStatus("ACTIVE");

                // Service එකට යවන්නේ DTO එකක්
                productService.addProduct(pDTO);
                out.println("<p style='color:green'>Product database ekata add wuna (DTO haraha)!</p>");
            }

            out.println("<h3>Available Products (DB ekෙන් DTO haraha):</h3>");

            List<ProductDTO> products = productService.getAllProducts();
            for (ProductDTO p : products) {
                out.println("<p>ID: " + p.getProductId() + " | Name: " + p.getProductName() + " | Price: Rs." + p.getPrice() + " </p>");
                out.println("<a href='?action=add_to_cart&pid=" + p.getProductId() + "'>[ Cart ekata Danna ]</a><br>");
            }

            // 3. Cart එකට Add කිරීම
            if ("add_to_cart".equals(action)) {
                Long pid = Long.parseLong(request.getParameter("pid"));
                shoppingCart.addItem(pid, 1);
                out.println("<p style='color:blue'>Item eka Cart Memory ekata add wuna!</p>");
            }

            // 3.5 Checkout කිරීම (Order Processing)
            if ("checkout".equals(action)) {
                Map<Long, Integer> cart = shoppingCart.getCartItems();
                if (cart.isEmpty()) {
                    out.println("<p style='color:red'>Cart eka his! Checkout karanna ba.</p>");
                } else {
                    Customer dummyCustomer = customerService.createTestCustomer();
                    Long orderId = orderService.placeOrder(dummyCustomer.getCustomerId(), cart);
                    shoppingCart.clearCart();
                    out.println("<h3 style='color:green; background:#e8f5e9; padding:10px;'>Order eka sarthakai! 🎉 Order ID: " + orderId + "</h3>");
                }
            }

            out.println("<hr><h3>Your Shopping Cart (In Memory):</h3>");
            Map<Long, Integer> cart = shoppingCart.getCartItems();
            if (cart.isEmpty()) {
                out.println("<p>Cart eka his.</p>");
            } else {
                for (Map.Entry<Long, Integer> entry : cart.entrySet()) {
                    out.println("<p>Product ID: " + entry.getKey() + " | Qty: " + entry.getValue() + "</p>");
                }
            }

            out.println("<hr>");
            out.println("<a href='?action=add_product'>1. Create New Product</a> | ");
            out.println("<a href='test-cart'>2. Refresh Page</a> | ");
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
