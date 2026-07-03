package lk.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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

        String[] categories = request.getParameterValues("category");
        String[] brands = request.getParameterValues("brand");

        Double minPrice = null;
        Double maxPrice = null;

        try {
            if (minPriceStr != null && !minPriceStr.isEmpty()) minPrice = Double.parseDouble(minPriceStr);
            if (maxPriceStr != null && !maxPriceStr.isEmpty()) maxPrice = Double.parseDouble(maxPriceStr);
        } catch (NumberFormatException e) {
        }

        List<ProductDTO> searchResults = searchService.advancedSearch(keyword, categories, brands, minPrice, maxPrice, sort);

        request.setAttribute("productsList", searchResults);
        request.setAttribute("resultCount", searchResults != null ? searchResults.size() : 0);

        request.getRequestDispatcher("/advance-search.jsp").forward(request, response);
    }
}