package lk.techmart.servlet;

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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @EJB
    private CustomerService customerService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("customer = " + session.getAttribute("customer"));
        System.out.println("email = " + session.getAttribute("loggedUserEmail"));
        System.out.println("name = " + session.getAttribute("loggedUserName"));

        if (session == null || session.getAttribute("loggedUserId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        try {

            Long customerId = (Long) session.getAttribute("loggedUserId");

            CustomerDTO fullCustomer = customerService.getCustomerById(customerId);
            request.setAttribute("customer", fullCustomer);


        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        Long customerId = Long.parseLong(request.getParameter("customerId"));

        try {
            if ("updateInfo".equals(action)) {

                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");

                customerService.updateProfile(customerId, firstName, lastName, email, phone, address);
                session.setAttribute("profileSuccessMessage", "Profile updated successfully!");

            } else if ("updatePassword".equals(action)) {

                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");

                if (!newPassword.equals(confirmPassword)) {
                    session.setAttribute("profileErrorMessage", "New passwords do not match!");
                } else {
                    customerService.updatePassword(customerId, currentPassword, newPassword);
                    session.setAttribute("profileSuccessMessage", "Password changed successfully!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("profileErrorMessage", e.getMessage());
        }

        response.sendRedirect("profile");
    }
}