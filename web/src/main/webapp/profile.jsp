<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, lk.techmart.core.dto.CustomerDTO, lk.techmart.core.dto.OrderDTO"%>
<%
    request.setAttribute("pageTitle", "My Profile - TechMart");

    CustomerDTO customer = (CustomerDTO) request.getAttribute("customer");
    List<OrderDTO> recentOrders = (List<OrderDTO>) request.getAttribute("recentOrders");

    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/auth?action=login");
        return;
    }

    String fullName = customer.getFirstName() + " " + (customer.getLastName() != null ? customer.getLastName() : "");
    String initials = "" + Character.toUpperCase(customer.getFirstName().charAt(0))
            + (customer.getLastName() != null && !customer.getLastName().isEmpty() ? Character.toUpperCase(customer.getLastName().charAt(0)) : "");
%>
<%@ include file="WEB-INF/includes/header.jsp" %>

<main class="flex-1 bg-gray-50">

    <%
        String profileSuccess = (String) session.getAttribute("profileSuccessMessage");
        if (profileSuccess != null) {
    %>
    <div id="profileAlert" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-4 animate-bounce">
        <div class="bg-emerald-50 border border-emerald-400 text-emerald-800 px-4 py-3 rounded-xl relative flex items-center justify-between shadow-sm" role="alert">
            <div class="flex items-center gap-2">
                <svg class="w-5 h-5 text-emerald-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <span class="font-medium text-sm"><%= profileSuccess %></span>
            </div>
            <button onclick="document.getElementById('profileAlert').style.display='none'" class="text-emerald-600 hover:text-emerald-800 font-bold text-lg focus:outline-none">&times;</button>
        </div>
    </div>
    <%
            session.removeAttribute("profileSuccessMessage");
        }

        String profileError = (String) session.getAttribute("profileErrorMessage");
        if (profileError != null) {
    %>
    <div id="profileErrorAlert" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-4">
        <div class="bg-red-50 border border-red-400 text-red-700 px-4 py-3 rounded-xl relative flex items-center justify-between shadow-sm" role="alert">
            <div class="flex items-center gap-2">
                <svg class="w-5 h-5 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01M5.07 19h13.86A2 2 0 0021 16.7L13.93 4.5a2 2 0 00-3.86 0L3 16.7A2 2 0 005.07 19z"/>
                </svg>
                <span class="font-medium text-sm"><%= profileError %></span>
            </div>
            <button onclick="document.getElementById('profileErrorAlert').style.display='none'" class="text-red-600 hover:text-red-800 font-bold text-lg focus:outline-none">&times;</button>
        </div>
    </div>
    <%
            session.removeAttribute("profileErrorMessage");
        }
    %>

    <section class="bg-gradient-to-r from-brand-800 via-brand-700 to-brand-600 text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 flex items-center gap-6">
            <div class="w-20 h-20 rounded-full bg-white/15 border border-white/30 flex items-center justify-center text-2xl font-bold shrink-0">
                <%= initials %>
            </div>
            <div>
                <span class="inline-block bg-white/20 text-white text-xs font-semibold px-3 py-1 rounded-full mb-2 uppercase tracking-wider">My Account</span>
                <h1 class="text-2xl md:text-3xl font-bold leading-tight"><%= fullName %></h1>
                <p class="text-blue-100 text-sm mt-1"><%= customer.getEmail() %></p>
            </div>
        </div>
    </section>

    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">

            <aside class="lg:col-span-1">
                <div class="bg-white rounded-xl border border-gray-200 shadow-sm p-4 sticky top-4">
                    <nav class="flex flex-col gap-1">
                        <a href="profile" class="flex items-center gap-3 px-3 py-2.5 rounded-lg bg-brand-50 text-brand-700 font-semibold text-sm">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                            </svg>
                            My Profile
                        </a>
                        <a href="order-history" class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-gray-600 hover:bg-gray-50 hover:text-brand-600 font-medium text-sm transition-colors">
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
            <div class="lg:col-span-3 flex flex-col gap-8">

                <div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-100">
                        <h2 class="text-lg font-bold text-gray-900">Personal Information</h2>
                        <p class="text-sm text-gray-500 mt-0.5">Update your personal details below</p>
                    </div>
                    <form action="profile" method="post" class="p-6 grid grid-cols-1 sm:grid-cols-2 gap-5">
                        <input type="hidden" name="action" value="updateInfo"/> <!-- මේක අලුතින් දාන්න -->
                        <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>"/>

                        <div>
                            <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">First Name</label>
                            <input type="text" name="firstName" value="<%= customer.getFirstName() %>" required
                                   class="w-full border border-gray-300 rounded-lg px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent"/>
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Last Name</label>
                            <input type="text" name="lastName" value="<%= customer.getLastName() != null ? customer.getLastName() : "" %>"
                                   class="w-full border border-gray-300 rounded-lg px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent"/>
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Email Address</label>
                            <input type="email" name="email" value="<%= customer.getEmail() %>" required
                                   class="w-full border border-gray-300 rounded-lg px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent"/>
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Phone Number</label>
                            <input type="text" name="phone" value="<%= customer.getPhone() != null ? customer.getPhone() : "" %>"
                                   class="w-full border border-gray-300 rounded-lg px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent"/>
                        </div>
                        <div class="sm:col-span-2">
                            <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Delivery Address</label>
                            <textarea name="address" rows="3"
                                      class="w-full border border-gray-300 rounded-lg px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent"><%= customer.getAddress() != null ? customer.getAddress() : "" %></textarea>
                        </div>

                        <div class="sm:col-span-2 flex justify-end gap-3 pt-2 border-t border-gray-100 mt-2">
                            <button type="reset" class="px-5 py-2.5 rounded-lg text-sm font-semibold text-gray-600 border border-gray-300 hover:bg-gray-50 transition-colors">
                                Cancel
                            </button>
                            <button type="submit" class="bg-brand-600 hover:bg-brand-700 text-white text-sm font-semibold px-6 py-2.5 rounded-lg transition-colors active:scale-95">
                                Save Changes
                            </button>
                        </div>
                    </form>
                </div>

                <div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-100">
                        <h2 class="text-lg font-bold text-gray-900">Change Password</h2>
                        <p class="text-sm text-gray-500 mt-0.5">Leave blank if you don't want to change it</p>
                    </div>
                    <form action="profile" method="post" class="p-6 grid grid-cols-1 sm:grid-cols-2 gap-5">
                        <input type="hidden" name="action" value="updatePassword"/> <!-- මේක අලුතින් දාන්න -->
                        <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>"/>
                        <div>
                            <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Current Password</label>
                            <input type="password" name="currentPassword"
                                   class="w-full border border-gray-300 rounded-lg px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent"/>
                        </div>
                        <div></div>
                        <div>
                            <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">New Password</label>
                            <input type="password" name="newPassword"
                                   class="w-full border border-gray-300 rounded-lg px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent"/>
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wide">Confirm New Password</label>
                            <input type="password" name="confirmPassword"
                                   class="w-full border border-gray-300 rounded-lg px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent"/>
                        </div>
                        <div class="sm:col-span-2 flex justify-end pt-2 border-t border-gray-100 mt-2">
                            <button type="submit" class="bg-brand-600 hover:bg-brand-700 text-white text-sm font-semibold px-6 py-2.5 rounded-lg transition-colors active:scale-95">
                                Update Password
                            </button>
                        </div>
                    </form>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <div class="bg-white rounded-xl border border-gray-200 shadow-sm p-5">
                        <p class="text-xs text-gray-500 uppercase tracking-wide font-semibold mb-1">Customer ID</p>
                        <p class="text-lg font-bold text-gray-900">#<%= customer.getCustomerId() %></p>
                    </div>
                    <div class="bg-white rounded-xl border border-gray-200 shadow-sm p-5">
                        <p class="text-xs text-gray-500 uppercase tracking-wide font-semibold mb-1">Member Since</p>
