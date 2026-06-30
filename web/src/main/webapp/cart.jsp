<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, lk.techmart.core.dto.ProductDTO"%>
<%@ page import="lk.techmart.ejb.ShoppingCartBean, javax.naming.InitialContext"%>

<%
    request.setAttribute("pageTitle", "Shopping Cart - TechMart");

    ShoppingCartBean cartBean = (ShoppingCartBean) session.getAttribute("shoppingCart");
    Map<Long, Integer> cartItemsMap = new HashMap<>();

    if (cartBean != null) {
        cartItemsMap = cartBean.getCartItems();
    }

    lk.techmart.core.service.ProductService productService = null;
    List<ProductDTO> cartProducts = new ArrayList<>();
    double subtotal = 0.0;

    try {
        InitialContext ic = new InitialContext();
        try {
            productService = (lk.techmart.core.service.ProductService) ic.lookup("java:app/ejb/ProductServiceBean");
        } catch (Exception e1) {
            try {
                productService = (lk.techmart.core.service.ProductService) ic.lookup("java:app/ejb-1.0-SNAPSHOT/ProductServiceBean");
            } catch (Exception e2) {
                productService = (lk.techmart.core.service.ProductService) ic.lookup("java:module/ProductServiceBean");
            }
        }

        for (Long productId : cartItemsMap.keySet()) {
            ProductDTO product = productService.getProductById(productId);
            if (product != null) {
                cartProducts.add(product);
                int qty = cartItemsMap.get(productId);

                subtotal += (product.getPrice().doubleValue() * qty);
            }
        }
    } catch (Exception e) {
        System.out.println("Error loading cart products: " + e.getMessage());
    }

    double tax = subtotal * 0.08;
    double total = subtotal + tax;
    int totalItems = cartItemsMap.values().stream().mapToInt(Integer::intValue).sum();
%>
<%@ include file="WEB-INF/includes/header.jsp" %>

