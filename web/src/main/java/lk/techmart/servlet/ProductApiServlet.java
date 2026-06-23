package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.json.bind.Jsonb;
import jakarta.json.bind.JsonbBuilder;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.techmart.core.dto.BrandDTO;
import lk.techmart.core.dto.CategoryDTO;
import lk.techmart.core.service.ProductService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/products")
public class ProductApiServlet extends HttpServlet {

    @EJB
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        Jsonb jsonb = JsonbBuilder.create();

        if ("get_categories".equals(action)) {
            List<CategoryDTO> categories = productService.getAllCategories();
            String json = jsonb.toJson(categories);
            out.print(json);
        }
        else if ("get_brands".equals(action)) {
            List<BrandDTO> brands = productService.getAllBrands();
            String json = jsonb.toJson(brands);
            out.print(json);
        }
    }
}
