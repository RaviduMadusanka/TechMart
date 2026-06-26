
if (typeof CONTEXT_PATH === 'undefined') {
    var CONTEXT_PATH = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
}

let currentUpdateOrderId = null;

function loadOrders() {
    const tableBody = document.getElementById('orderTableBody');
    if (!tableBody) return;

    tableBody.innerHTML = `
        <tr>
            <td colspan="6" class="text-center py-10">
                <div class="animate-spin w-8 h-8 border-4 border-brand-500 border-t-transparent rounded-full mx-auto"></div>
                <p class="text-slate-500 mt-2 font-medium">Loading orders...</p>
            </td>
        </tr>
    `;

    fetch(CONTEXT_PATH + '/api/orders?action=get_all')
        .then(response => {
            if (!response.ok) throw new Error("Server Error");
            return response.json();
        })
        .then(data => {
            tableBody.innerHTML = '';

            if (data.length === 0) {
                tableBody.innerHTML = `
                    <tr>
                        <td colspan="6" class="text-center py-8 text-slate-500 font-medium">
                            No orders found in the database.
                        </td>
                    </tr>
                `;
                return;
            }

            data.forEach(order => {
                let statusHtml = '';
                const statusStr = order.status ? order.status.toUpperCase() : 'PENDING';

                if(statusStr === 'PENDING') {
                    statusHtml = `<span class="bg-yellow-100 text-yellow-700 px-3 py-1 rounded-full text-xs font-bold">Pending</span>`;
                } else if(statusStr === 'DELIVERED') {
                    statusHtml = `<span class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-bold">Delivered</span>`;
                } else if(statusStr === 'CANCELLED') {
                    statusHtml = `<span class="bg-red-100 text-red-700 px-3 py-1 rounded-full text-xs font-bold">Cancelled</span>`;
                } else {
                    statusHtml = `<span class="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-xs font-bold">${order.status}</span>`;
                }

                const total = order.totalAmount ? parseFloat(order.totalAmount).toLocaleString('en-US', {minimumFractionDigits: 2}) : '0.00';
                const customerName = order.customerName || 'Guest Customer';
                const orderDate = order.orderDate || 'N/A';

                const row = document.createElement('tr');
                row.className = 'hover:bg-slate-50 transition-colors group';
                row.innerHTML = `
                    <td class="py-4 px-5 border-b border-slate-100 font-bold text-brand-600">#ORD-${order.orderId}</td>
                    <td class="py-4 px-5 border-b border-slate-100 text-slate-700">${customerName}</td>
                    <td class="py-4 px-5 border-b border-slate-100 text-slate-500">${orderDate}</td>
                    <td class="py-4 px-5 border-b border-slate-100 font-semibold">${total}</td>
                    <td class="py-4 px-5 border-b border-slate-100">${statusHtml}</td>
                    <td class="py-4 px-5 border-b border-slate-100 text-right">
                        <div class="flex gap-2 justify-end">

                            <button onclick="openOrderPanel(${order.orderId})" class="bg-slate-800 hover:bg-slate-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold transition-all shadow-sm">View</button>

                            <button onclick="openUpdateModal(${order.orderId}, '${statusStr}')" class="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold transition-all shadow-sm">Update</button>
                        </div>
                    </td>
                `;
                tableBody.appendChild(row);
            });
        })
        .catch(error => {
            console.error("Error loading orders:", error);
            tableBody.innerHTML = `
                <tr>
                    <td colspan="6" class="text-center py-8 text-red-500 font-medium">
                        Failed to load orders! Please check your connection.
                    </td>
                </tr>
            `;
        });
}

document.addEventListener('DOMContentLoaded', loadOrders);

function openOrderPanel(orderId) {
    document.getElementById("orderPanel").classList.remove("translate-x-full");
    document.getElementById("orderOverlay").classList.remove("hidden");

    fetch(CONTEXT_PATH + '/api/orders?action=get_by_id&id=' + orderId)
        .then(response => response.json())
        .then(order => {
            document.getElementById("panelOrderId").innerText = "#ORD-" + order.orderId;
            document.getElementById("customerName").innerText = order.customerName;
            document.getElementById("customerEmail").innerText = order.customerEmail;
            document.getElementById("customerPhone").innerText = order.phone;
            document.getElementById("shippingAddress").innerHTML = order.shippingAddress;
            document.getElementById("paymentTotal").innerText = "Rs. " + parseFloat(order.totalAmount).toLocaleString();
        })
        .catch(error => console.error("Error:", error));
}

function closeOrderPanel() {
    document.getElementById("orderPanel").classList.add("translate-x-full");
    document.getElementById("orderOverlay").classList.add("hidden");
}

function loadOrderStatuses(selectedStatus = '') {
    const statusDropdown = document.getElementById("orderStatus");
    if (!statusDropdown) return;

    statusDropdown.innerHTML = '<option value="">Loading...</option>';

    fetch(CONTEXT_PATH + '/api/orders?action=get_statuses')
        .then(response => {
            if (!response.ok) throw new Error("API not ready");
            return response.json();
        })
        .then(data => {
            statusDropdown.innerHTML = '<option value="">Select Status...</option>';
            data.forEach(status => {
                const option = document.createElement('option');
                const statusName = status.statusName || status;

                option.value = statusName;
                option.text = statusName.charAt(0).toUpperCase() + statusName.slice(1).toLowerCase();

                if (statusName.toUpperCase() === selectedStatus.toUpperCase()) {
                    option.selected = true;
                }
                statusDropdown.appendChild(option);
            });
        })
        .catch(err => {
            console.error("Error loading status:", err);
            statusDropdown.innerHTML = `
                <option value="Pending" ${selectedStatus.toUpperCase() === 'PENDING' ? 'selected' : ''}>Pending</option>
                <option value="Processing" ${selectedStatus.toUpperCase() === 'PROCESSING' ? 'selected' : ''}>Processing</option>
                <option value="Shipped" ${selectedStatus.toUpperCase() === 'SHIPPED' ? 'selected' : ''}>Shipped</option>
                <option value="Delivered" ${selectedStatus.toUpperCase() === 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                <option value="Cancelled" ${selectedStatus.toUpperCase() === 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
            `;
        });
}

function openUpdateModal(orderId, currentStatus) {
    currentUpdateOrderId = orderId;

    const modal = document.getElementById("updateModal");
    modal.classList.remove("hidden");
    modal.classList.add("flex");

    loadOrderStatuses(currentStatus);
}

function closeUpdateModal() {
    currentUpdateOrderId = null;
    const modal = document.getElementById("updateModal");
    modal.classList.add("hidden");
    modal.classList.remove("flex");
}

function saveOrderStatus() {
    if (!currentUpdateOrderId) return;

    const newStatus = document.getElementById("orderStatus").value;
    if (!newStatus) {
        alert("Please select a status!");
        return;
    }

    fetch(CONTEXT_PATH + '/api/orders?action=update_status', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({
            'orderId': currentUpdateOrderId,
            'status': newStatus
        })
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                closeUpdateModal();
                loadOrders();
            } else {
                alert("Failed to update status: " + data.error);
            }
        })
        .catch(error => {
            console.error("Error updating order:", error);
            alert("Network Error!");
        });
}