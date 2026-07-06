<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Arrays"%>
<%
    request.setAttribute("pageTitle", "Advanced Search - TechMart");

    String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
    String minPrice = request.getParameter("minPrice") != null ? request.getParameter("minPrice") : "";
    String maxPrice = request.getParameter("maxPrice") != null ? request.getParameter("maxPrice") : "";

    List<lk.techmart.core.dto.ProductDTO> productsList = (List<lk.techmart.core.dto.ProductDTO>) request.getAttribute("productsList");
    Integer resultCount = (Integer) request.getAttribute("resultCount");
    if (resultCount == null) resultCount = 0;

    Integer currentPage = (Integer) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = 1;
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    if (totalPages == null) totalPages = 1;
%>
<%
    // Database එකෙන් එන ලිස්ට්
    List<lk.techmart.core.dto.CategoryDTO> dbCategories = (List<lk.techmart.core.dto.CategoryDTO>) request.getAttribute("dbCategories");
    List<lk.techmart.core.dto.BrandDTO> dbBrands = (List<lk.techmart.core.dto.BrandDTO>) request.getAttribute("dbBrands");

    // User තෝරපු ටික් ටික ලිස්ට් එකක් විදිහට ගන්නවා (ලේසියෙන් check කරන්න පුළුවන් වෙන්න)
    String[] selectedCatsArr = (String[]) request.getAttribute("selectedCategories");
    String[] selectedBrandsArr = (String[]) request.getAttribute("selectedBrands");
    List<String> selectedCats = selectedCatsArr != null ? Arrays.asList(selectedCatsArr) : new ArrayList<>();
    List<String> selectedBrandsList = selectedBrandsArr != null ? Arrays.asList(selectedBrandsArr) : new ArrayList<>();
%>
<%@ include file="WEB-INF/includes/header.jsp" %>

