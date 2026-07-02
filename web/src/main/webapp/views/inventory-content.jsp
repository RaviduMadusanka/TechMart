<div class="bg-white p-8 rounded-2xl shadow-sm">

    <!-- Top Bar (Search, Filters, and Save All button) -->
    <div class="flex flex-col md:flex-row justify-between items-center mb-6 gap-4">
        <div class="relative w-full md:w-96">
            <input type="text" placeholder="Search by product name or SKU..." class="w-full bg-slate-50 border border-slate-200 rounded-xl pl-10 pr-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500 transition-all text-slate-700">
            <span class="absolute left-3 top-3 text-slate-400">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
            </span>
        </div>

        <div class="flex items-center gap-3 w-full md:w-auto overflow-x-auto pb-2 md:pb-0">
            <button class="px-4 py-2 bg-brand-50 text-brand-600 font-semibold text-sm rounded-lg border border-brand-100 whitespace-nowrap">All</button>
            <button class="px-4 py-2 bg-white text-slate-600 font-medium text-sm rounded-lg border border-slate-200 hover:bg-slate-50 whitespace-nowrap">Low Stock</button>
            <button class="px-4 py-2 bg-white text-slate-600 font-medium text-sm rounded-lg border border-slate-200 hover:bg-slate-50 whitespace-nowrap">Out of Stock</button>

            <button class="ml-2 bg-brand-500 hover:bg-brand-600 text-white font-semibold py-2 px-5 rounded-lg transition-all shadow-sm flex items-center gap-2 whitespace-nowrap">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                Save All Changes
            </button>
        </div>
    </div>

    <div class="overflow-x-auto rounded-xl border border-slate-200">
        <table class="w-full text-left border-collapse whitespace-nowrap">
            <thead>
            <tr class="bg-slate-50 text-slate-500 text-xs uppercase tracking-wider">
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Product</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Category</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Price (Rs.)</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Stock Qty</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Level</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200 text-right">Status / Actions</th>
            </tr>
            </thead>
            <tbody id="inventoryTableBody" class="text-sm divide-y divide-slate-100">

            <tr class="hover:bg-slate-50/80 transition-colors group">
                <td class="py-3 px-5">
                    <div class="flex items-center gap-3">
                        <img src="${pageContext.request.contextPath}/images/placeholder.jpg" alt="Product" onerror="this.src='https://via.placeholder.com/40'; this.onerror=null;" class="w-10 h-10 rounded-lg object-cover border border-slate-200">
                        <div>
                            <p class="font-bold text-slate-800 text-sm">Galaxy S23 Ultra</p>
                            <p class="text-slate-400 text-xs mt-0.5">Samsung</p>
                        </div>
                    </div>
                </td>
                <td class="py-3 px-5 font-medium text-slate-600">Mobile</td>
                <td class="py-3 px-5">
                    <div class="bg-slate-100/50 border border-slate-200 rounded-lg px-3 py-1.5 inline-block text-slate-700 font-semibold font-mono text-xs">
                        Rs. 250,000
                    </div>
                </td>
                <td class="py-3 px-5">
                    <div class="flex items-center border border-slate-300 rounded-lg w-max bg-white shadow-sm overflow-hidden">
                        <button type="button" class="px-3 py-1.5 text-slate-500 hover:bg-slate-100 hover:text-slate-700 border-r border-slate-300 font-bold transition-colors">−</button>
                        <input type="text" class="w-12 text-center text-sm font-bold text-slate-800 outline-none bg-transparent" value="96">
                        <button type="button" class="px-3 py-1.5 text-slate-500 hover:bg-slate-100 hover:text-slate-700 border-l border-slate-300 font-bold transition-colors">+</button>
                    </div>
                </td>
                <td class="py-3 px-5">
                    <span class="inline-flex items-center gap-1.5 text-xs font-bold text-green-600 uppercase tracking-wide">
                        <span class="w-2 h-2 bg-green-500 rounded-full"></span> Active
                    </span>
                </td>
                <td class="py-3 px-5 text-right">
                    <div class="flex items-center justify-end gap-4">
                        <button class="text-slate-400 hover:text-red-500 transition-colors" title="Delete">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                        </button>
                        <button class="bg-brand-500 hover:bg-brand-600 text-white text-xs font-semibold px-4 py-2 rounded-lg transition-colors shadow-sm">
                            Update
                        </button>
                    </div>
                </td>
            </tr>

            <!-- Row 2 (Sample Data) -->
            <tr class="hover:bg-slate-50/80 transition-colors group">
                <td class="py-3 px-5">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-lg bg-slate-100 flex items-center justify-center text-slate-400 border border-slate-200">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                        </div>
                        <div>
                            <p class="font-bold text-slate-800 text-sm">MacBook Pro 16"</p>
                            <p class="text-slate-400 text-xs mt-0.5">Apple</p>
                        </div>
                    </div>
                </td>
                <td class="py-3 px-5 font-medium text-slate-600">Computer</td>
                <td class="py-3 px-5">
                    <div class="bg-slate-100/50 border border-slate-200 rounded-lg px-3 py-1.5 inline-block text-slate-700 font-semibold font-mono text-xs">
                        Rs. 850,000
                    </div>
                </td>
                <td class="py-3 px-5">
                    <div class="flex items-center border border-slate-300 rounded-lg w-max bg-white shadow-sm overflow-hidden">
                        <button type="button" class="px-3 py-1.5 text-slate-500 hover:bg-slate-100 hover:text-slate-700 border-r border-slate-300 font-bold transition-colors">−</button>
                        <input type="text" class="w-12 text-center text-sm font-bold text-red-600 outline-none bg-transparent" value="0">
                        <button type="button" class="px-3 py-1.5 text-slate-500 hover:bg-slate-100 hover:text-slate-700 border-l border-slate-300 font-bold transition-colors">+</button>
                    </div>
                </td>
                <td class="py-3 px-5">
                    <span class="inline-flex items-center gap-1.5 text-xs font-bold text-red-600 uppercase tracking-wide">
                        <span class="w-2 h-2 bg-red-500 rounded-full"></span> Deactive
                    </span>
                </td>
                <td class="py-3 px-5 text-right">
                    <div class="flex items-center justify-end gap-4">
                        <button class="text-slate-400 hover:text-red-500 transition-colors" title="Delete">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                        </button>
                        <button class="bg-brand-500 hover:bg-brand-600 text-white text-xs font-semibold px-4 py-2 rounded-lg transition-colors shadow-sm">
                            Update
                        </button>
                    </div>
                </td>
            </tr>

            </tbody>
        </table>
    </div>
</div>
<div id="toast" class="hidden fixed bottom-5 right-5 z-50 flex items-center gap-3 bg-white border border-slate-200 shadow-xl rounded-xl px-6 py-4 transition-all duration-300 transform translate-y-10">
    <div class="bg-green-100 text-green-600 p-2 rounded-full">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
    </div>
    <p id="toastMessage" class="text-sm font-semibold text-slate-700">Stock updated successfully!</p>
</div>
<script>
    const CONTEXT_PATH = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/inventory-content.js"></script>