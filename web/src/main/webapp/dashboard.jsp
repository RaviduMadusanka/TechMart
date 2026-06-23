<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("loggedUserEmail") == null) {
        response.sendRedirect(request.getContextPath() + "/auth?action=login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechMart - Dashboard</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: {
                            500:'#3b5bdb',
                            600:'#2f4cc8',
                            700:'#1e3a8a'
                        }
                    }
                }
            }
        }
    </script>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body{
            font-family: 'Inter', sans-serif;
        }

        .sidebar-link{
            @apply flex items-center gap-3 px-5 py-3 rounded-xl transition-all duration-200;
        }
    </style>

</head>
<body class="bg-slate-100">

<div class="flex min-h-screen">
    <aside class="w-72 bg-gradient-to-b from-blue-900 to-blue-800 text-white shadow-2xl flex flex-col">

        <div class="p-6 border-b border-blue-800">
            <div class="flex items-center gap-3">
                <div class="w-12 h-12 rounded-xl bg-white/20 flex items-center justify-center text-2xl">
                    🛒
                </div>

                <div>
                    <h1 class="font-bold text-xl">TechMart</h1>
                    <p class="text-blue-200 text-sm">Enterprise Platform</p>
                </div>
            </div>
        </div>

        <nav class="flex-1 p-4 space-y-2">

            <a href="#" class="flex items-center gap-3 bg-white/15 px-5 py-3 rounded-xl">
                📊 Dashboard
            </a>

            <a href="test-cart"
               class="flex items-center gap-3 hover:bg-white/10 px-5 py-3 rounded-xl transition">
                🛍 Products Management
            </a>

            <a href="#"
               class="flex items-center gap-3 hover:bg-white/10 px-5 py-3 rounded-xl transition">
                📦 Inventory Management
            </a>

            <a href="#"
               class="flex items-center gap-3 hover:bg-white/10 px-5 py-3 rounded-xl transition">
                📑 Orders Management
            </a>

            <a href="#"
               class="flex items-center gap-3 hover:bg-white/10 px-5 py-3 rounded-xl transition">
                📑 Users Management
            </a>

            <a href="#"
               class="flex items-center gap-3 hover:bg-white/10 px-5 py-3 rounded-xl transition">
                🛒 Shopping Cart
            </a>

            <a href="#"
               class="flex items-center gap-3 hover:bg-white/10 px-5 py-3 rounded-xl transition">
                🔔 Notifications
            </a>

            <a href="#"
               class="flex items-center gap-3 hover:bg-white/10 px-5 py-3 rounded-xl transition">
                📈 Performance Metrics
            </a>

        </nav>

        <div class="p-4 border-t border-blue-800">

            <a href="auth?action=logout"
               class="block w-full bg-red-500 hover:bg-red-600 text-center py-3 rounded-xl font-semibold transition">
                Logout
            </a>

        </div>

    </aside>

    <main class="flex-1 p-8">
        <div class="bg-white rounded-2xl shadow-sm p-6 flex justify-between items-center">

            <div>
                <h2 class="text-3xl font-bold text-slate-800">
                    Dashboard Overview
                </h2>

                <p class="text-slate-500 mt-1">
                    Welcome back,
                    <span class="font-semibold">
                        <%= session.getAttribute("loggedUserName") %>
                    </span>
                </p>
            </div>

            <div class="bg-slate-100 px-5 py-3 rounded-xl">
                <span class="text-slate-500 text-sm">Logged in as</span>
                <p class="font-semibold text-slate-800">
                    <%= session.getAttribute("loggedUserEmail") %>
                </p>
            </div>

        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mt-8">

            <div class="bg-white p-6 rounded-2xl shadow-sm">
                <h4 class="text-slate-500">Total Products</h4>
                <h2 class="text-4xl font-bold mt-3 text-brand-500">150</h2>
            </div>

            <div class="bg-white p-6 rounded-2xl shadow-sm">
                <h4 class="text-slate-500">Orders Today</h4>
                <h2 class="text-4xl font-bold mt-3 text-green-500">24</h2>
            </div>

            <div class="bg-white p-6 rounded-2xl shadow-sm">
                <h4 class="text-slate-500">Notifications</h4>
                <h2 class="text-4xl font-bold mt-3 text-yellow-500">12</h2>
            </div>

            <div class="bg-white p-6 rounded-2xl shadow-sm">
                <h4 class="text-slate-500">Customers</h4>
                <h2 class="text-4xl font-bold mt-3 text-purple-500">3,240</h2>
            </div>

        </div>

        <div class="bg-white rounded-2xl shadow-sm p-8 mt-8 border-l-8 border-brand-500">

            <h2 class="text-3xl font-bold text-slate-800">
                Welcome to TechMart 🎉
            </h2>

            <p class="text-slate-600 mt-5 text-lg">
                <strong>Name:</strong>
                <%= session.getAttribute("loggedUserName") %>
            </p>

            <p class="text-slate-600 mt-2 text-lg">
                <strong>Email:</strong>
                <%= session.getAttribute("loggedUserEmail") %>
            </p>

            <a href="test-cart"
               class="inline-block mt-8 bg-brand-500 hover:bg-brand-600 text-white px-8 py-3 rounded-xl font-semibold transition">
                Go to Store →
            </a>

        </div>

    </main>

</div>

</body>
</html>