package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import lk.techmart.core.dto.ProductDTO;
import lk.techmart.core.service.ProductService;
import lk.techmart.ejb.ProductServiceBean;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/ProductServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class ProductServlet extends HttpServlet {

    @EJB
    private ProductService productService;

    private static final String UPLOAD_DIR = System.getProperty("user.home") + File.separator + "TechMartImages";

    @Override
    public void init() throws ServletException {
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            try {
                String productName = req.getParameter("productName");
                String description = req.getParameter("description");
                String priceStr = req.getParameter("price");
                String costPriceStr = req.getParameter("costPrice");
                String weightStr = req.getParameter("weight");
                String categoryId = req.getParameter("categoryId");
                String brandId = req.getParameter("brandId");
                String statusId = req.getParameter("statusId");

                String generatedProductCode = "PROD-" + System.currentTimeMillis();

                File productDir = new File(UPLOAD_DIR, generatedProductCode);
                if (!productDir.exists()) {
                    productDir.mkdirs();
                }

                Part primaryImagePart = req.getPart("primaryImage");
                String image1Name = saveImageFile(primaryImagePart, productDir, "image1");

                Part secondaryImagePart = req.getPart("secondaryImage");
                if (secondaryImagePart != null && secondaryImagePart.getSize() > 0) {
                    saveImageFile(secondaryImagePart, productDir, "image2");
                }

                ProductDTO dto = new ProductDTO();
                dto.setProductCode(generatedProductCode);
                dto.setProductName(productName);
                dto.setDescription(description);
                dto.setPrice(new BigDecimal(priceStr));

                if (costPriceStr != null && !costPriceStr.isEmpty()) {
                    dto.setCostPrice(new BigDecimal(costPriceStr));
                }
                if (weightStr != null && !weightStr.isEmpty()) {
                    dto.setWeight(new BigDecimal(weightStr));
                }

                dto.setCategory(categoryId);
                dto.setBrand(brandId);
                dto.setStatus(statusId);

                if (image1Name != null) {
                    dto.setImageUrl(generatedProductCode + "/" + image1Name);
                }

                productService.addProduct(dto);
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("Product saved successfully!");

            } catch (Exception e) {
                e.printStackTrace();
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("Error saving product: " + e.getMessage());
            }
        }
    }

    private String saveImageFile(Part part, File targetDir, String baseName) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        String originalName = part.getSubmittedFileName();
        String extension = "";
        if (originalName != null && originalName.contains(".")) {
            extension = originalName.substring(originalName.lastIndexOf("."));
        }

        String newFileName = baseName + extension;
        File fileToSave = new File(targetDir, newFileName);

        try (InputStream input = part.getInputStream()) {
            Files.copy(input, fileToSave.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        return newFileName;
    }
}
