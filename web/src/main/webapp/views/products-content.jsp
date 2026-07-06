<div class="bg-white p-8 rounded-2xl shadow-sm relative">

    <div class="flex flex-col md:flex-row justify-between items-center mb-6 gap-4">
        <div class="relative w-full md:w-80">
            <input type="text" placeholder="Search by product code or name..." class="w-full bg-slate-50 border border-slate-200 rounded-xl pl-10 pr-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500 transition-all">
            <span class="absolute left-3 top-3 text-slate-400">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
            </span>
        </div>
        <button onclick="openAddProductModal()" class="w-full md:w-auto bg-brand-500 hover:bg-brand-600 text-white font-semibold py-2.5 px-5 rounded-xl transition-all shadow-sm flex items-center justify-center gap-2 active:scale-95">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>
            <span>Add New Product</span>
        </button>
    </div>

    <div class="overflow-x-auto border border-slate-200 rounded-xl">
        <table class="w-full text-left border-collapse whitespace-nowrap">
            <thead>
            <tr class="bg-slate-50 text-slate-500 text-xs uppercase tracking-wider">
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Product Info</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Description</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Pricing (Rs.)</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Specs</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Category & Brand</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Status</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200 text-right">Actions</th>
            </tr>
            </thead>
            <tbody id="productsTableBody" class="text-sm divide-y divide-slate-100">
            <tr>
                <td colspan="7" class="text-center py-10">
                    <div class="animate-spin w-8 h-8 border-4 border-brand-500 border-t-transparent rounded-full mx-auto"></div>
                    <p class="text-slate-500 mt-2 font-medium">Loading products...</p>
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <div class="flex items-center justify-between mt-6">
        <p class="text-sm text-slate-500">Showing <span id="pageStart" class="font-medium text-slate-700">0</span> to <span id="pageEnd" class="font-medium text-slate-700">0</span> of <span id="pageTotal" class="font-medium text-slate-700">0</span> results</p>
        <div class="flex gap-2">
            <button id="btnPrev" onclick="prevPage()" disabled class="px-3 py-1.5 border border-slate-200 text-slate-400 rounded-lg text-sm font-medium cursor-not-allowed transition-colors">Previous</button>
            <button id="btnCurrentPage" class="px-3 py-1.5 bg-brand-50 text-brand-600 rounded-lg text-sm font-medium">1</button>
            <button id="btnNext" onclick="nextPage()" disabled class="px-3 py-1.5 border border-slate-200 text-slate-400 rounded-lg text-sm font-medium cursor-not-allowed transition-colors">Next</button>
        </div>
    </div>
</div>

