<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechMart – Create Account</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: { 500:'#3b5bdb', 600:'#2f4cc8', 400:'#748ffc', 50:'#f0f4ff' },
                        accent: '#f59f00',
                    }
                }
            }
        }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        .input-focus:focus { box-shadow: 0 0 0 3px rgba(59,91,219,0.2); outline: none; }
        @keyframes fadeSlide { from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)} }
        .fade-slide { animation: fadeSlide 0.4s ease; }
    </style>
</head>
<body class="min-h-screen bg-slate-50">

<!-- Top bar -->
<nav class="bg-white border-b border-slate-200 px-6 py-4">
    <div class="max-w-6xl mx-auto flex items-center justify-between">
        <div class="flex items-center gap-2">
            <div class="w-8 h-8 bg-brand-500 rounded-lg flex items-center justify-center">
                <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
                </svg>
            </div>
            <span class="text-slate-800 font-bold text-lg">TechMart</span>
        </div>
        <p class="text-slate-500 text-sm">
            Already have an account?
            <a href="auth?action=login"
               class="text-brand-500 font-medium hover:text-brand-600 ml-1">Login Here</a>
        </p>
    </div>
</nav>

<div class="max-w-xl mx-auto px-4 py-10 fade-slide">
    <!-- Header -->
    <div class="text-center mb-8">
        <h1 class="text-slate-800 text-3xl font-bold mb-2">Create your account</h1>
        <p class="text-slate-500">Join 50,000+ tech shoppers on TechMart</p>
    </div>

    <!-- AJAX Messages පෙන්වීමට වෙන් කළ ස්ථානය -->
    <div id="ajaxMessageContainer">
        <!-- Backend error එකක් තිබුණොත් පෙන්වන්න (පළමු පූරණයේදී) -->
        <% if(request.getAttribute("errorMessage") != null) { %>
        <div class="bg-red-50 border border-red-200 rounded-lg p-3 mb-6 flex items-center gap-2">
            <svg class="w-4 h-4 text-red-500 shrink-0" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"/>
            </svg>
            <span class="text-red-600 text-sm"><%= request.getAttribute("errorMessage") %></span>
        </div>
        <% } %>
    </div>

    <!-- Form Card -->
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-8">
        <!-- Form එකට ID එකක් ලබා දී ඇත (id="registerForm") -->
        <form id="registerForm" action="auth?action=register" method="POST" class="space-y-5">

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                <div>
                    <label class="block text-slate-700 text-sm font-medium mb-2">First Name *</label>
                    <input type="text" name="firstName" required placeholder="John"
                           class="input-focus w-full border border-slate-300 rounded-lg px-4 py-3 text-sm
                                      text-slate-800 placeholder-slate-400 transition-all hover:border-slate-400 focus:border-brand-500">
                </div>
                <div>
                    <label class="block text-slate-700 text-sm font-medium mb-2">Last Name</label>
                    <input type="text" name="lastName" placeholder="Doe"
                           class="input-focus w-full border border-slate-300 rounded-lg px-4 py-3 text-sm
                                      text-slate-800 placeholder-slate-400 transition-all hover:border-slate-400 focus:border-brand-500">
                </div>
            </div>

            <div>
                <label class="block text-slate-700 text-sm font-medium mb-2">Email Address *</label>
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                        </svg>
                    </div>
                    <input type="email" name="email" required placeholder="johndoe@example.com"
                           class="input-focus w-full border border-slate-300 rounded-lg pl-10 pr-4 py-3 text-sm
                                      text-slate-800 placeholder-slate-400 transition-all hover:border-slate-400 focus:border-brand-500">
                </div>
            </div>

            <div>
                <label class="block text-slate-700 text-sm font-medium mb-2">Password *</label>
                <div class="relative">
                    <input type="password" name="password" id="password" required
                           placeholder="Create a strong password"
                           class="input-focus w-full border border-slate-300 rounded-lg px-4 pr-12 py-3 text-sm
                                      text-slate-800 placeholder-slate-400 transition-all hover:border-slate-400 focus:border-brand-500">
                    <button type="button" onclick="togglePassword('password')"
                            class="absolute inset-y-0 right-0 pr-3 flex items-center text-slate-400 hover:text-slate-600">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M15 12a3 3 0 11-6 0 3 3 0 016 0zM2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                        </svg>
                    </button>
                </div>
                <!-- Password strength -->
                <div class="mt-2 flex gap-1" id="strengthBars">
                    <div class="h-1 flex-1 rounded bg-slate-200" id="bar1"></div>
                    <div class="h-1 flex-1 rounded bg-slate-200" id="bar2"></div>
                    <div class="h-1 flex-1 rounded bg-slate-200" id="bar3"></div>
                    <div class="h-1 flex-1 rounded bg-slate-200" id="bar4"></div>
                </div>
                <p class="text-xs text-slate-400 mt-1" id="strengthText">Enter password to check strength</p>
            </div>

            <!-- Submit -->
            <div class="pt-4">
                <button type="submit" id="submitBtn"
                        class="w-full bg-brand-500 hover:bg-brand-600 text-white font-semibold py-3.5 rounded-lg
                                   transition-all duration-200 text-sm shadow-lg shadow-brand-500/25 active:scale-[0.98] flex items-center justify-center gap-2">
                    <span>Register</span>
                </button>
            </div>
        </form>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/register.js"></script>
</body>
</html>