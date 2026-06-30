<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Processing Payment...</title>
    <script type="text/javascript" src="https://www.payhere.lk/lib/payhere.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 flex items-center justify-center h-screen">

<div class="bg-white p-8 rounded-xl shadow-sm border border-gray-200 text-center">
    <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-brand-600 mx-auto mb-4"></div>
    <h2 class="text-xl font-bold text-gray-800">Initializing Secure Payment...</h2>
    <p class="text-sm text-gray-500 mt-2">Please do not refresh the page.</p>
</div>

<script>

    var payment = {
        "sandbox": true,
        "merchant_id": "<%= request.getAttribute("merchantId") %>",

        "return_url": "http://localhost:8080/TechMart/order-success",
        "cancel_url": "http://localhost:8080/TechMart/cart.jsp",
        "notify_url": "http://localhost:8080/TechMart/PayHereNotifyServlet",

        "order_id": "<%= request.getAttribute("orderId") %>",
        "items": "TechMart Order <%= request.getAttribute("orderId") %>",
        "amount": "<%= request.getAttribute("amount") %>",
        "currency": "<%= request.getAttribute("currency") %>",
        "hash": "<%= request.getAttribute("hash") %>",

        "first_name": "<%= request.getAttribute("firstName") %>",
        "last_name": "<%= request.getAttribute("lastName") %>",
        "email": "<%= request.getAttribute("email") %>",
        "phone": "<%= request.getAttribute("phone") %>",
        "address": "<%= request.getAttribute("address") %>",
        "city": "<%= request.getAttribute("city") %>",
        "country": "<%= request.getAttribute("country") %>",

        "delivery_address": "<%= request.getAttribute("address") %>",
        "delivery_city": "<%= request.getAttribute("city") %>",
        "delivery_country": "<%= request.getAttribute("country") %>",
        "custom_1": "",
        "custom_2": ""
    };

    payhere.onCompleted = function onCompleted(orderId) {
        console.log("Payment completed. OrderID:" + orderId);
        window.location.href = "order-success?orderId=" + orderId;
    };

    payhere.onDismissed = function onDismissed() {
        console.log("Payment dismissed");
        window.location.href = "cart.jsp";
    };

    payhere.onError = function onError(error) {
        console.log("Error:"  + error);
        alert("Payment failed: " + error);
        window.location.href = "cart.jsp";
    };

    window.onload = function() {
        payhere.startPayment(payment);
    };
</script>
</body>
</html>