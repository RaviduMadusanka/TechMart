package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.techmart.core.service.CartService;
import lk.techmart.ejb.ShoppingCartBean;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import java.io.IOException;

@WebServlet("/cart-action")
public class CartServlet extends HttpServlet {

    @EJB
    private CartService cartService;

    private ShoppingCartBean getShoppingCart(HttpSession session) throws ServletException {
        ShoppingCartBean cartBean = (ShoppingCartBean) session.getAttribute("shoppingCart");

        if (cartBean == null) {
            try {
                InitialContext ic = new InitialContext();
                try {
                    cartBean = (ShoppingCartBean) ic.lookup("java:app/ejb/ShoppingCartBean");
                } catch (NamingException e1) {
                    try {
                        cartBean = (ShoppingCartBean) ic.lookup("java:app/ejb-1.0-SNAPSHOT/ShoppingCartBean");
                    } catch (NamingException e2) {
                        cartBean = (ShoppingCartBean) ic.lookup("java:module/ShoppingCartBean");
                    }
                }

                session.setAttribute("shoppingCart", cartBean);
                System.out.println("New Stateful Shopping Cart Created for User!");
            } catch (NamingException e) {
                throw new ServletException("JNDI Lookup Failed! Check Payara Server logs for exact JNDI name.", e);
            }
        }
        return cartBean;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(true);
        ShoppingCartBean shoppingCart = getShoppingCart(session);
        Long customerId = (Long) session.getAttribute("loggedUserId");

        try {
            if ("add".equals(action)) {
                Long productId = Long.parseLong(request.getParameter("productId"));

                String qtyStr = request.getParameter("qty");
                int qty = (qtyStr != null && !qtyStr.isEmpty()) ? Integer.parseInt(qtyStr) : 1;

                shoppingCart.addItem(productId, qty);

                if (customerId != null) {
                    cartService.addItem(customerId, productId, qty);
                }

                session.setAttribute("cartSuccessMessage", "Product successfully added to your cart! 🛒");

                String referer = request.getHeader("Referer");
                response.sendRedirect(referer != null ? referer : request.getContextPath() + "/home");

            } else if ("remove".equals(action)) {
                Long productId = Long.parseLong(request.getParameter("productId"));
                shoppingCart.removeItem(productId);

                if (customerId != null) {
                    cartService.removeItem(customerId, productId);
                }

                response.sendRedirect(request.getContextPath() + "/cart.jsp");

            } else if ("update".equals(action)) {
                Long productId = Long.parseLong(request.getParameter("productId"));
                int qty = Integer.parseInt(request.getParameter("qty"));
                shoppingCart.updateQuantity(productId, qty);

                if (customerId != null) {
                    cartService.updateItem(customerId, productId, qty);
                }

                response.sendRedirect(request.getContextPath() + "/cart.jsp");

            } else if ("clear".equals(action)) {
                shoppingCart.clearCart();

                if (customerId != null) {
                    cartService.clearCart(customerId);
                }

                response.sendRedirect(request.getContextPath() + "/cart.jsp");
            }


        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }

    }
}