<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("loggedUserEmail") == null) {
        response.sendRedirect(request.getContextPath() + "/auth?action=login");
        return;
    }
    String view = request.getParameter("view");
    if (view == null || view.trim().isEmpty()) { view = "overview"; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechMart - Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { theme: { extend: { colors: { brand: { 500:'#3b5bdb', 600:'#2f4cc8', 700:'#1e3a8a' } } } } }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>body{ font-family: 'Inter', sans-serif; }</style>
</head>
<body class="bg-slate-100">

<div class="flex min-h-screen">
    <aside class="w-72 bg-gradient-to-b from-blue-900 to-blue-800 text-white shadow-2xl flex flex-col">
        <div class="p-6 border-b border-blue-800">
            <div class="flex items-center gap-3">
                <div class="w-12 h-12 rounded-xl bg-white/20 flex items-center justify-center text-2xl">🛒</div>
                <div>
                    <h1 class="font-bold text-xl">TechMart</h1>
                    <p class="text-blue-200 text-sm">Enterprise Platform</p>
                </div>
            </div>
        </div>

        <nav class="flex-1 p-4 space-y-2">
            <a href="?view=overview" class="flex items-center gap-3 px-5 py-3 rounded-xl transition <%= "overview".equals(view) ? "bg-white/15 font-semibold" : "hover:bg-white/10" %>">📊 Dashboard Overview</a>
            <a href="?view=products" class="flex items-center gap-3 px-5 py-3 rounded-xl transition <%= "products".equals(view) ? "bg-white/15 font-semibold" : "hover:bg-white/10" %>">🛍 Products Management</a>
            <a href="?view=categories" class="flex items-center gap-3 px-5 py-3 rounded-xl transition <%= "categories".equals(view) ? "bg-white/15 font-semibold" : "hover:bg-white/10" %>">📁 Category Managment</a>
            <a href="?view=brand" class="flex items-center gap-3 px-5 py-3 rounded-xl transition <%= "brand".equals(view) ? "bg-white/15 font-semibold" : "hover:bg-white/10" %>">📁 Brand Managment</a>
            <a href="?view=inventory" class="flex items-center gap-3 px-5 py-3 rounded-xl transition <%= "inventory".equals(view) ? "bg-white/15 font-semibold" : "hover:bg-white/10" %>">📦 Inventory Management</a>
            <a href="?view=orders" class="flex items-center gap-3 px-5 py-3 rounded-xl transition <%= "orders".equals(view) ? "bg-white/15 font-semibold" : "hover:bg-white/10" %>">📑 Orders Management</a>
            <a href="?view=users" class="flex items-center gap-3 px-5 py-3 rounded-xl transition <%= "users".equals(view) ? "bg-white/15 font-semibold" : "hover:bg-white/10" %>">👥 Users Management</a>
        </nav>

        <div class="p-4 border-t border-blue-800">
            <a href="auth?action=logout" class="block w-full bg-red-500 hover:bg-red-600 text-center py-3 rounded-xl font-semibold transition">Logout</a>
        </div>
    </aside>

    <main class="flex-1 p-8">
        <div class="bg-white rounded-2xl shadow-sm p-6 flex justify-between items-center mb-8">
            <div>
                <h2 class="text-3xl font-bold text-slate-800 capitalize"><%= view.replace("-", " ") %></h2>
                <p class="text-slate-500 mt-1">Welcome back, <span class="font-semibold"><%= session.getAttribute("loggedUserName") %></span></p>
            </div>
            <div class="bg-slate-100 px-5 py-3 rounded-xl">
                <span class="text-slate-500 text-sm">Logged in as</span>
                <p class="font-semibold text-slate-800"><%= session.getAttribute("loggedUserEmail") %></p>
            </div>
        </div>

        <% if ("products".equals(view)) { %>
        <jsp:include page="views/products-content.jsp" />
        <% } else if ("categories".equals(view)) { %>
        <jsp:include page="views/categories-content.jsp" />
        <% } else if ("brand".equals(view)) { %>
        <jsp:include page="views/brands-content.jsp" />
        <% } else if ("orders".equals(view)) { %>
        <jsp:include page="views/orders-content.jsp" />
        <% } else if ("inventory".equals(view)) { %>
        <jsp:include page="views/inventory-content.jsp" />
        <% } else if ("users".equals(view)) { %>
        <jsp:include page="views/users-content.jsp" />
        <% } else { %>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div class="bg-white p-6 rounded-2xl shadow-sm border-l-4 border-brand-500"><h4 class="text-slate-500">Total Products</h4><h2 class="text-4xl font-bold mt-3 text-slate-800">1,250</h2></div>
            <div class="bg-white p-6 rounded-2xl shadow-sm border-l-4 border-green-500"><h4 class="text-slate-500">Orders Today</h4><h2 class="text-4xl font-bold mt-3 text-slate-800">124</h2></div>
            <div class="bg-white p-6 rounded-2xl shadow-sm border-l-4 border-yellow-500"><h4 class="text-slate-500">Low Stock Items</h4><h2 class="text-4xl font-bold mt-3 text-slate-800">12</h2></div>
            <div class="bg-white p-6 rounded-2xl shadow-sm border-l-4 border-purple-500"><h4 class="text-slate-500">Total Customers</h4><h2 class="text-4xl font-bold mt-3 text-slate-800">3,240</h2></div>
        </div>

        <div class="bg-white rounded-2xl shadow-sm p-8 mt-8 border-l-8 border-brand-500">
            <h2 class="text-3xl font-bold text-slate-800">Welcome to TechMart Admin 🎉</h2>
            <p class="text-slate-600 mt-2 text-lg">Use the sidebar to manage your enterprise e-commerce platform.</p>
        </div>
        <% } %>
    </main>
</div>
</body>
</html>