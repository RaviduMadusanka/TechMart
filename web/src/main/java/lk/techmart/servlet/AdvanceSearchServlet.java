package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.techmart.core.dto.BrandDTO;
import lk.techmart.core.dto.CategoryDTO;
import lk.techmart.core.dto.ProductDTO;
import lk.techmart.core.service.SearchService;

import java.io.IOException;
import java.util.List;

@WebServlet("/advance-search")
public class AdvanceSearchServlet extends HttpServlet {

    @EJB
    private SearchService searchService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String sort = request.getParameter("sort");
        String pageStr = request.getParameter("page");
        int currentPage = 1;
        int pageSize = 8;

        String[] categories = request.getParameterValues("category");
        String[] brands = request.getParameterValues("brand");

        Double minPrice = null;
        Double maxPrice = null;

        try {
            if (minPriceStr != null && !minPriceStr.isEmpty()) {
                minPrice = Double.parseDouble(minPriceStr);
            }
            if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
                maxPrice = Double.parseDouble(maxPriceStr);
            }
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        long totalProducts = searchService.getAdvancedSearchCount(keyword, categories, brands, minPrice, maxPrice);

        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        if (totalPages == 0) totalPages = 1;

        int offset = (currentPage - 1) * pageSize;
        List<ProductDTO> searchResults = searchService.advancedSearch(keyword, categories, brands, minPrice, maxPrice, sort, offset, pageSize);

        request.setAttribute("productsList", searchResults);
        request.setAttribute("resultCount", (int) totalProducts);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        List<CategoryDTO> dbCategories = searchService.getAllCategories();
        List<BrandDTO> dbBrands = searchService.getAllBrands();

        request.setAttribute("dbCategories", dbCategories);
        request.setAttribute("dbBrands", dbBrands);

        request.setAttribute("selectedCategories", categories);
        request.setAttribute("selectedBrands", brands);

        request.setAttribute("productsList", searchResults);
        request.setAttribute("resultCount", (int) totalProducts);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/advance-search.jsp").forward(request, response);
    }
}