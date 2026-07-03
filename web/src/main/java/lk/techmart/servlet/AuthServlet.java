package lk.techmart.servlet;

import jakarta.servlet.http.HttpServlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.techmart.core.dto.AdminDTO;
import lk.techmart.core.dto.CustomerDTO;
import lk.techmart.core.entity.CartItem;
import lk.techmart.core.entity.ShoppingCart;
import lk.techmart.core.entity.User;
import lk.techmart.core.service.AdminService;
import lk.techmart.core.service.CartService;
import lk.techmart.core.service.CustomerService;
import lk.techmart.ejb.ShoppingCartBean;

import javax.naming.InitialContext;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    @EJB
    private CustomerService customerService;

    @EJB
    private AdminService adminService;

    @EJB
    private CartService cartService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession(false);

        if ("logout".equals(action)) {
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        if (session != null && session.getAttribute("loggedUserEmail") != null) {
            req.getRequestDispatcher("/home").forward(req, resp);
            return;
        }

        if ("register".equals(action)) {
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("register".equals(action)) {
            CustomerDTO dto = new CustomerDTO();
            dto.setFirstName(req.getParameter("firstName"));
            dto.setLastName(req.getParameter("lastName"));
            dto.setEmail(req.getParameter("email"));
            dto.setPassword(req.getParameter("password"));

            boolean success = customerService.registerCustomer(dto);
            if (success) {
                req.setAttribute("successMessage", "Registration Successful! Please login.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            } else {
                req.setAttribute("errorMessage", "Error! Email may already exist.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
            }

        } else if ("login".equals(action)) {
            String email = req.getParameter("email");
            String password = req.getParameter("password");

            AdminDTO adminUser = adminService.loginAdmin(email, password);

            if (adminUser != null) {
                System.out.println("DEBUG: Session username is: " + adminUser.getUsername());
                HttpSession session = req.getSession(true);
                session.setAttribute("loggedUserId", adminUser.getUserId());
                session.setAttribute("loggedUserEmail", adminUser.getEmail());
                session.setAttribute("loggedUserName", adminUser.getUsername());
                session.setAttribute("userRole", adminUser.getUserTypeName());

                resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
                return;
            }

            CustomerDTO customer = customerService.loginCustomer(email, password);

            if (customer != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("loggedUserId", customer.getCustomerId());
                session.setAttribute("loggedUserEmail", customer.getEmail());
                session.setAttribute("loggedUserName", customer.getFirstName() + " " + customer.getLastName());
                session.setAttribute("userRole", "CUSTOMER");
                session.setAttribute("customer", customer);

                try {
                    ShoppingCartBean cartBean = (ShoppingCartBean) session.getAttribute("shoppingCart");
                    if (cartBean == null) {
                        InitialContext ic = new InitialContext();
                        try {
                            cartBean = (ShoppingCartBean) ic.lookup("java:app/ejb/ShoppingCartBean");
                        } catch (Exception e1) {
                            try {
                                cartBean = (ShoppingCartBean) ic.lookup("java:app/ejb-1.0-SNAPSHOT/ShoppingCartBean");
                            } catch (Exception e2) {
                                cartBean = (ShoppingCartBean) ic.lookup("java:module/ShoppingCartBean");
                            }
                        }
                        session.setAttribute("shoppingCart", cartBean);
                    }

                    Map<Long, Integer> guestItems = new HashMap<>(cartBean.getCartItems());
                    for (Map.Entry<Long, Integer> entry : guestItems.entrySet()) {
                        cartService.addItem(customer.getCustomerId(), entry.getKey(), entry.getValue());
                    }

                    ShoppingCart dbCart = cartService.getCartByCustomer(customer.getCustomerId());
                    cartBean.clearCart();

                    if (dbCart != null && dbCart.getItems() != null) {
                        for (CartItem item : dbCart.getItems()) {
                            cartBean.addItem(item.getProduct().getProductId(), item.getQuantity());
                        }
                    }

                } catch (Exception e) {
                    System.out.println("Error syncing cart: " + e.getMessage());
                }


                resp.sendRedirect(req.getContextPath() + "/home");
            } else {
                req.setAttribute("errorMessage", "Invalid Email or Password!");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        }
    }
}