<main class="flex-1 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">

        <h1 class="text-2xl font-bold text-gray-900 mb-8">Your Shopping Cart <span class="text-gray-400 text-lg font-normal">(<%= totalItems %> items)</span></h1>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

            <div class="lg:col-span-2 space-y-4">

                <% if (cartProducts.isEmpty()) { %>
                <div class="bg-white rounded-xl border border-gray-200 p-10 text-center">
                    <div class="text-5xl mb-4">🛒</div>
                    <h2 class="text-xl font-bold text-gray-800 mb-2">Your cart is empty!</h2>
                    <p class="text-gray-500 mb-6">Looks like you haven't added anything to your cart yet.</p>
                    <a href="home" class="bg-brand-600 text-white font-semibold py-2.5 px-6 rounded-lg hover:bg-brand-700 transition-colors">Start Shopping</a>
                </div>
                <% } else { %>
                <div class="bg-white rounded-xl border border-gray-200 px-5 py-3 flex items-center justify-between">
                    <label class="flex items-center gap-3 text-sm font-medium text-gray-700 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 accent-brand-600" checked/>
                        Select All Items
                    </label>
                    <form action="cart-action" method="POST" class="m-0">
                        <input type="hidden" name="action" value="clear">
                        <button type="submit" class="text-sm text-red-500 hover:text-red-700 font-medium transition-colors">Remove All</button>
                    </form>
                </div>

                <%
                    for (ProductDTO p : cartProducts) {
                        int qty = cartItemsMap.get(p.getProductId());

                        double lineTotal = p.getPrice().doubleValue() * qty;
                %>
                <div class="bg-white rounded-xl border border-gray-200 p-5 flex items-start gap-4 hover:border-gray-300 transition-colors">
                    <input type="checkbox" class="mt-1 w-4 h-4 accent-brand-600" checked/>

                    <div class="w-20 h-20 bg-brand-50 rounded-xl flex-shrink-0 flex items-center justify-center overflow-hidden border border-gray-100">
                        <% if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) { %>
                        <img src="<%= request.getContextPath() + "/image?file=" + p.getImageUrl() %>" class="w-full h-full object-cover">
                        <% } else { %>
                        <svg class="w-10 h-10 text-brand-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17H3a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v10a2 2 0 01-2 2h-2"/>
                        </svg>
                        <% } %>
                    </div>

                    <div class="flex-1 min-w-0">
                        <p class="text-xs text-brand-600 font-medium uppercase tracking-wide mb-0.5"><%= p.getCategory() != null ? p.getCategory().getName() : "General" %></p>
                        <h3 class="text-sm font-semibold text-gray-900 mb-1 truncate"><%= p.getProductName() %></h3>
                        <p class="text-xs text-gray-500 mb-3">✓ In Stock &nbsp;•&nbsp; Ships in 1-2 days</p>

                        <div class="flex items-center justify-between">
                            <div class="flex items-center border border-gray-300 rounded-lg overflow-hidden">
                                <form action="cart-action" method="post" class="inline">
                                    <input type="hidden" name="productId" value="<%= p.getProductId() %>"/>
                                    <input type="hidden" name="action" value="update"/>
                                    <input type="hidden" name="qty" value="<%= qty - 1 %>"/>
                                    <button type="submit" class="w-8 h-8 bg-gray-50 hover:bg-gray-100 text-gray-600 font-bold transition-colors">−</button>
                                </form>
                                <span class="w-8 text-center text-sm font-semibold"><%= qty %></span>
                                <form action="cart-action" method="post" class="inline">
                                    <input type="hidden" name="productId" value="<%= p.getProductId() %>"/>
                                    <input type="hidden" name="action" value="update"/>
                                    <input type="hidden" name="qty" value="<%= qty + 1 %>"/>
                                    <button type="submit" class="w-8 h-8 bg-gray-50 hover:bg-gray-100 text-gray-600 font-bold transition-colors">+</button>
                                </form>
                            </div>

                            <div class="flex items-center gap-4">
                                <div class="text-right">
                                    <div class="text-xs text-gray-400">Rs.<%= String.format("%.2f", p.getPrice().doubleValue()) %> each</div>
                                    <div class="text-base font-bold text-gray-900">Rs.<%= String.format("%.2f", lineTotal) %></div>
                                </div>
                                <form action="cart-action" method="post">
                                    <input type="hidden" name="productId" value="<%= p.getProductId() %>"/>
                                    <input type="hidden" name="action" value="remove"/>
                                    <button type="submit" class="text-gray-400 hover:text-red-500 transition-colors" title="Remove">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                        </svg>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>

                <a href="home" class="inline-flex items-center gap-2 text-sm text-brand-600 hover:text-brand-800 font-medium transition-colors">
                    ← Continue Shopping
                </a>
                <% } %>
            </div>

            <% if (!cartProducts.isEmpty()) { %>
            <div class="lg:col-span-1">
                <div class="bg-white rounded-xl border border-gray-200 p-6 sticky top-24 space-y-4">
                    <h2 class="text-lg font-bold text-gray-900">Order Summary</h2>

                    <div class="space-y-3 text-sm">
                        <div class="flex justify-between text-gray-600">
                            <span>Subtotal (<%= totalItems %> items)</span>
                            <span class="font-medium text-gray-900">Rs.<%= String.format("%.2f", subtotal) %></span>
                        </div>
                        <div class="flex justify-between text-gray-600">
                            <span>Shipping</span>
                            <span class="font-medium text-green-600">FREE</span>
                        </div>
                        <div class="flex justify-between text-gray-600">
                            <span>Tax (8%)</span>
                            <span class="font-medium text-gray-900">Rs.<%= String.format("%.2f", tax) %></span>
                        </div>
                    </div>

                    <div class="border-t border-gray-200 pt-4 flex justify-between items-center">
                        <span class="font-bold text-gray-900 text-base">Total</span>
                        <span class="font-bold text-xl text-brand-700">Rs.<%= String.format("%.2f", total) %></span>
                    </div>

                    <% if (session.getAttribute("loggedUserId") != null) { %>
                    <a href="checkout.jsp" class="w-full block text-center bg-brand-600 hover:bg-brand-700 text-white font-bold py-3 px-4 rounded-lg transition-colors text-sm active:scale-[0.98] flex items-center justify-center gap-2">
                        Proceed to Checkout →
                    </a>
                    <% } else { %>
                    <a href="auth?action=login" class="w-full block text-center bg-gray-800 hover:bg-gray-900 text-white font-bold py-3 px-4 rounded-lg transition-colors text-sm">
                        Login to Checkout
                    </a>
                    <p class="text-xs text-center text-red-500 mt-1">You must be logged in to place an order.</p>
                    <% } %>

                    <div class="flex items-center justify-center gap-4 text-xs text-gray-400 pt-2">
                        <span>🔒 Secure Checkout</span>
                        <span>💳 SSL Encrypted</span>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</main>

<%@ include file="WEB-INF/includes/footer.jsp" %>