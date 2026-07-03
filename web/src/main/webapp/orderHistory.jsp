<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, lk.techmart.core.dto.OrderDTO"%>
<%
    request.setAttribute("pageTitle", "Order History - TechMart");
    List<OrderDTO> ordersList = (List<OrderDTO>) request.getAttribute("ordersList");
%>
<%@ include file="WEB-INF/includes/header.jsp" %>

<main class="flex-1 bg-gray-50">
    <section class="bg-gradient-to-r from-brand-800 via-brand-700 to-brand-600 text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <h1 class="text-2xl md:text-3xl font-bold leading-tight">My Orders</h1>
            <p class="text-blue-100 text-sm mt-1">View and track your previous purchases</p>
        </div>
    </section>

    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">

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
                        <a href="cart.jsp" class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-gray-600 hover:bg-gray-50 hover:text-brand-600 font-medium text-sm transition-colors">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                            </svg>
                            My Cart
                        </a>
                        <a href="auth?action=logout" class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-red-500 hover:bg-red-50 font-medium text-sm transition-colors mt-2 border-t border-gray-100 pt-3">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                            </svg>
                            Logout
                        </a>
                    </nav>
                </div>
            </aside>

            <div class="lg:col-span-3 flex flex-col gap-5">

                <%
                    if (ordersList != null && !ordersList.isEmpty()) {
                        for (OrderDTO order : ordersList) {
                            String formattedTotal = String.format("%.2f", order.getTotalAmount());
                            // තාවකාලික Status එකක් (DB එකෙන් එන එක null නම්)
                            String statusText = (order.getStatus() != null) ? order.getStatus() : "Processing";

                            // Status එක අනුව පාට වෙනස් කිරීම
                            String statusColor = "bg-blue-50 text-blue-700 border-blue-200";
                            if (statusText.equalsIgnoreCase("Completed") || statusText.equalsIgnoreCase("Delivered")) {
                                statusColor = "bg-emerald-50 text-emerald-700 border-emerald-200";
                            } else if (statusText.equalsIgnoreCase("Cancelled")) {
                                statusColor = "bg-red-50 text-red-700 border-red-200";
                            }
                %>
                <div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden hover:shadow-md transition-shadow">
                    <div class="px-6 py-4 border-b border-gray-100 bg-gray-50 flex flex-wrap items-center justify-between gap-4">
                        <div class="flex flex-wrap gap-6">
                            <div>
                                <p class="text-xs text-gray-500 font-semibold uppercase tracking-wide">Order Placed</p>
                                <p class="text-sm font-medium text-gray-900 mt-0.5"><%= order.getOrderDate() != null ? order.getOrderDate().toString().substring(0,10) : "N/A" %></p>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500 font-semibold uppercase tracking-wide">Total</p>
                                <p class="text-sm font-bold text-gray-900 mt-0.5">Rs. <%= formattedTotal %></p>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500 font-semibold uppercase tracking-wide">Order ID</p>
                                <p class="text-sm font-medium text-gray-900 mt-0.5">#<%= order.getOrderId() %></p>
                            </div>
                        </div>

                        <div class="text-right">
                            <span class="inline-block px-3 py-1 rounded-full text-xs font-semibold border <%= statusColor %>">
                                <%= statusText %>
                            </span>
                        </div>
                    </div>

                    <div class="px-6 py-5 flex flex-col md:flex-row items-start justify-between gap-4">
                        <div class="flex-1">
                            <h4 class="text-sm font-semibold text-gray-900 mb-2">Shipping Address:</h4>
                            <p class="text-sm text-gray-600 max-w-sm"><%= order.getShipping_address() != null ? order.getShipping_address() : "No address provided" %></p>
                        </div>
                        <div class="shrink-0 flex flex-col gap-2 w-full md:w-auto">
                            <!-- ඉස්සරහට Order Items පෙන්වන Page එකක් ගැහුවොත් ඒකට ලින්ක් කරන්න පුළුවන් -->
                            <button class="w-full text-center bg-white border border-gray-300 hover:bg-gray-50 text-gray-700 text-sm font-semibold px-4 py-2 rounded-lg transition-colors">
                                View Details
                            </button>
                        </div>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="bg-white rounded-xl border border-gray-200 shadow-sm p-12 text-center">
                    <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
                        </svg>
                    </div>
                    <h3 class="text-lg font-bold text-gray-900 mb-1">No orders yet</h3>
                    <p class="text-gray-500 text-sm mb-6">Looks like you haven't made any purchases yet.</p>
                    <a href="${pageContext.request.contextPath}/home" class="inline-block bg-brand-600 hover:bg-brand-700 text-white font-semibold px-6 py-2.5 rounded-lg transition-colors">
                        Start Shopping
                    </a>
                </div>
                <%
                    }
                %>

            </div>
        </div>
    </section>
</main>

<%@ include file="WEB-INF/includes/footer.jsp" %>