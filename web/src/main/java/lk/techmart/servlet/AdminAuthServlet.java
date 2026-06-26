package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.techmart.core.dto.AdminDTO;
import lk.techmart.core.service.AdminService;

import java.io.IOException;

@WebServlet("/admin-auth")
public class AdminAuthServlet extends HttpServlet {

    @EJB
    private AdminService adminService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession(false);

        if ("logout".equals(action)) {
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/admin-auth");
            return;
        }

        if (session != null && "ADMIN".equals(session.getAttribute("userRole"))) {
            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
            return;
        }

        req.getRequestDispatcher("/admin-login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        AdminDTO admin = adminService.loginAdmin(req.getParameter("email"), req.getParameter("password"));

        if (admin != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("loggedUserId", admin.getUserId());

            session.setAttribute("loggedUserName", admin.getUsername());
            session.setAttribute("loggedUserEmail", admin.getEmail());
            session.setAttribute("userRole", admin.getUserTypeName());

            resp.sendRedirect(req.getContextPath() + "/admin-auth");
        } else {
            req.setAttribute("errorMessage", "Access Denied! Invalid Credentials.");
            req.getRequestDispatcher("/admin-login.jsp").forward(req, resp);
        }
    }
}