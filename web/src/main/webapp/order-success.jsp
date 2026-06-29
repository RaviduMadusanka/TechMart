<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("pageTitle", "Order Successful - TechMart"); %>
<%@ include file="WEB-INF/includes/header.jsp" %>

<main class="flex-1 bg-gray-50 flex items-center justify-center py-20">
    <div class="bg-white p-10 rounded-2xl shadow-lg border border-gray-200 max-w-md w-full text-center">

        <div class="w-20 h-20 bg-green-100 text-green-600 rounded-full flex items-center justify-center mx-auto mb-6">
            <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path>
            </svg>
        </div>

        <h1 class="text-3xl font-bold text-gray-800 mb-2">Payment Successful!</h1>
        <p class="text-gray-500 mb-8">Thank you for your purchase. Your order <span class="font-bold text-gray-700">#ORD-${param.order_id}</span> has been placed successfully and is currently being processed.</p>

        <div class="bg-gray-50 rounded-xl p-4 mb-8 text-sm text-left text-gray-600 border border-gray-200">
            <p class="flex justify-between mb-2"><span>Transaction ID:</span> <span class="font-mono text-gray-900">${param.payment_id}</span></p>
            <p class="flex justify-between"><span>Amount Paid:</span> <span class="font-bold text-green-600">Rs. ${param.amount}</span></p>
        </div>

        <a href="home" class="block w-full bg-brand-600 hover:bg-brand-700 text-white font-bold py-3 px-4 rounded-xl transition-colors">
            Return to Home
        </a>
    </div>
</main>

<%@ include file="WEB-INF/includes/footer.jsp" %>