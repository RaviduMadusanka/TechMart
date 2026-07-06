<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="lk.techmart.core.dto.ProductDTO" %>
<%
    ProductDTO p = (ProductDTO) request.getAttribute("product");
    String title = (p != null && p.getProductName() != null) ? p.getProductName() + " - TechMart" : "Product Details - TechMart";
    request.setAttribute("pageTitle", title);
%>
<%
    ProductDTO pd = (ProductDTO) request.getAttribute("product");
    String primaryImageUrl = pd.getImageUrl();

    String imgFolder = "";
    String imgExt = "";
    if (primaryImageUrl != null) {
        int slashIdx = primaryImageUrl.lastIndexOf('/');
        int dotIdx = primaryImageUrl.lastIndexOf('.');
        if (slashIdx >= 0) imgFolder = primaryImageUrl.substring(0, slashIdx);
        if (dotIdx > slashIdx) imgExt = primaryImageUrl.substring(dotIdx);
    }

    String uploadBaseDir = System.getProperty("user.home") + java.io.File.separator + "TechMartImages";

    String image1 = null;
    String image2 = null;
    if (!imgFolder.isEmpty()) {
        java.io.File f1 = new java.io.File(uploadBaseDir + java.io.File.separator + imgFolder, "image1" + imgExt);
        java.io.File f2 = new java.io.File(uploadBaseDir + java.io.File.separator + imgFolder, "image2" + imgExt);
        if (f1.exists()) image1 = imgFolder + "/image1" + imgExt;
        if (f2.exists()) image2 = imgFolder + "/image2" + imgExt;
    }
%>
<%@ include file="WEB-INF/includes/header.jsp" %>

