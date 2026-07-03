<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, lk.techmart.core.dto.ProductDTO, lk.techmart.core.dto.CategoryDTO"%>
<%
    request.setAttribute("pageTitle", "Home - Latest Tech Deals");

    List<CategoryDTO> categoriesList = (List<CategoryDTO>) request.getAttribute("categoriesList");
    List<ProductDTO> productsList = (List<ProductDTO>) request.getAttribute("productsList");

    String selectedCategory = request.getParameter("category");
    String selectedSort = request.getParameter("sort");

    if (categoriesList == null || productsList == null) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }
%>
<%@ include file="WEB-INF/includes/header.jsp" %>

<main class="flex-1">

    <%
        String cartSuccess = (String) session.getAttribute("cartSuccessMessage");
        if (cartSuccess != null) {
    %>
    <div id="cartAlert" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-4 animate-bounce">
        <div class="bg-emerald-50 border border-emerald-400 text-emerald-800 px-4 py-3 rounded-xl relative flex items-center justify-between shadow-sm" role="alert">
            <div class="flex items-center gap-2">
                <svg class="w-5 h-5 text-emerald-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <span class="font-medium text-sm"><%= cartSuccess %></span>
            </div>
            <button onclick="document.getElementById('cartAlert').style.display='none'" class="text-emerald-600 hover:text-emerald-800 font-bold text-lg focus:outline-none">
                &times;
            </button>
        </div>
    </div>
    <%
            session.removeAttribute("cartSuccessMessage");
        }
    %>

    <section class="bg-gradient-to-r from-brand-800 via-brand-700 to-brand-600 text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 flex flex-col md:flex-row items-center gap-10">
            <div class="flex-1">
                <span class="inline-block bg-white/20 text-white text-xs font-semibold px-3 py-1 rounded-full mb-4 uppercase tracking-wider">New Arrivals 2025</span>
                <h1 class="text-4xl md:text-5xl font-bold leading-tight mb-4">
                    Next-Gen Tech.<br>
                    <span class="text-blue-200">Unbeatable Prices.</span>
                </h1>
                <p class="text-blue-100 text-lg mb-8 max-w-md">Discover the latest laptops, smartphones, and accessories. Free delivery on orders above $50.</p>
                <div class="flex gap-4 flex-wrap">
                    <a href="advance-search" class="bg-white text-brand-700 font-bold px-6 py-3 rounded-lg hover:bg-blue-50 transition-colors shadow-lg">
                        Shop Now →
                    </a>
                    <a href="#" class="border border-white/50 text-white font-semibold px-6 py-3 rounded-lg hover:bg-white/10 transition-colors">
                        View Deals
                    </a>
                </div>
            </div>
            <div class="flex-1 flex justify-center">
                <div class="w-64 h-64 bg-white/10 rounded-2xl flex items-center justify-center border border-white/20 shadow-2xl">
                    <svg class="w-32 h-32 text-white/60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17H3a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v10a2 2 0 01-2 2h-2"/>
                    </svg>
                </div>
            </div>
        </div>
    </section>

    <section class="bg-white border-b border-gray-100">
        <div class="max-w-7xl mx-auto px-4 py-5 grid grid-cols-2 md:grid-cols-4 gap-6 text-sm text-gray-600">
            <div class="flex items-center gap-3">
                <span class="text-2xl">🚚</span>
                <div><p class="font-semibold text-gray-800">Free Delivery</p><p class="text-xs">Orders above $50</p></div>
            </div>
            <div class="flex items-center gap-3">
                <span class="text-2xl">🔒</span>
                <div><p class="font-semibold text-gray-800">Secure Payment</p><p class="text-xs">SSL encrypted checkout</p></div>
            </div>
            <div class="flex items-center gap-3">
                <span class="text-2xl">↩️</span>
                <div><p class="font-semibold text-gray-800">Easy Returns</p><p class="text-xs">30-day return policy</p></div>
            </div>
            <div class="flex items-center gap-3">
                <span class="text-2xl">🎧</span>
                <div><p class="font-semibold text-gray-800">24/7 Support</p><p class="text-xs">Always here for you</p></div>
            </div>
        </div>
    </section>

    <section id="products" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">

        <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-8">
            <div>
                <h2 class="text-2xl font-bold text-gray-900">Featured Products</h2>
                <p class="text-gray-500 text-sm mt-1">Showing all available products</p>
            </div>
            <div class="flex items-center gap-3">
                <select id="categorySelect" name="categoryId" class="border border-gray-300 rounded-lg px-3 py-2 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-brand-500 bg-white">
                    <option value="">All Categories</option>
                    <%
                        if (categoriesList != null) {
                            for (CategoryDTO c : categoriesList) {
                                String sel = (selectedCategory != null && selectedCategory.equals(String.valueOf(c.getCategoryId()))) ? "selected" : "";
                    %>
                    <option value="<%= c.getCategoryId() %>"><%= c.getName() %></option>
                    <%
                            }
                        }
                    %>
                </select>
                <select id="sortSelect" onchange="filterProducts()" class="border border-gray-300 rounded-lg px-3 py-2 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-brand-500 bg-white">
                    <option value="" <%= selectedSort == null || selectedSort.isEmpty() ? "selected" : "" %>>Sort: Featured</option>
                    <option value="price_asc" <%= "price_asc".equals(selectedSort) ? "selected" : "" %>>Price: Low to High</option>
                    <option value="price_desc" <%= "price_desc".equals(selectedSort) ? "selected" : "" %>>Price: High to Low</option>
                    <option value="newest" <%= "newest".equals(selectedSort) ? "selected" : "" %>>Newest First</option>
                </select>
            </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            <%
                if (productsList != null && !productsList.isEmpty()) {
                    for (ProductDTO p : productsList) {
                        String priceStr = String.format("%.2f", p.getPrice());

                        String imageSrc = (p.getImageUrl() != null && !p.getImageUrl().trim().isEmpty())
                                ? request.getContextPath() + "/image?file=" + p.getImageUrl()
                                : "";
            %>
            <div class="product-card bg-white rounded-xl border border-gray-200 shadow-sm hover:shadow-md transition-shadow overflow-hidden group">
                <a href="single-product?id=<%= p.getProductId() %>">
                    <div class="relative overflow-hidden bg-gray-50 h-48 flex items-center justify-center">
                        <% if (!imageSrc.isEmpty()) { %>
                        <img src="<%= imageSrc %>" alt="<%= p.getProductName() %>" class="object-cover h-full w-full" />
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
                    <p class="text-xs text-brand-600 font-medium mb-1 uppercase tracking-wide">
                        <%= p.getCategory() != null ? p.getCategory().getName() : "TechMart" %>
                    </p>
                    <a href="single-product?id=<%= p.getProductId() %>">
                        <h3 class="text-sm font-semibold text-gray-900 hover:text-brand-600 transition-colors mb-2 line-clamp-2"><%= p.getProductName() %></h3>
                    </a>

                    <div class="flex items-center gap-1 mb-3">
                        <div class="flex text-yellow-400 text-xs">★★★★★</div>
                        <span class="text-xs text-gray-500">4.5 (12)</span>
                    </div>

                    <div class="flex items-center justify-between">
                        <div>
                            <span class="text-lg font-bold text-gray-900">Rs.<%= priceStr %></span>
                        </div>
                        <form action="cart-action" method="post">
                            <input type="hidden" name="productId" value="<%= p.getProductId() %>"/>
                            <input type="hidden" name="action" value="add"/>
                            <input type="hidden" name="qty" value="1">
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
            <div class="col-span-full text-center py-10 text-gray-500">No products available at the moment.</div>
            <%
                }
            %>
        </div>

        <div class="text-center mt-10">
            <a href="advance-search"
               class="inline-block border-2 border-brand-600 text-brand-600 font-semibold px-8 py-3 rounded-lg hover:bg-brand-600 hover:text-white transition-all duration-200">
                Load More Products
            </a>
        </div>
    </section>

    <section class="bg-brand-50 py-12 border-t border-brand-100">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <h2 class="text-xl font-bold text-gray-900 mb-6">Shop by Category</h2>
            <div class="grid grid-cols-2 md:grid-cols-5 gap-4">
                <% String[] cats = {"💻 Laptops", "📱 Phones", "🎧 Audio", "⌨️ Accessories", "🖥️ Monitors"}; %>
                <% for (String cat : cats) { %>
                <a href="#" class="bg-white border border-gray-200 rounded-xl p-5 text-center hover:border-brand-400 hover:shadow-md transition-all group">
                    <p class="text-2xl mb-2"><%= cat.split(" ")[0] %></p>
                    <p class="text-sm font-medium text-gray-700 group-hover:text-brand-600"><%= cat.substring(cat.indexOf(" ")+1) %></p>
                </a>
                <% } %>
            </div>
        </div>
    </section>
</main>
<script>
    function filterProducts() {
        const category = document.getElementById('categorySelect').value;
        const sort = document.getElementById('sortSelect').value;

        let url = new URL(window.location.href);

        if (category) {
            url.searchParams.set('category', category);
        } else {
            url.searchParams.delete('category');
        }

        if (sort) {
            url.searchParams.set('sort', sort);
        } else {
            url.searchParams.delete('sort');
        }

        window.location.href = url.toString();
    }
</script>

<%@ include file="WEB-INF/includes/footer.jsp" %>