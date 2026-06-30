<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, lk.techmart.core.dto.ProductDTO"%>
<%@ page import="lk.techmart.ejb.ShoppingCartBean, javax.naming.InitialContext"%>
<%
    request.setAttribute("pageTitle", "Checkout - TechMart");

    // Session එකෙන් Cart එක ගන්නවා
    ShoppingCartBean cartBean = (ShoppingCartBean) session.getAttribute("shoppingCart");
    Map<Long, Integer> cartItemsMap = new HashMap<>();

    if (cartBean != null) {
        cartItemsMap = cartBean.getCartItems();
    }

    lk.techmart.core.service.ProductService productService = null;
    List<ProductDTO> cartProducts = new ArrayList<>();
    double subtotal = 0.0;

    // Database එකෙන් Cart එකේ තියෙන Products වල විස්තර ගන්නවා
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
        System.out.println("Error loading checkout products: " + e.getMessage());
    }

    double tax = subtotal * 0.08;
    double total = subtotal + tax;
%>
<%@ include file="WEB-INF/includes/header.jsp" %>

<main class="flex-1 bg-gray-50">
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-10">

        <!-- Progress Steps -->
        <div class="flex items-center justify-center gap-2 mb-10">
            <% String[] steps = {"Cart", "Shipping", "Payment", "Review"}; %>
            <% int activeStep = 1; %>
            <% for (int i = 0; i < steps.length; i++) { %>
            <div class="flex items-center">
                <div class="flex items-center gap-2">
                    <div class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold
                        <%= i < activeStep ? "bg-brand-600 text-white" : i == activeStep ? "bg-brand-600 text-white ring-4 ring-brand-100" : "bg-gray-200 text-gray-500" %>">
                        <%= i < activeStep ? "✓" : (i + 1) %>
                    </div>
                    <span class="text-sm font-medium hidden sm:block <%= i == activeStep ? "text-brand-700" : i < activeStep ? "text-gray-600" : "text-gray-400" %>">
                        <%= steps[i] %>
                    </span>
                </div>
                <% if (i < steps.length - 1) { %>
                <div class="w-10 sm:w-16 h-0.5 mx-2 <%= i < activeStep ? "bg-brand-600" : "bg-gray-200" %>"></div>
                <% } %>
            </div>
            <% } %>
        </div>

        <form action="checkout" method="post" id="checkoutForm">
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

                <!-- Left: Shipping Address Form -->
                <div class="lg:col-span-2 space-y-6">

                    <!-- Shipping Address -->
                    <div class="bg-white rounded-xl border border-gray-200 p-6">
                        <h2 class="text-base font-bold text-gray-900 mb-5 flex items-center gap-2">
                            <span class="w-6 h-6 bg-brand-600 text-white rounded-full flex items-center justify-center text-xs font-bold">1</span>
                            Shipping Address
                        </h2>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">First Name *</label>
                                <input type="text" name="firstName" placeholder="John" required
                                       value="<%= session.getAttribute("loggedUserName") != null ? session.getAttribute("loggedUserName") : "" %>"
                                       class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-colors"/>
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Last Name *</label>
                                <input type="text" name="lastName" placeholder="Doe" required
                                       class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-colors"/>
                            </div>
                            <div class="sm:col-span-2">
                                <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Email Address *</label>
                                <input type="email" name="email" placeholder="john.doe@email.com" required
                                       value="<%= session.getAttribute("loggedUserEmail") != null ? session.getAttribute("loggedUserEmail") : "" %>"
                                       class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-colors"/>
                            </div>
                            <div class="sm:col-span-2">
                                <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Phone Number *</label>
                                <input type="tel" name="phone" placeholder="+94 77 000 0000" required
                                       class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-colors"/>
                            </div>
                            <div class="sm:col-span-2">
                                <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Street Address *</label>
                                <input type="text" name="address" placeholder="123 Main Street, Apt 4B" required
                                       class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-colors"/>
                            </div>
                        </div>

                        <!-- Hidden fields -->
                        <input type="hidden" name="city" value="N/A">
                        <input type="hidden" name="country" value="Sri Lanka">
                    </div>

                    <!-- Secure Payment Info Box -->
                    <div class="bg-brand-50 rounded-xl border border-brand-100 p-6 flex items-start gap-4">
                        <div class="w-10 h-10 bg-brand-100 text-brand-600 rounded-full flex items-center justify-center flex-shrink-0">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                            </svg>
                        </div>
                        <div>
                            <h3 class="text-sm font-bold text-gray-900 mb-1">Secure Payment via PayHere</h3>
                            <p class="text-xs text-gray-600">You will be securely redirected to PayHere to complete your payment using Credit/Debit card, Mobile Wallet, or Internet Banking.</p>
                        </div>
                    </div>
                </div>

                <!-- Right: Order Summary (DYNAMIC) -->
                <div class="lg:col-span-1">
                    <div class="bg-white rounded-xl border border-gray-200 p-6 sticky top-24">
                        <h2 class="text-base font-bold text-gray-900 mb-4">Order Summary</h2>

                        <!-- Dynamic Cart Items -->
                        <div class="space-y-3 mb-5">
                            <%
                                if(cartProducts.isEmpty()) {
                            %>
                            <p class="text-sm text-red-500">Your cart is empty.</p>
                            <%
                            } else {
                                for (ProductDTO p : cartProducts) {
                                    int qty = cartItemsMap.get(p.getProductId());
                                    double lineTotal = p.getPrice().doubleValue() * qty;
                            %>
                            <div class="flex items-center justify-between text-sm">
                                <div class="flex items-center gap-2">
                                    <div class="w-8 h-8 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0">
                                        <% if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) { %>
                                        <img src="<%= request.getContextPath() + "/image?file=" + p.getImageUrl() %>" class="w-full h-full object-cover rounded-lg">
                                        <% } else { %>
                                        <span class="text-xs">📦</span>
                                        <% } %>
                                    </div>
                                    <div class="max-w-[120px]">
                                        <p class="font-medium text-gray-800 text-xs leading-tight truncate" title="<%= p.getProductName() %>"><%= p.getProductName() %></p>
                                        <p class="text-gray-400 text-xs">x<%= qty %></p>
                                    </div>
                                </div>
                                <span class="font-semibold text-gray-900 text-xs">Rs.<%= String.format("%.2f", lineTotal) %></span>
                            </div>
                            <%
                                    }
                                }
                            %>
                        </div>

                        <div class="border-t border-gray-200 pt-4 space-y-2 text-sm">
                            <div class="flex justify-between text-gray-600"><span>Subtotal</span><span>Rs.<%= String.format("%.2f", subtotal) %></span></div>
                            <div class="flex justify-between text-gray-600"><span>Shipping</span><span class="text-green-600">FREE</span></div>
                            <div class="flex justify-between text-gray-600"><span>Tax (8%)</span><span>Rs.<%= String.format("%.2f", tax) %></span></div>
                            <div class="flex justify-between font-bold text-gray-900 text-base pt-2 border-t border-gray-200">
                                <span>Total</span><span class="text-brand-700">Rs.<%= String.format("%.2f", total) %></span>
                            </div>
                        </div>

                        <button type="submit" <%= cartProducts.isEmpty() ? "disabled" : "" %>
                                class="w-full mt-5 <%= cartProducts.isEmpty() ? "bg-gray-400 cursor-not-allowed" : "bg-brand-600 hover:bg-brand-700" %> text-white font-bold py-3.5 px-4 rounded-lg transition-colors text-sm active:scale-[0.98] flex items-center justify-center gap-2">
                            🔒 Place Order
                        </button>

                        <p class="text-xs text-gray-400 text-center mt-3">
                            By placing your order, you agree to our
                            <a href="#" class="text-brand-600 hover:underline">Terms of Service</a>
                        </p>
                    </div>
                </div>
            </div>
        </form>
    </div>
</main>
<script type="text/javascript" src="https://www.payhere.lk/lib/payhere.js"></script>
<script src="${pageContext.request.contextPath}/js/checkout.js"></script>

<%@ include file="WEB-INF/includes/footer.jsp" %>