<div id="addProductModal" class="hidden fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-50 flex items-center justify-center p-4 transition-opacity duration-300 opacity-0">

    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-3xl overflow-hidden transform scale-95 transition-transform duration-300" id="modalBox">

        <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-brand-100 text-brand-600 rounded-lg flex items-center justify-center" id="modalIcon">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path></svg>
                </div>
                <div>
                    <h3 id="modalTitle" class="text-xl font-bold text-slate-800">Add New Product</h3>
                    <p id="modalSubtitle" class="text-xs text-slate-500">Fill in the details to add a product to the catalog.</p>
                </div>
            </div>
            <button onclick="closeAddProductModal()" class="text-slate-400 hover:text-slate-600 bg-white p-2 rounded-full hover:bg-slate-200 transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
            </button>
        </div>

        <div id="modalMessageContainer" class="px-6 pt-4"></div>

        <form id="addProductForm" enctype="multipart/form-data">
            <input type="hidden" id="productId" name="productId" value="">
            <input type="hidden" id="formAction" name="formAction" value="add">

            <div class="p-6 max-h-[60vh] overflow-y-auto">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">

                    <div class="col-span-2">
                        <h4 class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3">Basic Information</h4>
                    </div>

                    <div class="col-span-2">
                        <label class="block text-sm font-medium text-slate-700 mb-1">Product Name *</label>
                        <input type="text" name="productName" required class="w-full bg-white border border-slate-300 rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500">
                    </div>

                    <div class="col-span-2">
                        <label class="block text-sm font-medium text-slate-700 mb-1">Description</label>
                        <textarea name="description" rows="3" class="w-full bg-white border border-slate-300 rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500"></textarea>
                    </div>

                    <div class="col-span-2 mt-2">
                        <h4 class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3">Product Images</h4>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Primary Image (Cover) *</label>
                        <input type="file" id="primaryImage" name="primaryImage" accept="image/*" required class="block w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-brand-50 file:text-brand-700 hover:file:bg-brand-100 border border-slate-200 rounded-lg p-1 cursor-pointer transition-all">
                        <p id="imageHelpText" class="text-xs text-slate-400 mt-1 hidden">Leave empty to keep existing image</p>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Secondary Image (Optional)</label>
                        <input type="file" name="secondaryImage" accept="image/*" class="block w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-slate-100 file:text-slate-700 hover:file:bg-slate-200 border border-slate-200 rounded-lg p-1 cursor-pointer transition-all">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Third Image (Optional)</label>
                        <input type="file" name="thirdImage" accept="image/*" class="block w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-slate-100 file:text-slate-700 hover:file:bg-slate-200 border border-slate-200 rounded-lg p-1 cursor-pointer transition-all">
                    </div>

                    <div class="col-span-2 mt-2">
                        <h4 class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3">Pricing & Specs</h4>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Selling Price (Rs.) *</label>
                        <input type="number" step="0.01" name="price" required class="w-full bg-white border border-slate-300 rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500 font-mono">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Cost Price (Rs.)</label>
                        <input type="number" step="0.01" name="costPrice" class="w-full bg-white border border-slate-300 rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500 font-mono">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Weight (kg)</label>
                        <input type="number" step="0.01" name="weight" class="w-full bg-white border border-slate-300 rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500 font-mono">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Status</label>
                        <select name="statusId" class="w-full bg-white border border-slate-300 rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500 appearance-none">
                            <option value="1">Active</option>
                            <option value="2">Inactive</option>
                            <option value="3">Out of Stock</option>
                        </select>
                    </div>

                    <div class="col-span-2 mt-2">
                        <h4 class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3">Categorization</h4>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Category</label>
                        <select id="categorySelect" name="categoryId" class="w-full bg-white border border-slate-300 rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500">
                            <option value="">Loading Categories...</option>
                        </select>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Brand</label>
                        <select id="brandSelect" name="brandId" class="w-full bg-white border border-slate-300 rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500">
                            <option value="">Loading Brands...</option>
                        </select>
                    </div>

                    <!-- Inventory Details Section -->
                    <div id="inventorySectionContainer" class="col-span-2 grid grid-cols-1 md:grid-cols-2 gap-5 mt-2 pt-4 border-t border-slate-100">
                        <div class="col-span-2">
                            <h4 class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3">Inventory Details</h4>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-1">Initial Quantity *</label>
                            <input type="number" id="qtyInput" name="quantity" required min="0" class="w-full bg-white border border-slate-300 rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500 font-mono" placeholder="0">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-1">Select Warehouse *</label>
                            <div class="relative">
                                <select id="warehouseSelect" name="warehouseId" required class="w-full bg-white border border-slate-300 rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500 appearance-none">
                                    <option value="">Loading Warehouses...</option>
                                </select>
                                <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-4 text-slate-500">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <div class="p-6 border-t border-slate-100 flex justify-end gap-3 bg-slate-50">
                <button type="button" onclick="closeAddProductModal()" class="px-5 py-2.5 rounded-lg border border-slate-300 text-slate-700 font-semibold hover:bg-slate-100 transition-colors text-sm">
                    Cancel
                </button>
                <button type="submit" id="saveProductBtn" class="px-5 py-2.5 rounded-lg bg-brand-500 hover:bg-brand-600 text-white font-semibold shadow-md shadow-brand-500/30 transition-all active:scale-95 flex items-center gap-2 text-sm">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                    <span id="btnText">Save Product</span>
                </button>
            </div>

        </form>

    </div>
</div>

<script>
    const CONTEXT_PATH = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/products-content.js"></script>