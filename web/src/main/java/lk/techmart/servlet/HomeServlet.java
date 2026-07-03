package lk.techmart.servlet;

import com.google.gson.Gson;
import jakarta.ejb.EJB;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.techmart.core.dto.CategoryDTO;
import lk.techmart.core.dto.ProductDTO;
import lk.techmart.core.service.HomeService;

import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @EJB
    private HomeService homeService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {

            String catParam = request.getParameter("category");
            String sortParam = request.getParameter("sort");

            Long categoryId = null;
            if (catParam != null && !catParam.trim().isEmpty()) {
                categoryId = Long.parseLong(catParam);
            }

            List<CategoryDTO> categories = homeService.getAllCategories();
            List<ProductDTO> products;

            if ((catParam != null && !catParam.trim().isEmpty())
                    || (sortParam != null && !sortParam.trim().isEmpty())) {
                products = homeService.getFilteredProducts(categoryId, sortParam, 8);
            } else {
                products = homeService.getLatestProducts(8);
            }

            request.setAttribute("categoriesList", categories);
            request.setAttribute("productsList", products);

            request.getRequestDispatcher("/home.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }


    }
}
