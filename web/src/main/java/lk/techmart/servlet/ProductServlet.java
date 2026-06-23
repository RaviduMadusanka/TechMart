package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import lk.techmart.core.dto.BrandDTO;
import lk.techmart.core.dto.CategoryDTO;
import lk.techmart.core.dto.ProductDTO;
import lk.techmart.core.entity.Brand;
import lk.techmart.core.entity.Category;
import lk.techmart.core.service.ProductService;
import lk.techmart.ejb.ProductServiceBean;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/ProductServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class ProductServlet extends HttpServlet {

    @EJB
    private ProductService productService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");
            ProductDTO dto = new ProductDTO();
            String productCode = "";

            if ("update".equals(action)) {
                Long productId = Long.parseLong(req.getParameter("productId"));
                dto.setProductId(productId);

                ProductDTO existingProduct = productService.getProductById(productId);
                productCode = existingProduct.getProductCode();
                dto.setProductCode(productCode);
            } else {
                productCode = "PROD-" + System.currentTimeMillis();
                dto.setProductCode(productCode);
            }

            dto.setProductName(req.getParameter("productName"));
            dto.setDescription(req.getParameter("description"));
            dto.setPrice(new BigDecimal(req.getParameter("price")));

            String costPrice = req.getParameter("costPrice");
            if (costPrice != null && !costPrice.isEmpty()) {
                dto.setCostPrice(new BigDecimal(costPrice));
            }

            String weight = req.getParameter("weight");
            if (weight != null && !weight.isEmpty()) {
                dto.setWeight(new BigDecimal(weight));
            }

            String categoryId = req.getParameter("categoryId");
            if (categoryId != null && !categoryId.isEmpty()) {
                CategoryDTO cat = new CategoryDTO();
                cat.setCategoryId(Long.parseLong(categoryId));
                dto.setCategory(cat);
            }

            String brandId = req.getParameter("brandId");
            if (brandId != null && !brandId.isEmpty()) {
                BrandDTO brand = new BrandDTO();
                brand.setBrandId(Long.parseLong(brandId));
                dto.setBrand(brand);
            }

            String statusIdStr = req.getParameter("statusId");
            String statusName = "ACTIVE";
            if("2".equals(statusIdStr)) statusName = "INACTIVE";
            else if("3".equals(statusIdStr)) statusName = "OUT_OF_STOCK";
            dto.setStatus(statusName);

            Part primaryPart = req.getPart("primaryImage");
            if (primaryPart != null && primaryPart.getSize() > 0) {
                String savedImagePath = saveFile(primaryPart, productCode, "primary");
                dto.setImageUrl(savedImagePath);
            }

            if ("update".equals(action)) {
                productService.updateProduct(dto);
                resp.getWriter().write("Product updated successfully!");
            } else {
                productService.addProduct(dto);
                resp.getWriter().write("Product added successfully!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Error: " + e.getMessage());
        }
    }

    private String saveFile(Part part, String productCode, String prefix) throws IOException {
        String UPLOAD_DIR = System.getProperty("user.home") + File.separator + "TechMartImages";
        File uploadDir = new File(UPLOAD_DIR, productCode);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String originalName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String extension = "";
        int i = originalName.lastIndexOf('.');
        if (i > 0) {
            extension = originalName.substring(i);
        }

        String fileName = prefix + extension;
        File file = new File(uploadDir, fileName);

        try (InputStream input = part.getInputStream()) {
            Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        return productCode + "/" + fileName;
    }
}
