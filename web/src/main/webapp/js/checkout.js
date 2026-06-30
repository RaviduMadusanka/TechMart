
    document.getElementById("checkoutForm").addEventListener("submit", function(e) {
    e.preventDefault();

    const submitBtn = document.querySelector('button[type="submit"]');
    submitBtn.innerHTML = "Processing...";
    submitBtn.disabled = true;

    let formData = new FormData(this);
    let params = new URLSearchParams(formData);

    fetch('checkout', {
    method: 'POST',
    headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
},
    body: params
})
    .then(async response => {
        if (!response.ok) {
            const errorData = await response.json().catch(() => ({error: "Network error!"}));
            throw new Error(errorData.error || "Server error occurred");
        }
        return response.json();
})
    .then(data => {
    var payment = {
    "sandbox": true,
    "merchant_id": data.merchantId,
    "return_url": "http://localhost:8080/techmart/home",
    "cancel_url": "http://localhost:8080/techmart/checkout.jsp",
    "notify_url": "http://localhost:8080/techmart/PayHereNotifyServlet",
    "order_id": data.orderId,
    "items": "TechMart Order",
    "amount": data.amount,
    "currency": data.currency,
    "hash": data.hash,
    "first_name": data.firstName,
    "last_name": data.lastName,
    "email": data.email,
    "phone": data.phone,
    "address": data.address,
    "city": data.city,
    "country": data.country
};

    payhere.onCompleted = function onCompleted(orderId) {
        console.log("Payment completed. OrderID:" + orderId);

        fetch('cart-action?action=clear&redirect=success&orderId=' + orderId)
            .then(() => {
                window.location.href = "order-success?orderId=" + orderId;
            })
            .catch(err => {
                window.location.href = "order-success?orderId=" + orderId;
            });
};
    payhere.onDismissed = function onDismissed() {
    console.log("Payment dismissed");
    submitBtn.innerHTML = "🔒 Place Order";
    submitBtn.disabled = false;
};

    payhere.onError = function onError(error) {
    console.log("Error:"  + error);
    alert("Payment failed: " + error);
    submitBtn.innerHTML = "🔒 Place Order";
    submitBtn.disabled = false;
};

    payhere.startPayment(payment);
})
    .catch(error => {
    console.error('Error:', error);
        alert("Checkout Failed: " + error.message);
    submitBtn.innerHTML = "🔒 Place Order";
    submitBtn.disabled = false;
});
});