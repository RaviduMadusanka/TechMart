package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.techmart.core.dto.ProductDTO;
import lk.techmart.core.service.ProductService;

import java.io.IOException;

@WebServlet("/single-product")
public class SingleProductServlet extends HttpServlet {

    @EJB
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isEmpty()) {
            Long productId = Long.parseLong(idParam);
            ProductDTO product = productService.getProductById(productId);

            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/SingleProductView.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect("home.jsp");
    }
}