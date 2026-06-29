<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Redirecting to Secure Payment...</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .spinner { border: 4px solid rgba(0, 0, 0, 0.1); border-left-color: #3b5bdb; border-radius: 50%; width: 50px; height: 50px; animation: spin 1s linear infinite; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</head>
<body class="flex items-center justify-center h-screen">

<div class="text-center bg-white p-10 rounded-2xl shadow-lg border border-gray-100 max-w-sm w-full">
    <div class="flex justify-center mb-6">
        <div class="spinner"></div>
    </div>
    <h2 class="text-xl font-bold text-gray-800 mb-2">Secure Checkout</h2>
    <p class="text-gray-500 text-sm">Please wait while we redirect you to the PayHere secure payment gateway...</p>
    <p class="text-xs text-gray-400 mt-6">Do not close this window.</p>
</div>

<form id="payhereForm" method="post" action="https://sandbox.payhere.lk/pay/checkout">

    <input type="hidden" name="merchant_id" value="${merchantId}">
    <input type="hidden" name="return_url" value="http://localhost:8080/TechMart/order-success.jsp">
    <input type="hidden" name="cancel_url" value="http://localhost:8080/TechMart/cart.jsp">
    <input type="hidden" name="notify_url" value="http://localhost:8080/TechMart/api/payhere-notify">

    <input type="hidden" name="order_id" value="${orderId}">
    <input type="hidden" name="items" value="TechMart Order #${orderId}">
    <input type="hidden" name="currency" value="${currency}">
    <input type="hidden" name="amount" value="${amount}">
    <input type="hidden" name="hash" value="${hash}">

    <input type="hidden" name="first_name" value="${firstName}">
    <input type="hidden" name="last_name" value="${lastName}">
    <input type="hidden" name="email" value="${email}">
    <input type="hidden" name="phone" value="0771234567">
    <input type="hidden" name="address" value="No. 1, TechMart Road">
    <input type="hidden" name="city" value="Colombo">
    <input type="hidden" name="country" value="Sri Lanka">
</form>

<script>
    setTimeout(function() {
        document.getElementById('payhereForm').submit();
    }, 1500);
</script>
</body>
</html>