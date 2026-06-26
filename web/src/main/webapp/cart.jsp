<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList"%>
<%
    // In production: CartBean (Stateful EJB) maintains cart per session
    // @EJB private CartBean cartBean;
    // List<CartItem> cartItems = cartBean.getCartItems(sessionId);
    request.setAttribute("pageTitle", "Shopping Cart - TechMart");
%>
<%@ include file="WEB-INF/includes/header.jsp" %>

<main class="flex-1 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">

        <h1 class="text-2xl font-bold text-gray-900 mb-8">Your Shopping Cart <span class="text-gray-400 text-lg font-normal">(3 items)</span></h1>

        <%
            // Sample cart items - in production from CartBean (Stateful EJB)
            String[][] cartItems = {
                    {"1", "MacBook Pro 14\" M3 Pro", "Laptops", "1,299.00", "1", "1,299.00"},
                    {"2", "Samsung Galaxy S25", "Smartphones", "899.00", "2", "1,798.00"},
                    {"3", "Sony WH-1000XM6", "Audio", "349.00", "1", "349.00"},
            };
            double subtotal = 3446.00;
            double shipping = 0.00;
            double tax = subtotal * 0.08;
            double total = subtotal + tax;
        %>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

            <!-- Cart Items -->
            <div class="lg:col-span-2 space-y-4">
                <!-- Select All Header -->
                <div class="bg-white rounded-xl border border-gray-200 px-5 py-3 flex items-center justify-between">
                    <label class="flex items-center gap-3 text-sm font-medium text-gray-700 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 accent-brand-600" checked/>
                        Select All Items
                    </label>
                    <button class="text-sm text-red-500 hover:text-red-700 font-medium transition-colors">Remove Selected</button>
                </div>

                <% for (String[] item : cartItems) { %>
                <div class="bg-white rounded-xl border border-gray-200 p-5 flex items-start gap-4 hover:border-gray-300 transition-colors">
                    <input type="checkbox" class="mt-1 w-4 h-4 accent-brand-600" checked/>

                    <!-- Product Image -->
                    <div class="w-20 h-20 bg-brand-50 rounded-xl flex-shrink-0 flex items-center justify-center">
                        <svg class="w-10 h-10 text-brand-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17H3a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v10a2 2 0 01-2 2h-2"/>
                        </svg>
                    </div>

                    <!-- Product Details -->
                    <div class="flex-1 min-w-0">
                        <p class="text-xs text-brand-600 font-medium uppercase tracking-wide mb-0.5"><%= item[2] %></p>
                        <h3 class="text-sm font-semibold text-gray-900 mb-1 truncate"><%= item[1] %></h3>
                        <p class="text-xs text-gray-500 mb-3">✓ In Stock &nbsp;•&nbsp; Ships in 1-2 days</p>

                        <div class="flex items-center justify-between">
                            <!-- Quantity Control -->
                            <div class="flex items-center border border-gray-300 rounded-lg overflow-hidden">
                                <form action="CartServlet" method="post" class="inline">
                                    <input type="hidden" name="productId" value="<%= item[0] %>"/>
                                    <input type="hidden" name="action" value="decrease"/>
                                    <button type="submit" class="w-8 h-8 bg-gray-50 hover:bg-gray-100 text-gray-600 font-bold transition-colors">−</button>
                                </form>
                                <span class="w-8 text-center text-sm font-semibold"><%= item[4] %></span>
                                <form action="CartServlet" method="post" class="inline">
                                    <input type="hidden" name="productId" value="<%= item[0] %>"/>
                                    <input type="hidden" name="action" value="increase"/>
                                    <button type="submit" class="w-8 h-8 bg-gray-50 hover:bg-gray-100 text-gray-600 font-bold transition-colors">+</button>
                                </form>
                            </div>

                            <div class="flex items-center gap-4">
                                <span class="text-base font-bold text-gray-900">$<%= item[5] %></span>
                                <form action="CartServlet" method="post">
                                    <input type="hidden" name="productId" value="<%= item[0] %>"/>
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

                <!-- Continue Shopping -->
                <a href="index.jsp" class="inline-flex items-center gap-2 text-sm text-brand-600 hover:text-brand-800 font-medium transition-colors">
                    ← Continue Shopping
                </a>
            </div>

            <!-- Order Summary -->
            <div class="lg:col-span-1">
                <div class="bg-white rounded-xl border border-gray-200 p-6 sticky top-24 space-y-4">
                    <h2 class="text-lg font-bold text-gray-900">Order Summary</h2>

                    <div class="space-y-3 text-sm">
                        <div class="flex justify-between text-gray-600">
                            <span>Subtotal (3 items)</span>
                            <span class="font-medium text-gray-900">$<%= String.format("%.2f", subtotal) %></span>
                        </div>
                        <div class="flex justify-between text-gray-600">
                            <span>Shipping</span>
                            <span class="font-medium text-green-600">FREE</span>
                        </div>
                        <div class="flex justify-between text-gray-600">
                            <span>Tax (8%)</span>
                            <span class="font-medium text-gray-900">$<%= String.format("%.2f", tax) %></span>
                        </div>
                    </div>

                    <!-- Coupon Code -->
                    <div class="flex gap-2 pt-2">
                        <input type="text" placeholder="Coupon code"
                               class="flex-1 border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500"/>
                        <button class="bg-gray-100 hover:bg-gray-200 text-gray-700 font-medium px-3 py-2 rounded-lg text-sm transition-colors">Apply</button>
                    </div>

                    <div class="border-t border-gray-200 pt-4 flex justify-between items-center">
                        <span class="font-bold text-gray-900 text-base">Total</span>
                        <span class="font-bold text-xl text-brand-700">$<%= String.format("%.2f", total) %></span>
                    </div>

                    <a href="checkout.jsp"
                       class="w-full block text-center bg-brand-600 hover:bg-brand-700 text-white font-bold py-3 px-4 rounded-lg transition-colors text-sm active:scale-[0.98]">
                        Proceed to Checkout →
                    </a>

                    <!-- Security badges -->
                    <div class="flex items-center justify-center gap-4 text-xs text-gray-400 pt-2">
                        <span>🔒 Secure Checkout</span>
                        <span>💳 SSL Encrypted</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="WEB-INF/includes/footer.jsp" %>
