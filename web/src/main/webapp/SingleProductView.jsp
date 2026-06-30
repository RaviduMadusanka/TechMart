<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // In production: ProductServiceBean would fetch product by ID (Stateless EJB)
    // @EJB private ProductServiceBean productService;
    // Product product = productService.getProductById(Long.parseLong(request.getParameter("id")));
    String productId = request.getParameter("id") != null ? request.getParameter("id") : "1";
    request.setAttribute("pageTitle", "MacBook Pro 14\" - TechMart");
%>
<%@ include file="WEB-INF/includes/header.jsp" %>

<main class="flex-1">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

        <!-- Breadcrumb -->
        <nav class="flex items-center gap-2 text-sm text-gray-500 mb-8">
            <a href="index.jsp" class="hover:text-brand-600 transition-colors">Home</a>
            <span>/</span>
            <a href="#" class="hover:text-brand-600 transition-colors">Laptops</a>
            <span>/</span>
            <span class="text-gray-800 font-medium">MacBook Pro 14"</span>
        </nav>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">

            <!-- Product Images -->
            <div class="space-y-4">
                <!-- Main Image -->
                <div class="bg-gray-50 rounded-2xl border border-gray-200 h-96 flex items-center justify-center relative">
                    <div class="w-48 h-48 bg-gradient-to-br from-brand-100 to-brand-200 rounded-2xl flex items-center justify-center shadow-lg">
                        <svg class="w-24 h-24 text-brand-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17H3a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v10a2 2 0 01-2 2h-2"/>
                        </svg>
                    </div>
                    <span class="absolute top-4 left-4 bg-green-500 text-white text-xs font-bold px-2.5 py-1 rounded-full">NEW</span>
                </div>
                <!-- Thumbnail Strip -->
                <div class="flex gap-3">
                    <% for (int t = 0; t < 4; t++) { %>
                    <div class="w-20 h-20 bg-gray-100 rounded-lg border-2 <%= t==0 ? "border-brand-500" : "border-transparent hover:border-gray-300" %> cursor-pointer flex items-center justify-center transition-colors">
                        <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17H3a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v10a2 2 0 01-2 2h-2"/>
                        </svg>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Product Info -->
            <div>
                <p class="text-brand-600 text-sm font-semibold uppercase tracking-wider mb-2">Apple — Laptops</p>
                <h1 class="text-3xl font-bold text-gray-900 mb-3">MacBook Pro 14" M3 Pro</h1>

                <!-- Rating Row -->
                <div class="flex items-center gap-3 mb-5">
                    <div class="flex text-yellow-400">★★★★★</div>
                    <span class="text-sm text-brand-600 font-medium hover:underline cursor-pointer">4.8 (52 reviews)</span>
                    <span class="text-gray-300">|</span>
                    <span class="text-sm text-green-600 font-semibold">✓ In Stock</span>
                </div>

                <!-- Price -->
                <div class="flex items-baseline gap-3 mb-6 pb-6 border-b border-gray-200">
                    <span class="text-4xl font-bold text-gray-900">$1,299.00</span>
                    <span class="text-lg text-gray-400 line-through">$1,499.00</span>
                    <span class="bg-red-100 text-red-600 text-sm font-bold px-2 py-0.5 rounded">Save 13%</span>
                </div>

                <!-- Key Specs -->
                <div class="grid grid-cols-2 gap-3 mb-6">
                    <% String[][] specs = {
                            {"Chip", "Apple M3 Pro"},
                            {"RAM", "18GB Unified"},
                            {"Storage", "512GB SSD"},
                            {"Display", "14.2\" Liquid Retina XDR"}
                    }; %>
                    <% for (String[] spec : specs) { %>
                    <div class="bg-gray-50 rounded-lg px-3 py-2.5">
                        <p class="text-xs text-gray-500 font-medium"><%= spec[0] %></p>
                        <p class="text-sm font-semibold text-gray-800 mt-0.5"><%= spec[1] %></p>
                    </div>
                    <% } %>
                </div>

                <!-- Color Selection -->
                <div class="mb-6">
                    <p class="text-sm font-semibold text-gray-700 mb-2">Color: <span class="text-gray-900">Space Gray</span></p>
                    <div class="flex gap-3">
                        <% String[] colors = {"#6B7280", "#D1D5DB", "#92400E"}; %>
                        <% String[] colorNames = {"Space Gray", "Silver", "Space Black"}; %>
                        <% for (int c = 0; c < colors.length; c++) { %>
                        <button class="w-8 h-8 rounded-full border-2 <%= c==0 ? "border-brand-500 ring-2 ring-brand-200" : "border-gray-300" %> transition-all"
                                style="background-color: <%= colors[c] %>;"
                                title="<%= colorNames[c] %>">
                        </button>
                        <% } %>
                    </div>
                </div>

                <!-- Quantity + Actions -->
                <div class="space-y-3">
                    <div class="flex items-center gap-3">
                        <div class="flex items-center border border-gray-300 rounded-lg overflow-hidden">
                            <button class="w-10 h-10 bg-gray-50 hover:bg-gray-100 text-gray-700 font-bold text-lg transition-colors">−</button>
                            <span class="w-12 text-center text-sm font-semibold">1</span>
                            <button class="w-10 h-10 bg-gray-50 hover:bg-gray-100 text-gray-700 font-bold text-lg transition-colors">+</button>
                        </div>
                        <span class="text-sm text-gray-500">Only 8 left in stock!</span>
                    </div>

                    <form action="CartServlet" method="post" class="flex gap-3">
                        <input type="hidden" name="productId" value="<%= productId %>"/>
                        <input type="hidden" name="action" value="add"/>
                        <button type="submit" class="flex-1 bg-brand-600 hover:bg-brand-700 text-white font-bold py-3 px-6 rounded-lg transition-colors active:scale-[0.98] flex items-center justify-center gap-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                            </svg>
                            Add to Cart
                        </button>
                        <button type="button" class="border-2 border-gray-300 hover:border-brand-500 text-gray-600 hover:text-brand-600 font-bold py-3 px-4 rounded-lg transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
                            </svg>
                        </button>
                    </form>

                    <a href="checkout.jsp" class="w-full block text-center bg-gray-900 hover:bg-gray-800 text-white font-bold py-3 px-6 rounded-lg transition-colors">
                        Buy Now
                    </a>
                </div>

                <!-- Delivery Info -->
                <div class="mt-6 pt-6 border-t border-gray-200 space-y-2 text-sm text-gray-600">
                    <div class="flex items-center gap-2"><span>🚚</span> <span>Free delivery by <strong class="text-gray-800">Tomorrow</strong></span></div>
                    <div class="flex items-center gap-2"><span>↩️</span> <span>Free 30-day returns</span></div>
                    <div class="flex items-center gap-2"><span>🛡️</span> <span>2-year manufacturer warranty</span></div>
                </div>
            </div>
        </div>

        <!-- Description & Reviews Tabs -->
        <div class="mt-14 border-t border-gray-200 pt-10">
            <div class="flex border-b border-gray-200 gap-8 mb-8">
                <button class="pb-3 text-sm font-semibold text-brand-600 border-b-2 border-brand-600">Description</button>
                <button class="pb-3 text-sm font-medium text-gray-500 hover:text-gray-700">Specifications</button>
                <button class="pb-3 text-sm font-medium text-gray-500 hover:text-gray-700">Reviews (52)</button>
            </div>
            <div class="prose prose-sm max-w-none text-gray-600 leading-relaxed">
                <p>The MacBook Pro 14" with M3 Pro chip delivers extraordinary performance with exceptional battery life. Engineered for professionals who demand the best, this powerhouse laptop features a stunning Liquid Retina XDR display, advanced unified memory architecture, and an all-day battery that lasts up to 18 hours.</p>
                <p class="mt-4">Whether you're editing 4K video, compiling code, or running complex simulations, the M3 Pro chip handles it all with remarkable efficiency. The pro-quality camera, microphones, and speakers make it the perfect tool for both creating and communicating.</p>
            </div>
        </div>
    </div>
</main>

<%@ include file="WEB-INF/includes/footer.jsp" %>
