<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, lk.techmart.core.dto.OrderDTO, lk.techmart.core.dto.OrderItemDTO"%>
<%
    request.setAttribute("pageTitle", "Order History - TechMart");

    List<OrderDTO> ordersList = (List<OrderDTO>) request.getAttribute("ordersList");

    if (ordersList == null) {
        response.sendRedirect(request.getContextPath() + "/profile");
        return;
    }
%>
<%@ include file="WEB-INF/includes/header.jsp" %>

<main class="flex-1 bg-gray-50">

    <section class="bg-gradient-to-r from-brand-800 via-brand-700 to-brand-600 text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
            <span class="inline-block bg-white/20 text-white text-xs font-semibold px-3 py-1 rounded-full mb-3 uppercase tracking-wider">My Account</span>
            <h1 class="text-2xl md:text-3xl font-bold leading-tight">Order History</h1>
            <p class="text-blue-100 text-sm mt-1">Track and review all your past purchases</p>
        </div>
    </section>

    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">

            <!-- Sidebar -->
            <aside class="lg:col-span-1">
                <div class="bg-white rounded-xl border border-gray-200 shadow-sm p-4 sticky top-4">
                    <nav class="flex flex-col gap-1">
                        <a href="profile" class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-gray-600 hover:bg-gray-50 hover:text-brand-600 font-medium text-sm transition-colors">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                            </svg>
                            My Profile
                        </a>
                        <a href="order-history" class="flex items-center gap-3 px-3 py-2.5 rounded-lg bg-brand-50 text-brand-700 font-semibold text-sm">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17V7m0 10a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h2a2 2 0 012 2m0 10a2 2 0 002 2h2a2 2 0 002-2M9 7a2 2 0 012-2h2a2 2 0 012 2m0 10V7m0 10a2 2 0 002 2h2a2 2 0 002-2V7a2 2 0 00-2-2h-2a2 2 0 00-2 2"/>
                            </svg>
                            Order History
                        </a>
                        <a href="cart" class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-gray-600 hover:bg-gray-50 hover:text-brand-600 font-medium text-sm transition-colors">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                            </svg>
                            My Cart
                        </a>
                        <a href="logout" class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-red-500 hover:bg-red-50 font-medium text-sm transition-colors mt-2 border-t border-gray-100 pt-3">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                            </svg>
                            Logout
                        </a>
                    </nav>
                </div>
            </aside>

            <!-- Orders list -->
            <div class="lg:col-span-3">
                <%
                    if (ordersList.isEmpty()) {
                %>
                <div class="bg-white rounded-xl border border-gray-200 shadow-sm py-16 text-center">
                    <svg class="w-14 h-14 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 17V7m0 10a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h2a2 2 0 012 2m0 10a2 2 0 002 2h2a2 2 0 002-2M9 7a2 2 0 012-2h2a2 2 0 012 2m0 10V7m0 10a2 2 0 002 2h2a2 2 0 002-2V7a2 2 0 00-2-2h-2a2 2 0 00-2 2"/>
                    </svg>
                    <p class="text-gray-500 font-medium mb-4">You haven't placed any orders yet.</p>
                    <a href="home" class="inline-block bg-brand-600 hover:bg-brand-700 text-white text-sm font-semibold px-6 py-2.5 rounded-lg transition-colors">
                        Start Shopping
                    </a>
                </div>
                <%
                } else {
                    for (OrderDTO o : ordersList) {
                        String amt = String.format("%.2f", o.getTotalAmount());
                        String statusName = o.getStatus() != null ? o.getStatus().getName() : "Processing";

                        String badgeClasses;
                        String statusLower = statusName.toLowerCase();
                        if (statusLower.contains("deliver") || statusLower.contains("complete")) {
                            badgeClasses = "bg-emerald-50 text-emerald-700";
                        } else if (statusLower.contains("cancel") || statusLower.contains("fail")) {
                            badgeClasses = "bg-red-50 text-red-700";
                        } else if (statusLower.contains("ship") || statusLower.contains("transit")) {
                            badgeClasses = "bg-blue-50 text-blue-700";
                        } else {
                            badgeClasses = "bg-amber-50 text-amber-700";
                        }

                        List<OrderItemDTO> items = o.getOrderItems();
                        String detailsId = "orderDetails" + o.getOrderId();
                %>
                <div class="bg-white rounded-xl border border-gray-200 shadow-sm mb-5 overflow-hidden">
                    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 px-6 py-4 border-b border-gray-100 bg-gray-50/60">
                        <div class="flex flex-wrap items-center gap-x-6 gap-y-1">
                            <div>
                                <p class="text-xs text-gray-500 uppercase tracking-wide font-semibold">Order Placed</p>
                                <p class="text-sm font-semibold text-gray-800"><%= o.getOrderDate() %></p>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500 uppercase tracking-wide font-semibold">Total</p>
                                <p class="text-sm font-semibold text-gray-800">Rs.<%= amt %></p>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500 uppercase tracking-wide font-semibold">Order #</p>
                                <p class="text-sm font-semibold text-gray-800"><%= o.getOrderId() %></p>
                            </div>
                        </div>
                        <span class="inline-block <%= badgeClasses %> text-xs font-semibold px-3 py-1.5 rounded-full self-start sm:self-center">
                            <%= statusName %>
                        </span>
                    </div>

                    <div class="px-6 py-4">
                        <%
                            if (items != null && !items.isEmpty()) {
                                int previewCount = Math.min(items.size(), 2);
                                for (int i = 0; i < previewCount; i++) {
                                    OrderItemDTO it = items.get(i);
                                    String itemAmt = String.format("%.2f", it.getUnitPrice());
                        %>
                        <div class="flex items-center justify-between py-2 <%= i > 0 ? "border-t border-gray-50" : "" %>">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-lg bg-brand-50 flex items-center justify-center shrink-0">
                                    <svg class="w-5 h-5 text-brand-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17H3a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v10a2 2 0 01-2 2h-2"/>
                                    </svg>
                                </div>
                                <div>
                                    <p class="text-sm font-medium text-gray-800">
                                        <%= it.getProduct() != null ? it.getProduct().getProductName() : "Product #" + it.getProductId() %>
                                    </p>
                                    <p class="text-xs text-gray-500">Qty: <%= it.getQuantity() %> &times; Rs.<%= itemAmt %></p>
                                </div>
                            </div>
                        </div>
                        <%
                            }
                            if (items.size() > previewCount) {
                        %>
                        <p class="text-xs text-gray-500 mt-1">+ <%= items.size() - previewCount %> more item(s)</p>
                        <%
                                }
                            }
                        %>

                        <!-- Expandable full item list -->
                        <div id="<%= detailsId %>" class="hidden mt-3 border-t border-gray-100 pt-3">
                            <table class="w-full text-sm">
                                <thead>
                                <tr class="text-left text-xs text-gray-500 uppercase tracking-wide">
                                    <th class="pb-2 font-semibold">Product</th>
                                    <th class="pb-2 font-semibold text-center">Qty</th>
                                    <th class="pb-2 font-semibold text-right">Unit Price</th>
                                    <th class="pb-2 font-semibold text-right">Subtotal</th>
                                </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-50">
                                <%
                                    if (items != null) {
                                        for (OrderItemDTO it : items) {
                                            String unitPrice = String.format("%.2f", it.getUnitPrice());
                                            String subtotal = String.format("%.2f", it.getUnitPrice() * it.getQuantity());
                                %>
                                <tr>
                                    <td class="py-2 text-gray-800">
                                        <%= it.getProduct() != null ? it.getProduct().getProductName() : "Product #" + it.getProductId() %>
                                    </td>
                                    <td class="py-2 text-center text-gray-600"><%= it.getQuantity() %></td>
                                    <td class="py-2 text-right text-gray-600">Rs.<%= unitPrice %></td>
                                    <td class="py-2 text-right font-semibold text-gray-800">Rs.<%= subtotal %></td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                                </tbody>
                            </table>
                            <div class="mt-3 pt-3 border-t border-gray-100">
                                <p class="text-xs text-gray-500 uppercase tracking-wide font-semibold mb-1">Shipping Address</p>
                                <p class="text-sm text-gray-700"><%= o.getShippingAddress() != null ? o.getShippingAddress() : "-" %></p>
                            </div>
                        </div>

                        <div class="flex items-center justify-between mt-4 pt-3 border-t border-gray-100">
                            <button onclick="toggleDetails('<%= detailsId %>', this)"
                                    class="text-sm font-semibold text-brand-600 hover:text-brand-700 flex items-center gap-1">
                                <span class="toggle-label">View Order Details</span>
                                <svg class="w-4 h-4 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                                </svg>
                            </button>
                            <a href="invoice?orderId=<%= o.getOrderId() %>"
                               class="border border-brand-600 text-brand-600 hover:bg-brand-600 hover:text-white text-xs font-semibold px-4 py-2 rounded-lg transition-colors">
                                Download Invoice
                            </a>
                        </div>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>
    </section>
</main>

<script>
    function toggleDetails(id, btn) {
        const el = document.getElementById(id);
        const label = btn.querySelector('.toggle-label');
        const icon = btn.querySelector('svg');
        el.classList.toggle('hidden');
        const isOpen = !el.classList.contains('hidden');
        label.textContent = isOpen ? 'Hide Order Details' : 'View Order Details';
        icon.style.transform = isOpen ? 'rotate(180deg)' : 'rotate(0deg)';
    }
</script>

<%@ include file="WEB-INF/includes/footer.jsp" %>
