<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechMart Admin Portal</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: {
                            50: '#f0f4ff',
                            100: '#e0e9ff',
                            500: '#3b5bdb',
                            600: '#2f4cc8',
                            700: '#2341b0',
                            800: '#1a3090',
                            900: '#0f1f6b',
                        },
                        accent: '#f59f00',
                    },
                    fontFamily: {
                        display: ['Georgia', 'serif'],
                        body: ['Inter', 'system-ui', 'sans-serif'],
                    }
                }
            }
        }
    </script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        .grid-bg {
            background-image: linear-gradient(rgba(59,91,219,0.07) 1px, transparent 1px),
            linear-gradient(90deg, rgba(59,91,219,0.07) 1px, transparent 1px);
            background-size: 40px 40px;
        }
        .input-focus:focus { box-shadow: 0 0 0 3px rgba(59,91,219,0.2); }
        @keyframes slideUp { from { opacity:0; transform:translateY(24px);} to { opacity:1; transform:translateY(0);} }
        .slide-up { animation: slideUp 0.5s ease forwards; }
    </style>
</head>
<body class="min-h-screen bg-slate-950 grid-bg flex items-center justify-center p-4">

<div class="fixed inset-0 overflow-hidden pointer-events-none">
    <div class="absolute -top-40 -right-40 w-96 h-96 bg-brand-600 rounded-full opacity-10 blur-3xl"></div>
    <div class="absolute -bottom-40 -left-40 w-96 h-96 bg-accent rounded-full opacity-10 blur-3xl"></div>
</div>

<div class="w-full max-w-md slide-up">
    <div class="text-center mb-8">
        <div class="inline-flex items-center gap-3 mb-4">
            <div class="w-10 h-10 bg-brand-500 rounded-lg flex items-center justify-center">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
                </svg>
            </div>
            <span class="text-white font-display text-2xl font-bold tracking-tight">TechMart</span>
        </div>
        <div class="inline-block bg-brand-900/60 border border-brand-700/50 rounded-full px-4 py-1 mb-2">
            <span class="text-brand-300 text-xs font-semibold uppercase tracking-widest">Admin Portal</span>
        </div>
        <p class="text-slate-400 text-sm mt-2">Secure access for administrators only</p>
    </div>

    <div class="bg-slate-900 border border-slate-700/60 rounded-2xl p-8 shadow-2xl">
        <h2 class="text-white text-xl font-semibold mb-6">Sign in to Dashboard</h2>
        <div id="ajaxMessageContainer">
            <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="bg-red-500/10 border border-red-500/30 rounded-lg p-3 mb-5 flex items-center gap-2">
                <svg class="w-4 h-4 text-red-400 shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"/>
                </svg>
                <span class="text-red-400 text-sm"><%= request.getAttribute("errorMessage") %></span>
            </div>
            <% } %>
        </div>

        <form id="adminLoginForm" action="admin-auth" method="post" class="space-y-5">
            <!-- Username / Email -->
            <div>
                <label class="block text-slate-300 text-sm font-medium mb-2" for="email">Admin Username (Email)</label>
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <svg class="w-4 h-4 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                    </div>
                    <input type="text" id="email" name="email" required
                           placeholder="admin@techmart.com"
                           class="input-focus w-full bg-slate-800 border border-slate-600 rounded-lg pl-10 pr-4 py-3
                                      text-white placeholder-slate-500 text-sm outline-none transition-all
                                      focus:border-brand-500 focus:bg-slate-800"
                           value="${param.email}">
                </div>
            </div>

            <div>
                <label class="block text-slate-300 text-sm font-medium mb-2" for="password">Password</label>
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <svg class="w-4 h-4 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                        </svg>
                    </div>
                    <input type="password" id="password" name="password" required
                           placeholder="Enter password"
                           class="input-focus w-full bg-slate-800 border border-slate-600 rounded-lg pl-10 pr-12 py-3
                                      text-white placeholder-slate-500 text-sm outline-none transition-all
                                      focus:border-brand-500">
                    <button type="button" onclick="togglePassword('password', this)"
                            class="absolute inset-y-0 right-0 pr-3 flex items-center text-slate-500 hover:text-slate-300">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                        </svg>
                    </button>
                </div>
            </div>

            <div class="flex items-center justify-between">
                <label class="flex items-center gap-2 cursor-pointer">
                    <input type="checkbox" name="rememberMe"
                           class="w-4 h-4 rounded border-slate-600 bg-slate-800 text-brand-500 accent-brand-500">
                    <span class="text-slate-400 text-sm">Remember me</span>
                </label>
                <a href="#" class="text-brand-400 text-sm hover:text-brand-300 transition-colors">Forgot password?</a>
            </div>

            <!-- Submit Button configured for Loading Spinner -->
            <button type="submit" id="submitBtn"
                    class="w-full bg-brand-500 hover:bg-brand-600 text-white font-semibold py-3 rounded-lg
                               transition-all duration-200 text-sm tracking-wide shadow-lg shadow-brand-500/20
                               active:scale-[0.98] flex items-center justify-center gap-2">
                <span>Sign In to Admin Panel</span>
            </button>
        </form>

        <div class="mt-6 pt-5 border-t border-slate-700/60 text-center">
            <p class="text-slate-500 text-xs">
                Not an admin?
                <a href="auth?action=login"
                   class="text-brand-400 hover:text-brand-300 transition-colors ml-1">Customer Login →</a>
            </p>
        </div>
    </div>


    <div class="mt-4 flex items-center justify-center gap-2 text-slate-600 text-xs">
        <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z"/>
        </svg>
        <span>Secured with Java EE Session Management &amp; EJB Authentication</span>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/admin-login.js"></script>
</body>
</html>