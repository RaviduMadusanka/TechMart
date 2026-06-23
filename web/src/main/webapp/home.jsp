<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechMart Online</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: {
                            500:'#3b5bdb',
                            600:'#2f4cc8'
                        }
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-slate-50">

<!-- Navbar -->
<nav class="bg-white shadow-sm">
    <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">

        <h1 class="text-2xl font-bold text-brand-500">
            TechMart Online
        </h1>

        <div class="hidden md:flex gap-8">
            <a href="index.jsp" class="hover:text-brand-500">Home</a>
            <a href="test-cart" class="hover:text-brand-500">Products</a>
            <a href="#" class="hover:text-brand-500">Categories</a>
            <a href="#" class="hover:text-brand-500">About</a>
            <a href="#" class="hover:text-brand-500">Contact</a>
        </div>

        <!-- Login / Logout පෙන්වන ඩයිනමික් කොටස -->
        <div class="flex items-center gap-4">
            <% if(session.getAttribute("loggedUserName") != null) { %>
            <!-- ලොග් වෙලා නම් -->
            <span class="text-slate-600 font-medium hidden sm:block">Hi, <%= session.getAttribute("loggedUserName") %></span>
            <a href="test-cart" class="text-brand-600 font-bold hover:text-brand-800">Cart</a>
            <a href="auth?action=logout" class="bg-red-500 hover:bg-red-600 text-white px-5 py-2 rounded-lg transition">
                Logout
            </a>
            <% } else { %>
            <!-- ලොග් වෙලා නැත්නම් -->
            <a href="auth?action=login" class="bg-brand-500 hover:bg-brand-600 text-white px-5 py-2 rounded-lg transition">
                Login
            </a>
            <% } %>
        </div>

    </div>
</nav>

<!-- Hero -->
<section class="bg-gradient-to-r from-blue-900 to-blue-700 text-white">
    <div class="max-w-7xl mx-auto px-6 py-24">

        <h1 class="text-5xl font-bold mb-6">
            Shop the Latest Tech Products
        </h1>

        <p class="text-xl text-blue-200 mb-8">
            Real-time inventory, fast delivery and enterprise-grade reliability.
        </p>

        <div class="flex gap-4">
            <a href="test-cart" class="bg-yellow-500 hover:bg-yellow-600 text-slate-900 font-bold px-6 py-3 rounded-lg transition">
                Shop Now
            </a>

            <button class="border border-white hover:bg-white hover:text-blue-900 font-bold px-6 py-3 rounded-lg transition">
                Explore
            </button>
        </div>

    </div>
</section>

<!-- Categories -->
<section class="max-w-7xl mx-auto py-20 px-6">

    <h2 class="text-3xl font-bold text-center mb-12">
        Featured Categories
    </h2>

    <div class="grid grid-cols-1 md:grid-cols-4 gap-6">

        <div class="bg-white p-8 rounded-xl shadow text-center transform transition hover:-translate-y-1 hover:shadow-lg cursor-pointer">
            <div class="text-4xl mb-4">💻</div>
            <h3 class="font-bold">Laptops</h3>
        </div>

        <div class="bg-white p-8 rounded-xl shadow text-center transform transition hover:-translate-y-1 hover:shadow-lg cursor-pointer">
            <div class="text-4xl mb-4">📱</div>
            <h3 class="font-bold">Smartphones</h3>
        </div>

        <div class="bg-white p-8 rounded-xl shadow text-center transform transition hover:-translate-y-1 hover:shadow-lg cursor-pointer">
            <div class="text-4xl mb-4">🎮</div>
            <h3 class="font-bold">Gaming</h3>
        </div>

        <div class="bg-white p-8 rounded-xl shadow text-center transform transition hover:-translate-y-1 hover:shadow-lg cursor-pointer">
            <div class="text-4xl mb-4">🎧</div>
            <h3 class="font-bold">Accessories</h3>
        </div>

    </div>

</section>

<!-- Footer -->
<footer class="bg-slate-900 text-white py-10 text-center">
    <p>© 2026 TechMart Online | Java EE Enterprise Platform</p>
</footer>

</body>
</html>