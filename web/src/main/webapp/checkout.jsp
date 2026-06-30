<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "Checkout - TechMart");
%>
<%@ include file="WEB-INF/includes/header.jsp" %>

<main class="flex-1 bg-gray-50">
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-10">

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

        <form action="checkout" method="post">
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

                <div class="lg:col-span-2 space-y-6">

                    <div class="bg-white rounded-xl border border-gray-200 p-6">
                        <h2 class="text-base font-bold text-gray-900 mb-5 flex items-center gap-2">
                            <span class="w-6 h-6 bg-brand-600 text-white rounded-full flex items-center justify-center text-xs font-bold">1</span>
                            Shipping Address
                        </h2>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">First Name *</label>
                                <input type="text" name="firstName" placeholder="John" required
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
                                       class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-colors"/>
                            </div>
                            <div class="sm:col-span-2">
                                <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Phone Number *</label>
                                <input type="tel" name="phone" placeholder="+1 (555) 000-0000" required
                                       class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-colors"/>
                            </div>
                            <div class="sm:col-span-2">
                                <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Street Address *</label>
                                <input type="text" name="address" placeholder="123 Main Street, Apt 4B" required
                                       class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-colors"/>
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">City *</label>
                                <input type="text" name="city" placeholder="New York" required
                                       class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-colors"/>
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">ZIP Code *</label>
                                <input type="text" name="zip" placeholder="10001" required
                                       class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-colors"/>
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">State *</label>
                                <select name="state" class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 bg-white">
                                    <option value="">Select State</option>
                                    <option>New York</option>
                                    <option>California</option>
                                    <option>Texas</option>
                                    <option>Florida</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Country *</label>
                                <select name="country" class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 bg-white">
                                    <option>United States</option>
                                    <option>Canada</option>
                                    <option>United Kingdom</option>
                                </select>
                            </div>
                        </div>

                        <div class="mt-6">
                            <p class="text-xs font-semibold text-gray-600 mb-3 uppercase tracking-wide">Shipping Method</p>
                            <div class="space-y-2">
                                <%
                                    String[][] shippingOptions = {
                                            {"standard", "Standard Delivery (3-5 days)", "FREE"},
                                            {"express", "Express Delivery (1-2 days)", "$9.99"},
                                            {"overnight", "Overnight Delivery", "$19.99"},
                                    };
                                %>
                                <% for (int i = 0; i < shippingOptions.length; i++) { %>
                                <label class="flex items-center justify-between p-3 border border-gray-200 rounded-lg cursor-pointer hover:border-brand-400 hover:bg-brand-50 transition-colors">
                                    <div class="flex items-center gap-3">
                                        <input type="radio" name="shippingMethod" value="<%= shippingOptions[i][0] %>"
                                               class="accent-brand-600" <%= i==0 ? "checked" : "" %>/>
                                        <span class="text-sm text-gray-700"><%= shippingOptions[i][1] %></span>
                                    </div>
                                    <span class="text-sm font-semibold <%= shippingOptions[i][2].equals("FREE") ? "text-green-600" : "text-gray-700" %>">
                                        <%= shippingOptions[i][2] %>
                                    </span>
                                </label>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-xl border border-gray-200 p-6">
                        <h2 class="text-base font-bold text-gray-900 mb-5 flex items-center gap-2">
                            <span class="w-6 h-6 bg-brand-600 text-white rounded-full flex items-center justify-center text-xs font-bold">2</span>
                            Payment Information
                        </h2>

                        <div class="flex gap-3 mb-5">
                            <button type="button" class="flex-1 border-2 border-brand-600 bg-brand-50 text-brand-700 text-sm font-semibold py-2 px-3 rounded-lg">
                                💳 Credit/Debit Card
                            </button>
                            <button type="button" class="flex-1 border-2 border-gray-200 text-gray-600 text-sm font-medium py-2 px-3 rounded-lg hover:border-gray-300 transition-colors">
                                PayPal
                            </button>
                            <button type="button" class="flex-1 border-2 border-gray-200 text-gray-600 text-sm font-medium py-2 px-3 rounded-lg hover:border-gray-300 transition-colors">
                                🏦 Bank Transfer
                            </button>
                        </div>

                        <div class="space-y-4">
                            <div>
                                <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Card Number *</label>
                                <input type="text" name="cardNumber" placeholder="1234 5678 9012 3456" maxlength="19"
                                       class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 font-mono"/>
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Cardholder Name *</label>
                                <input type="text" name="cardName" placeholder="JOHN DOE"
                                       class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500"/>
                            </div>
                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Expiry Date *</label>
                                    <input type="text" name="expiry" placeholder="MM / YY" maxlength="7"
                                           class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 font-mono"/>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">CVV *</label>
                                    <input type="text" name="cvv" placeholder="123" maxlength="4"
                                           class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 font-mono"/>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 flex items-center gap-2 text-xs text-gray-500">
                            <svg class="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
                            </svg>
                            <span>Your payment information is secured with 256-bit SSL encryption</span>
                        </div>
                    </div>
                </div>

                <div class="lg:col-span-1">
                    <div class="bg-white rounded-xl border border-gray-200 p-6 sticky top-24">
                        <h2 class="text-base font-bold text-gray-900 mb-4">Order Summary</h2>

                        <div class="space-y-3 mb-5">
                            <%
                                String[][] checkoutItems = {
                                        {"MacBook Pro 14\"", "x1", "1,299.00"},
                                        {"Samsung Galaxy S25", "x2", "1,798.00"},
                                        {"Sony WH-1000XM6", "x1", "349.00"},
                                };
                            %>
                            <% for (String[] ci : checkoutItems) { %>
                            <div class="flex items-center justify-between text-sm">
                                <div class="flex items-center gap-2">
                                    <div class="w-8 h-8 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0">
                                        <span class="text-xs">📦</span>
                                    </div>
                                    <div>
                                        <p class="font-medium text-gray-800 text-xs leading-tight"><%= ci[0] %></p>
                                        <p class="text-gray-400 text-xs"><%= ci[1] %></p>
                                    </div>
                                </div>
                                <span class="font-semibold text-gray-900 text-xs">$<%= ci[2] %></span>
                            </div>
                            <% } %>
                        </div>

                        <div class="border-t border-gray-200 pt-4 space-y-2 text-sm">
                            <div class="flex justify-between text-gray-600"><span>Subtotal</span><span>$3,446.00</span></div>
                            <div class="flex justify-between text-gray-600"><span>Shipping</span><span class="text-green-600">FREE</span></div>
                            <div class="flex justify-between text-gray-600"><span>Tax (8%)</span><span>$275.68</span></div>
                            <div class="flex justify-between font-bold text-gray-900 text-base pt-2 border-t border-gray-200">
                                <span>Total</span><span class="text-brand-700">$3,721.68</span>
                            </div>
                        </div>

                        <button type="submit"
                                class="w-full mt-5 bg-brand-600 hover:bg-brand-700 text-white font-bold py-3.5 px-4 rounded-lg transition-colors text-sm active:scale-[0.98] flex items-center justify-center gap-2">
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

<%@ include file="WEB-INF/includes/footer.jsp" %>