<main class="flex-1">

    <section class="bg-gradient-to-r from-brand-800 via-brand-700 to-brand-600 text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
            <h1 class="text-2xl md:text-3xl font-bold">Advanced Search</h1>
            <p class="text-blue-100 text-sm mt-1">Narrow down products with keyword, category, brand, price & rating filters</p>
        </div>
    </section>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">

        <form id="searchForm" action="${pageContext.request.contextPath}/advance-search" method="get" class="mb-8">

            <input type="hidden" name="page" id="pageInput" value="1">

            <div class="relative">
                <input type="text" name="keyword" value="<%= keyword %>" placeholder="Search by product name, brand, model, SKU..."
                       class="w-full pl-12 pr-32 py-4 border border-gray-300 rounded-xl text-sm shadow-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent bg-white"/>
                <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                </svg>
                <button type="submit" class="btn-primary absolute right-2 top-1/2 -translate-y-1/2 !py-2 !px-6">
                    Search
                </button>
            </div>

            <div class="flex flex-col lg:flex-row gap-8 mt-8">

                <aside class="w-full lg:w-72 flex-shrink-0">
                    <div class="bg-white rounded-xl border border-gray-200 shadow-sm p-5 space-y-6 lg:sticky lg:top-24">
                        <div class="flex items-center justify-between">
                            <h2 class="text-sm font-bold text-gray-900 uppercase tracking-wide">Filters</h2>
                            <a href="${pageContext.request.contextPath}/advance-search" class="text-xs text-brand-600 hover:underline font-medium">Clear all</a>
                        </div>

                        <div class="border-t border-gray-100 pt-5">
                            <h3 class="text-sm font-semibold text-gray-800 mb-3">Category</h3>
                            <div class="space-y-2 text-sm text-gray-600">
                                <%
                                    if (dbCategories != null) {
                                        for (lk.techmart.core.dto.CategoryDTO cat : dbCategories) {
                                            String isChecked = selectedCats.contains(cat.getName()) ? "checked" : "";
                                %>
                                <label class="flex items-center gap-2 cursor-pointer hover:text-brand-600">
                                    <input type="checkbox" name="category" value="<%= cat.getName() %>" <%= isChecked %> class="w-4 h-4 rounded accent-brand-600"/>
                                    <%= cat.getName() %>
                                </label>
                                <%
                                        }
                                    }
                                %>
                            </div>
                        </div>

                        <div class="border-t border-gray-100 pt-5">
                            <h3 class="text-sm font-semibold text-gray-800 mb-3">Brand</h3>
                            <div class="space-y-2 text-sm text-gray-600">
                                <%
                                    if (dbBrands != null) {
                                        for (lk.techmart.core.dto.BrandDTO brand : dbBrands) {
                                            String isChecked = selectedBrandsList.contains(brand.getName()) ? "checked" : "";
                                %>
                                <label class="flex items-center gap-2 cursor-pointer hover:text-brand-600">
                                    <input type="checkbox" name="brand" value="<%= brand.getName() %>" <%= isChecked %> class="w-4 h-4 rounded accent-brand-600"/>
                                    <%= brand.getName() %>
                                </label>
                                <%
                                        }
                                    }
                                %>
                            </div>
                        </div>

                        <div class="border-t border-gray-100 pt-5">
                            <h3 class="text-sm font-semibold text-gray-800 mb-3">Price Range ($)</h3>
                            <div class="flex items-center gap-2">
                                <input type="number" name="minPrice" value="<%= minPrice %>" placeholder="Min" min="0" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500"/>
                                <span class="text-gray-400">–</span>
                                <input type="number" name="maxPrice" value="<%= maxPrice %>" placeholder="Max" min="0" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500"/>
                            </div>
                        </div>

                        <button type="submit" class="bg-brand-600 hover:bg-brand-700 text-white font-semibold w-full mt-2 py-2 rounded-lg transition-colors">Apply Filters</button>
                    </div>
                </aside>

                <section class="flex-1">

                    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
                        <div>
                            <h2 class="text-lg font-bold text-gray-900">Search Results</h2>
                            <p class="text-gray-500 text-sm mt-0.5">Showing <%= resultCount %> products<% if (!keyword.isEmpty()) { %> for "<%= keyword %>"<% } %></p>
                        </div>
                        <select name="sort" onchange="document.getElementById('pageInput').value=1; this.form.submit();" class="border border-gray-300 rounded-lg px-3 py-2 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-brand-500 bg-white">
                            <option value="">Sort: Relevance</option>
                            <option value="Price: Low to High">Price: Low to High</option>
                            <option value="Price: High to Low">Price: High to Low</option>
                            <option value="Newest First">Newest First</option>
                        </select>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-6">
                        <%
                            if (productsList != null && !productsList.isEmpty()) {
                                for (lk.techmart.core.dto.ProductDTO p : productsList) {
                                    String priceStr = String.format("%.2f", p.getPrice());
                                    String imageSrc = (p.getImageUrl() != null && !p.getImageUrl().trim().isEmpty())
                                            ? request.getContextPath() + "/image?file=" + p.getImageUrl() : "";
                                    String catName = (p.getCategory() != null && p.getCategory().getName() != null)
                                            ? p.getCategory().getName() : "TechMart";
                        %>
                        <div class="product-card bg-white rounded-xl border border-gray-200 shadow-sm hover:shadow-md transition-shadow overflow-hidden group">
                            <a href="<%= request.getContextPath() %>/single-product?id=<%= p.getProductId() %>">
                                <div class="relative overflow-hidden bg-gray-50 h-48 flex items-center justify-center">
                                    <% if (!imageSrc.isEmpty()) { %>
                                    <img src="<%= imageSrc %>" class="object-cover h-full w-full" />
                                    <% } else { %>
                                    <div class="product-img w-28 h-28 bg-gradient-to-br from-brand-100 to-brand-200 rounded-xl flex items-center justify-center">
                                        <svg class="w-14 h-14 text-brand-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17H3a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v10a2 2 0 01-2 2h-2"/>
                                        </svg>
                                    </div>
                                    <% } %>
                                </div>
                            </a>
                            <div class="p-4">
                                <p class="text-xs text-brand-600 font-medium mb-1 uppercase tracking-wide"><%= catName %></p>
                                <a href="<%= request.getContextPath() %>/single-product?id=<%= p.getProductId() %>">
                                    <h3 class="text-sm font-semibold text-gray-900 hover:text-brand-600 transition-colors mb-2 line-clamp-2"><%= p.getProductName() %></h3>
                                </a>

                                <div class="flex items-center justify-between mt-3">
                                    <span class="text-lg font-bold text-gray-900">Rs.<%= priceStr %></span>
                                    <form action="<%= request.getContextPath() %>/cart-action" method="post">
                                        <input type="hidden" name="productId" value="<%= p.getProductId() %>"/>
                                        <input type="hidden" name="action" value="add"/>
                                        <input type="hidden" name="qty" value="1"/>
                                        <button type="submit" class="bg-brand-600 hover:bg-brand-700 text-white text-xs font-semibold px-3 py-2 rounded-lg transition-colors active:scale-95">
                                            + Cart
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <%
                            }
                        } else {
                        %>
                        <div class="col-span-full text-center py-16">
                            <p class="text-5xl mb-4">🔍</p>
                            <h3 class="text-lg font-semibold text-gray-800">No products found</h3>
                            <p class="text-gray-500 text-sm mt-1">Try adjusting your filters or search keywords</p>
                        </div>
                        <%
                            }
                        %>
                    </div>

                    <% if (totalPages > 1) { %>
                    <div class="flex items-center justify-center gap-2 mt-10">
                        <% if (currentPage > 1) { %>
                        <button type="button" onclick="goToPage(<%= currentPage - 1 %>)" class="w-9 h-9 flex items-center justify-center rounded-lg border border-gray-300 text-gray-500 hover:bg-gray-50">‹</button>
                        <% } %>

                        <% for (int i = 1; i <= totalPages; i++) { %>
                        <button type="button" onclick="goToPage(<%= i %>)" class="w-9 h-9 flex items-center justify-center rounded-lg <%= i == currentPage ? "bg-brand-600 text-white font-semibold border-brand-600" : "border border-gray-300 text-gray-600 hover:bg-gray-50" %>">
                            <%= i %>
                        </button>
                        <% } %>

                        <% if (currentPage < totalPages) { %>
                        <button type="button" onclick="goToPage(<%= currentPage + 1 %>)" class="w-9 h-9 flex items-center justify-center rounded-lg border border-gray-300 text-gray-500 hover:bg-gray-50">›</button>
                        <% } %>
                    </div>

                    <script>
                        function goToPage(pageNum) {
                            document.getElementById('pageInput').value = pageNum;
                            document.getElementById('searchForm').submit();
                        }
                    </script>
                    <% } %>

                </section>
            </div>
        </form>
    </div>
</main>

<%@ include file="WEB-INF/includes/footer.jsp" %>