<main class="flex-1">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

        <nav class="flex items-center gap-2 text-sm text-gray-500 mb-8">
            <a href="index.jsp" class="hover:text-brand-600 transition-colors">Home</a>
            <span>/</span>
            <a href="#" class="hover:text-brand-600 transition-colors">${product.category.name}</a>
            <span>/</span>
            <span class="text-gray-800 font-medium">${product.productName}</span>
        </nav>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">

            <div class="space-y-4">
                <div class="bg-gray-50 rounded-2xl border border-gray-200 h-96 flex items-center justify-center relative overflow-hidden">

                    <img id="mainProductImage" src="<%= request.getContextPath() %>/image?file=<%= p.getImageUrl() %>" alt="${product.productName}" class="w-full h-full object-cover">
                    <span class="absolute top-4 left-4 bg-green-500 text-white text-xs font-bold px-2.5 py-1 rounded-full">NEW</span>
                </div>

                <div class="flex gap-3">
                    <div class="w-20 h-20 bg-gray-100 rounded-lg border-2 border-brand-500 cursor-pointer hover:border-brand-500 overflow-hidden"
                         onclick="document.getElementById('mainProductImage').src='<%= request.getContextPath() %>/image?file=<%= p.getImageUrl() %>'">
                        <img src="<%= request.getContextPath() %>/image?file=<%= p.getImageUrl() %>" class="w-full h-full object-cover">
                    </div>

                    <% if (image1 != null) { %>
                    <div class="w-20 h-20 bg-gray-100 rounded-lg border-2 border-gray-300 cursor-pointer hover:border-brand-500 overflow-hidden"
                         onclick="document.getElementById('mainProductImage').src='<%= request.getContextPath() %>/image?file=<%= image1 %>'">
                        <img src="<%= request.getContextPath() %>/image?file=<%= image1 %>" class="w-full h-full object-cover">
                    </div>
                    <% } %>

                    <% if (image2 != null) { %>
                    <div class="w-20 h-20 bg-gray-100 rounded-lg border-2 border-gray-300 cursor-pointer hover:border-brand-500 overflow-hidden"
                         onclick="document.getElementById('mainProductImage').src='<%= request.getContextPath() %>/image?file=<%= image2 %>'">
                        <img src="<%= request.getContextPath() %>/image?file=<%= image2 %>" class="w-full h-full object-cover">
                    </div>
                    <% } %>
                </div>
            </div>

            <div>
                <p class="text-brand-600 text-sm font-semibold uppercase tracking-wider mb-2">${product.brand.name} — ${product.category.name}</p>

                <h1 class="text-3xl font-bold text-gray-900 mb-3">${product.productName}</h1>

                <div class="flex items-center gap-3 mb-5">
                    <div class="flex text-yellow-400">★★★★★</div>
                    <span class="text-sm text-brand-600 font-medium hover:underline cursor-pointer">4.8 (52 reviews)</span>
                    <span class="text-gray-300">|</span>
                    <span class="text-sm text-green-600 font-semibold">✓ ${product.status}</span>
                </div>

                <div class="flex items-baseline gap-3 mb-6 pb-6 border-b border-gray-200">
                    <span class="text-4xl font-bold text-gray-900">Rs. ${product.price}</span>
                </div>

                <div class="grid grid-cols-2 gap-3 mb-6">
                    <div class="bg-gray-50 rounded-lg px-3 py-2.5">
                        <p class="text-xs text-gray-500 font-medium">Product Code</p>
                        <p class="text-sm font-semibold text-gray-800 mt-0.5">${product.productCode}</p>
                    </div>
                    <div class="bg-gray-50 rounded-lg px-3 py-2.5">
                        <p class="text-xs text-gray-500 font-medium">Brand</p>
                        <p class="text-sm font-semibold text-gray-800 mt-0.5">${product.brand.name}</p>
                    </div>
                    <div class="bg-gray-50 rounded-lg px-3 py-2.5">
                        <p class="text-xs text-gray-500 font-medium">Category</p>
                        <p class="text-sm font-semibold text-gray-800 mt-0.5">${product.category.name}</p>
                    </div>
                    <div class="bg-gray-50 rounded-lg px-3 py-2.5">
                        <p class="text-xs text-gray-500 font-medium">Weight</p>
                        <p class="text-sm font-semibold text-gray-800 mt-0.5">${product.weight} kg</p>
                    </div>
                </div>

                <div class="space-y-3">
                    <form action="${pageContext.request.contextPath}/cart-action" method="post" class="flex gap-3">
                        <input type="hidden" name="productId" value="${product.productId}"/>
                        <input type="hidden" name="action" value="add"/>
                        <input type="hidden" name="qty" value="1"/>

                        <button type="submit" class="flex-1 bg-brand-600 hover:bg-brand-700 text-white font-bold py-3 px-6 rounded-lg transition-colors active:scale-[0.98] flex items-center justify-center gap-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                            </svg>
                            Add to Cart
                        </button>
                    </form>

                    <a href="checkout.jsp" class="w-full block text-center bg-gray-900 hover:bg-gray-800 text-white font-bold py-3 px-6 rounded-lg transition-colors">
                        Buy Now
                    </a>
                </div>

                <div class="mt-6 pt-6 border-t border-gray-200 space-y-2 text-sm text-gray-600">
                    <div class="flex items-center gap-2"><span>🚚</span> <span>Island-wide Delivery Available</span></div>
                    <div class="flex items-center gap-2"><span>🛡️</span> <span>Authentic Products Guaranteed</span></div>
                </div>
            </div>
        </div>

        <div class="mt-14 border-t border-gray-200 pt-10">
            <div class="flex border-b border-gray-200 gap-8 mb-8">
                <button class="pb-3 text-sm font-semibold text-brand-600 border-b-2 border-brand-600">Description</button>
            </div>
            <div class="prose prose-sm max-w-none text-gray-600 leading-relaxed">

                <p>${product.description}</p>
            </div>
        </div>
    </div>
</main>

<%@ include file="WEB-INF/includes/footer.jsp" %>