<%--                        <p class="text-lg font-bold text-gray-900"><%= customer.getCreatedAt() != null ? customer.getCreatedAt() : "-" %></p>--%>
                    </div>
                    <div class="bg-white rounded-xl border border-gray-200 shadow-sm p-5">
                        <p class="text-xs text-gray-500 uppercase tracking-wide font-semibold mb-1">Account Status</p>
                        <span class="inline-block bg-emerald-50 text-emerald-700 text-xs font-semibold px-2.5 py-1 rounded-full">Active</span>
                    </div>
                </div>

                <%
                    if (recentOrders != null && !recentOrders.isEmpty()) {
                %>
                <div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
                        <h2 class="text-lg font-bold text-gray-900">Recent Orders</h2>
                        <a href="order-history" class="text-sm font-semibold text-brand-600 hover:text-brand-700">View all →</a>
                    </div>
                    <div class="divide-y divide-gray-100">
                        <%
                            for (OrderDTO o : recentOrders) {
                                String amt = String.format("%.2f", o.getTotalAmount());
                        %>
                        <a href="order-details?id=<%= o.getOrderId() %>" class="flex items-center justify-between px-6 py-4 hover:bg-gray-50 transition-colors">
                            <div>
                                <p class="text-sm font-semibold text-gray-900">Order #<%= o.getOrderId() %></p>
                                <p class="text-xs text-gray-500 mt-0.5"><%= o.getOrderDate() %></p>
                            </div>
                            <div class="text-right">
                                <p class="text-sm font-bold text-gray-900">Rs.<%= amt %></p>
<%--                                <span class="text-xs text-brand-600 font-medium"><%= o.getStatus() != null ? o.getStatus().getName() : "Processing" %></span>--%>
                            </div>
                        </a>
                        <%
                            }
                        %>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </section>
</main>

<%@ include file="WEB-INF/includes/footer.jsp" %>
