
<div class="bg-white p-8 rounded-2xl shadow-sm">

    <div class="flex flex-col md:flex-row justify-between gap-4 mb-6">
        <div>
            <h2 class="text-xl font-bold text-slate-800">Order Management</h2>
            <p class="text-sm text-slate-500">Manage and update customer orders.</p>
        </div>

        <div class="flex flex-col md:flex-row gap-3">
            <input type="text"
                   placeholder="Search Orders..."
                   class="bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500/20 w-full md:w-64">

            <button class="border border-slate-300 text-slate-700 hover:bg-slate-50 font-semibold py-2 px-5 rounded-xl whitespace-nowrap transition-colors">
                📥 Export CSV
            </button>
        </div>
    </div>

    <div class="overflow-x-auto border border-slate-200 rounded-xl">
        <table class="w-full text-left border-collapse whitespace-nowrap">
            <thead>
            <tr class="bg-slate-50 text-slate-500 text-xs uppercase tracking-wider">
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Order ID</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Customer</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Date</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Total (Rs.)</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Status</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200 text-right">Action</th>
            </tr>
            </thead>

            <tbody id="orderTableBody" class="text-sm divide-y divide-slate-100">
            <tr>
                <td colspan="6" class="text-center py-10">
                    <div class="animate-spin w-8 h-8 border-4 border-brand-500 border-t-transparent rounded-full mx-auto"></div>
                    <p class="text-slate-500 mt-2 font-medium">Loading orders...</p>
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <div id="orderOverlay"
         class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-40 hidden transition-opacity"
         onclick="closeOrderPanel()">
    </div>

    <div id="orderPanel"
         class="fixed top-0 right-0 w-full md:w-[500px] h-full bg-white shadow-2xl z-50
            translate-x-full transition-transform duration-300 overflow-y-auto">

        <div class="sticky top-0 bg-white border-b border-slate-200 p-6 flex justify-between items-center">
            <div>
                <h2 class="text-2xl font-bold text-slate-800">
                    Order Details
                </h2>
                <p class="text-sm text-slate-500" id="panelOrderId">
                    Order #ORD-...
                </p>
            </div>

            <button onclick="closeOrderPanel()"
                    class="text-3xl text-slate-500 hover:text-red-500">
                &times;
            </button>
        </div>

        <div class="p-6 space-y-8">
            <div>
                <h3 class="font-bold text-lg mb-4 text-slate-800">
                    Customer Information
                </h3>
                <div class="bg-slate-50 rounded-xl p-5 space-y-3">
                    <div class="flex justify-between">
                        <span class="text-slate-500">Name</span>
                        <span class="font-semibold" id="customerName">Loading...</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-slate-500">Email</span>
                        <span class="font-semibold" id="customerEmail">Loading...</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-slate-500">Phone</span>
                        <span class="font-semibold" id="customerPhone">Loading...</span>
                    </div>
                </div>
            </div>
            <div>
                <h3 class="font-bold text-lg mb-4 text-slate-800">
                    Shipping Address
                </h3>
                <div class="bg-slate-50 rounded-xl p-5" id="shippingAddress">
                    Loading address...
                </div>
            </div>

            <div class="border-t pt-5">
                <div class="flex justify-between text-lg font-bold">
                    <span>Total Amount</span>
                    <span id="paymentTotal">Rs. 0.00</span>
                </div>
            </div>
        </div>
    </div>


    <div id="updateModal"
         class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm hidden justify-center items-center z-50 transition-opacity">

        <div class="bg-white w-full max-w-md rounded-2xl shadow-2xl p-6 mx-4 transform transition-all">
            <div class="flex justify-between items-center mb-6">
                <div>
                    <h2 class="text-xl font-bold text-slate-800">Update Order</h2>
                    <p class="text-xs text-slate-500">Order #ORD-1001</p>
                </div>
                <button onclick="closeUpdateModal()" class="text-2xl text-slate-400 hover:text-red-500 w-8 h-8 flex items-center justify-center rounded-full hover:bg-slate-100">
                    &times;
                </button>
            </div>

            <div class="space-y-4">
                <div>
                    <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Order Status</label>
                    <select id="orderStatus" class="w-full bg-slate-50 border border-slate-200 rounded-xl p-3 text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500">
                        <option value="">Loading...</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Payment Status</label>
                    <select class="w-full bg-slate-50 border border-slate-200 rounded-xl p-3 text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500">
                        <option value="Paid">Paid</option>
                        <option value="Unpaid">Unpaid</option>
                        <option value="Refunded">Refunded</option>
                    </select>
                </div>

                <div class="pt-4 flex gap-3">
                    <button onclick="closeUpdateModal()" class="w-1/2 px-4 py-2.5 rounded-xl border border-slate-200 text-slate-600 font-semibold hover:bg-slate-50 transition-colors text-sm">
                        Cancel
                    </button>
                    <button onclick="saveOrderStatus()" class="w-1/2 px-4 py-2.5 rounded-xl bg-brand-500 hover:bg-brand-600 text-white font-semibold shadow-md shadow-brand-500/30 transition-all text-sm">
                        Save Changes
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

    <script>
        if (typeof CONTEXT_PATH === 'undefined') {
            var CONTEXT_PATH = '${pageContext.request.contextPath}';
        }
    </script>
    <script src="${pageContext.request.contextPath}/js/orders-content.js"></script>