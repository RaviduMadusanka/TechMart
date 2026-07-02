package lk.techmart.servlet;

import com.google.gson.Gson;
import jakarta.ejb.EJB;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;
import jakarta.json.bind.Jsonb;
import jakarta.json.bind.JsonbBuilder;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.techmart.core.dto.BrandDTO;
import lk.techmart.core.dto.CategoryDTO;
import lk.techmart.core.dto.ProductDTO;
import lk.techmart.core.dto.WarehousesDTO;
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
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if ("get_categories".equals(action)) {
                List<CategoryDTO> categories = productService.getAllCategories();
                JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();

                for (CategoryDTO c : categories) {
                    arrayBuilder.add(Json.createObjectBuilder()
                            .add("categoryId", c.getCategoryId())
                            .add("name", c.getName()));
                }
                resp.getWriter().write(arrayBuilder.build().toString());

            } else if ("get_brands".equals(action)) {
                List<BrandDTO> brands = productService.getAllBrands();
                JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();

                for (BrandDTO b : brands) {
                    arrayBuilder.add(Json.createObjectBuilder()
                            .add("brandId", b.getBrandId())
                            .add("name", b.getName()));
                }
                resp.getWriter().write(arrayBuilder.build().toString());

            } else if ("get_all".equals(action)) {
                List<ProductDTO> products = productService.getAllProducts();
                Gson gson = new Gson();
                String jsonString = gson.toJson(products);

                resp.getWriter().write(jsonString);
            }else if ("get_warehouses".equals(action)) {
                List<WarehousesDTO> warehouses = productService.getAllWarehouses();
                JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();

                for (WarehousesDTO w : warehouses) {
                    arrayBuilder.add(Json.createObjectBuilder()
                            .add("warehouseId", w.getWarehouseId())
                            .add("warehouseName", w.getWarehouseName()));
                }
                resp.getWriter().write(arrayBuilder.build().toString());

            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if ("add_category".equals(action)) {
                String name = req.getParameter("name");

                if (name == null || name.trim().isEmpty()) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"success\": false, \"message\": \"Category name cannot be empty.\"}");
                    return;
                }

                CategoryDTO dto = new CategoryDTO();
                dto.setName(name);

                boolean success = productService.addCategory(dto);

                if (success) {
                    resp.getWriter().write("{\"success\": true, \"message\": \"Category added successfully!\"}");
                } else {
                    resp.setStatus(HttpServletResponse.SC_CONFLICT);
                    resp.getWriter().write("{\"success\": false, \"message\": \"Category already exists!\"}");
                }
            }else if ("add_brand".equals(action)) {
                String name = req.getParameter("name");

                if (name == null || name.trim().isEmpty()) {
                    resp.getWriter().write("{\"success\": false, \"message\": \"Brand name cannot be empty!\"}");
                    return;
                }

                BrandDTO dto = new BrandDTO();
                dto.setName(name);
                boolean success = productService.addBrand(dto);

                if (success) {
                    resp.getWriter().write("{\"success\": true, \"message\": \"Brand added successfully!\"}");
                } else {
                    resp.getWriter().write("{\"success\": false, \"message\": \"Brand already exists!\"}");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"success\": false, \"message\": \"Server error occurred.\"}");
        }
    }
}
