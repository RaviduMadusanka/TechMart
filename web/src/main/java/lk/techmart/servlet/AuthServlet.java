package lk.techmart.servlet;

import jakarta.servlet.http.HttpServlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.techmart.core.dto.CustomerDTO;
import lk.techmart.core.service.CustomerService;

import java.io.IOException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    @EJB
    private CustomerService customerService;

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
            req.getRequestDispatcher("/home.jsp").forward(req, resp);
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
            CustomerDTO user = customerService.loginCustomer(req.getParameter("email"), req.getParameter("password"));

            if (user != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("loggedUserId", user.getCustomerId());
                session.setAttribute("loggedUserEmail", user.getEmail());
                session.setAttribute("loggedUserName", user.getFirstName() + " " + user.getLastName());

                resp.sendRedirect(req.getContextPath() + "/home.jsp");
            } else {
                req.setAttribute("errorMessage", "Invalid Email or Password!");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        }
    }
}