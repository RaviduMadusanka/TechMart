<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechMart Online - ${pageTitle}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: {
                            50:  '#eff6ff',
                            100: '#dbeafe',
                            500: '#3b82f6',
                            600: '#2563eb',
                            700: '#1d4ed8',
                            800: '#1e40af',
                            900: '#1e3a8a',
                        }
                    },
                    fontFamily: {
                        sans: ['Inter', 'system-ui', 'sans-serif'],
                    }
                }
            }
        }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .cart-badge { animation: pop 0.2s ease-out; }
        @keyframes pop { 0%,100%{transform:scale(1)} 50%{transform:scale(1.3)} }
        .product-card:hover .product-img { transform: scale(1.05); }
        .product-img { transition: transform 0.3s ease; }
        .btn-primary { @apply bg-brand-600 hover:bg-brand-700 text-white font-semibold py-2.5 px-5 rounded-lg transition-all duration-200 active:scale-95; }
    </style>
</head>
<body class="bg-gray-50 font-sans text-gray-800 min-h-screen flex flex-col">

<!-- Top Bar -->
<div class="bg-brand-800 text-white text-xs py-1.5 text-center tracking-wide">
    Free shipping on orders over $50 &nbsp;|&nbsp; 24/7 Support: 1800-TECHMART
</div>

<!-- Navigation -->
<nav class="bg-white border-b border-gray-200 shadow-sm sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">

            <!-- Logo -->
            <a href="index.jsp" class="flex items-center gap-2 group">
                <div class="w-9 h-9 bg-brand-600 rounded-lg flex items-center justify-center group-hover:bg-brand-700 transition-colors">
                    <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17H3a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v10a2 2 0 01-2 2h-2"/>
                    </svg>
                </div>
                <span class="text-xl font-bold text-brand-800">Tech<span class="text-brand-500">Mart</span></span>
            </a>

            <!-- Search Bar -->
            <div class="hidden md:flex flex-1 max-w-lg mx-8">
                <div class="relative w-full">
                    <input type="text" placeholder="Search products, brands..."
                           class="w-full pl-4 pr-10 py-2.5 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent bg-gray-50"/>
                    <button class="absolute right-2 top-1/2 -translate-y-1/2 text-gray-400 hover:text-brand-600">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                        </svg>
                    </button>
                </div>
            </div>

            <div class="flex items-center gap-1">
                <%
                    Object loggedUser = session.getAttribute("loggedUserName");

                    if (loggedUser == null) {
                %>
                <a href="login.jsp" class="flex flex-col items-center px-3 py-1.5 text-gray-600 hover:text-brand-600 rounded-lg hover:bg-brand-50 transition-colors group">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                    </svg>
                    <span class="text-xs mt-0.5 font-medium">Sign In</span>
                </a>.0
                <%
                } else {
                    String userName = loggedUser.toString();
                %>
                <div class="dropdown">
                    <a href="#"
                       class="dropdown-toggle text-decoration-none text-gray-700 hover:text-brand-600 flex flex-col items-center px-3 py-1.5"
                       data-bs-toggle="dropdown"
                       aria-expanded="false">

                        <div class="relative">
                            <svg class="w-5 h-5 text-brand-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                            </svg>
                            <span class="absolute top-0 right-0 block h-2 w-2 rounded-full bg-green-400 ring-2 ring-white"></span>
                        </div>

                        <span class="text-xs mt-1 font-semibold text-gray-800">Hi, <%= userName %></span>
                    </a>

                    <ul class="dropdown-menu dropdown-menu-end shadow rounded-3 border-light">
                        <li class="px-3 py-2 bg-light text-center rounded-top">
                            <p class="text-muted mb-0" style="font-size: 11px;">Logged in as</p>
                            <p class="text-dark font-weight-bold mb-0 text-truncate" style="font-size: 13px;"><%= userName %></p>
                        </li>
                        <li><hr class="dropdown-divider mt-0"></li>
                        <li>
                            <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile">
                                👤 My Profile
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item py-2" href="order-history">
                                📦 Orders
                            </a>
                        </li>

                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item text-danger py-2 font-medium" href="auth?action=logout">
                                🚪 Sign Out
                            </a>
                        </li>
                    </ul>
                </div>
                <%
                    }
                %>

                <a href="cart.jsp" class="relative flex flex-col items-center px-3 py-1.5 text-gray-600 hover:text-brand-600 rounded-lg hover:bg-brand-50 transition-colors">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                    </svg>
                    <span class="text-xs mt-0.5 font-medium">Cart</span>
                    <span class="absolute top-0.5 right-1.5 bg-brand-600 text-white text-xs w-4 h-4 flex items-center justify-center rounded-full font-bold cart-badge">3</span>
                </a>
            </div>
        </div>

        <!-- Category Nav -->
        <div class="hidden md:flex items-center gap-6 pb-3 text-sm font-medium text-gray-600">
            <a href="#" class="hover:text-brand-600 transition-colors">Laptops</a>
            <a href="#" class="hover:text-brand-600 transition-colors">Smartphones</a>
            <a href="#" class="hover:text-brand-600 transition-colors">Tablets</a>
            <a href="#" class="hover:text-brand-600 transition-colors">Audio</a>
            <a href="#" class="hover:text-brand-600 transition-colors">Accessories</a>
            <a href="#" class="text-brand-600 font-semibold">🔥 Hot Deals</a>
        </div>
    </div>
</nav>
