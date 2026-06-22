<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechMart – Sign In</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: { 500:'#3b5bdb', 600:'#2f4cc8', 400:'#748ffc' },
                        accent: '#f59f00',
                    }
                }
            }
        }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        .hero-gradient { background: linear-gradient(135deg, #0f1f6b 0%, #1e3a8a 50%, #1e40af 100%); }
        .input-focus:focus { box-shadow: 0 0 0 3px rgba(59,91,219,0.25); }
        @keyframes fadeIn { from{opacity:0;transform:translateX(-20px)}to{opacity:1;transform:translateX(0)} }
        .fade-in { animation: fadeIn 0.6s ease forwards; }
        @keyframes fadeInRight { from{opacity:0;transform:translateX(20px)}to{opacity:1;transform:translateX(0)} }
        .fade-in-right { animation: fadeInRight 0.6s ease 0.1s forwards; opacity:0; }
    </style>
</head>
<body class="min-h-screen bg-slate-50 flex">

<!-- Left panel – brand showcase -->
<div class="hidden lg:flex lg:w-1/2 hero-gradient flex-col justify-between p-12 fade-in">
    <div>
        <div class="flex items-center gap-3">
            <div class="w-9 h-9 bg-white/20 rounded-lg flex items-center justify-center">
                <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
                </svg>
            </div>
            <span class="text-white font-bold text-xl tracking-tight">TechMart Online</span>
        </div>
    </div>

    <div class="space-y-6">
        <div class="inline-block bg-white/10 border border-white/20 rounded-full px-4 py-1.5">
            <span class="text-blue-200 text-xs font-semibold uppercase tracking-widest">Enterprise E-Commerce</span>
        </div>
        <h1 class="text-white text-4xl font-bold leading-tight">
            Your favourite tech,<br>
            <span class="text-yellow-400">delivered fast.</span>
        </h1>
        <p class="text-blue-200 text-base leading-relaxed max-w-sm">
            Shop from 50,000+ tech products. Real-time inventory, instant notifications,
            and personalised recommendations powered by Java EE.
        </p>
        <!-- Stats -->
        <div class="grid grid-cols-3 gap-4 pt-4">
            <div class="bg-white/10 rounded-xl p-4 text-center">
                <div class="text-white font-bold text-2xl">10K+</div>
                <div class="text-blue-300 text-xs mt-1">Concurrent Users</div>
            </div>
            <div class="bg-white/10 rounded-xl p-4 text-center">
                <div class="text-yellow-400 font-bold text-2xl">99.9%</div>
                <div class="text-blue-300 text-xs mt-1">Uptime SLA</div>
            </div>
            <div class="bg-white/10 rounded-xl p-4 text-center">
                <div class="text-white font-bold text-2xl">&lt;1s</div>
                <div class="text-blue-300 text-xs mt-1">Response Time</div>
            </div>
        </div>
    </div>

    <p class="text-blue-400 text-xs">© 2026 TechMart Online · Built on Java EE / Jakarta EE</p>
</div>

<!-- Right panel – login form -->
<div class="w-full lg:w-1/2 flex items-center justify-center p-6 sm:p-12 fade-in-right">
    <div class="w-full max-w-md">
        <!-- Mobile logo -->
        <div class="lg:hidden flex items-center gap-2 mb-8">
            <div class="w-8 h-8 bg-brand-500 rounded-lg flex items-center justify-center">
                <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
                </svg>
            </div>
            <span class="text-slate-800 font-bold text-xl">TechMart</span>
        </div>

        <h2 class="text-slate-800 text-2xl font-bold mb-1">Welcome back</h2>
        <p class="text-slate-500 text-sm mb-8">Sign in to your TechMart account</p>

        <!-- AJAX Messages පෙන්වීමට වෙන් කළ ස්ථානය -->
        <div id="ajaxMessageContainer">
            <!-- Error message (Wired to Servlet initially) -->
            <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="bg-red-50 border border-red-200 rounded-lg p-3 mb-5 flex items-center gap-2">
                <svg class="w-4 h-4 text-red-500 shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"/>
                </svg>
                <span class="text-red-600 text-sm"><%= request.getAttribute("errorMessage") %></span>
            </div>
            <% } %>

            <!-- Success message (Wired to Servlet initially) -->
            <% if(request.getAttribute("successMessage") != null) { %>
            <div class="bg-green-50 border border-green-200 rounded-lg p-3 mb-5 flex items-center gap-2">
                <svg class="w-4 h-4 text-green-500 shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"/>
                </svg>
                <span class="text-green-700 text-sm"><%= request.getAttribute("successMessage") %></span>
            </div>
            <% } %>
        </div>

        <!-- Form Action Updated and ID added for AJAX -->
        <form id="loginForm" action="auth?action=login" method="post" class="space-y-5">
            <!-- Email -->
            <div>
                <label class="block text-slate-700 text-sm font-medium mb-2" for="email">Email Address</label>
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"/>
                        </svg>
                    </div>
                    <input type="email" id="email" name="email" required
                           placeholder="you@example.com"
                           class="input-focus w-full bg-white border border-slate-300 rounded-lg pl-10 pr-4 py-3
                                      text-slate-800 placeholder-slate-400 text-sm outline-none transition-all
                                      focus:border-brand-500 hover:border-slate-400">
                </div>
            </div>

            <div>
                <div class="flex items-center justify-between mb-2">
                    <label class="text-slate-700 text-sm font-medium" for="password">Password</label>
                    <a href="forgot-password.jsp"
                       class="text-brand-500 text-xs hover:text-brand-600 transition-colors">Forgot password?</a>
                </div>
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                        </svg>
                    </div>
                    <input type="password" id="password" name="password" required
                           placeholder="Enter your password"
                           class="input-focus w-full bg-white border border-slate-300 rounded-lg pl-10 pr-12 py-3
                                      text-slate-800 placeholder-slate-400 text-sm outline-none transition-all
                                      focus:border-brand-500 hover:border-slate-400">
                    <button type="button" onclick="togglePassword('password')"
                            class="absolute inset-y-0 right-0 pr-3 flex items-center text-slate-400 hover:text-slate-600">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M15 12a3 3 0 11-6 0 3 3 0 016 0zM2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                        </svg>
                    </button>
                </div>
            </div>

            <div class="flex items-center gap-2">
                <input type="checkbox" id="rememberMe" name="rememberMe"
                       class="w-4 h-4 rounded border-slate-300 text-brand-500 accent-brand-500">
                <label for="rememberMe" class="text-slate-600 text-sm cursor-pointer">Keep me signed in</label>
            </div>

            <button type="submit" id="submitBtn"
                    class="w-full bg-brand-500 hover:bg-brand-600 text-white font-semibold py-3 rounded-lg
                               transition-all duration-200 text-sm shadow-lg shadow-brand-500/25 active:scale-[0.98] flex items-center justify-center gap-2">
                <span>Sign In</span>
            </button>
        </form>

        <div class="relative my-6">
            <div class="absolute inset-0 flex items-center">
                <div class="w-full border-t border-slate-200"></div>
            </div>
            <div class="relative flex justify-center text-xs">
                <span class="bg-slate-50 px-3 text-slate-400">Don't have an account?</span>
            </div>
        </div>

        <a href="auth?action=register"
           class="block w-full border-2 border-brand-500 text-brand-500 hover:bg-brand-50 font-semibold
                      py-3 rounded-lg transition-all text-sm text-center">
            Create New Account
        </a>

        <p class="text-center mt-6 text-slate-400 text-xs">
            Admin access?
            <a href="admin-auth"
               class="text-brand-500 hover:text-brand-600 transition-colors ml-1">Admin Portal →</a>
        </p>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>
</html>