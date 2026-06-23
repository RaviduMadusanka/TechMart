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
            <tbody class="text-sm divide-y divide-slate-100">
            <tr class="hover:bg-slate-50/80 transition-colors group">
                <td class="py-4 px-5">
                    <p class="font-bold text-slate-800 text-sm">Test Laptop DTO</p>
                    <p class="text-slate-400 text-xs mt-0.5 font-mono">PROD-1781877694376</p>
                </td>
                <td class="py-4 px-5">
                    <p class="text-slate-600 truncate max-w-[150px]" title="High performance gaming laptop">High performance gaming...</p>
                </td>
                <td class="py-4 px-5">
                    <div class="flex flex-col gap-1">
                        <span class="text-slate-800 font-bold">250,000.00 <span class="text-[10px] text-slate-400 font-normal uppercase">(Sell)</span></span>
                        <span class="text-slate-500 text-xs">200,000.00 <span class="text-[10px] text-slate-400 uppercase">(Cost)</span></span>
                    </div>
                </td>
                <td class="py-4 px-5">
                    <span class="bg-slate-100 text-slate-600 px-2.5 py-1 rounded-md text-xs font-medium border border-slate-200">2.5 kg</span>
                </td>
                <td class="py-4 px-5">
                    <div class="flex flex-col gap-1 text-xs">
                        <span class="text-brand-600 font-medium"><span class="text-slate-400 font-normal">Cat:</span> Laptops</span>
                        <span class="text-brand-600 font-medium"><span class="text-slate-400 font-normal">Br:</span> Asus</span>
                    </div>
                </td>
                <td class="py-4 px-5">
                        <span class="inline-flex items-center gap-1.5 bg-green-50 text-green-700 px-3 py-1 rounded-full text-xs font-semibold border border-green-200">
                            <span class="w-1.5 h-1.5 bg-green-500 rounded-full"></span> Active
                        </span>
                </td>
                <td class="py-4 px-5 text-right">
                    <button class="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors" title="Edit">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path></svg>
                    </button>
                    <button class="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors" title="Delete">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                    </button>
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <div class="flex items-center justify-between mt-6">
        <p class="text-sm text-slate-500">Showing <span class="font-medium text-slate-700">1</span> to <span class="font-medium text-slate-700">1</span> of <span class="font-medium text-slate-700">1</span> results</p>
        <div class="flex gap-2">
            <button class="px-3 py-1.5 border border-slate-200 text-slate-400 rounded-lg text-sm font-medium cursor-not-allowed">Previous</button>
            <button class="px-3 py-1.5 bg-brand-50 text-brand-600 rounded-lg text-sm font-medium">1</button>
            <button class="px-3 py-1.5 border border-slate-200 text-slate-400 rounded-lg text-sm font-medium cursor-not-allowed">Next</button>
        </div>
    </div>
</div>
<div id="addProductModal" class="hidden fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-50 flex items-center justify-center p-4 transition-opacity duration-300 opacity-0">

    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-3xl overflow-hidden transform scale-95 transition-transform duration-300" id="modalBox">

        <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-brand-100 text-brand-600 rounded-lg flex items-center justify-center">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path></svg>
                </div>
                <div>
                    <h3 class="text-xl font-bold text-slate-800">Add New Product</h3>
                    <p class="text-xs text-slate-500">Fill in the details to add a product to the catalog.</p>
                </div>
            </div>
            <button onclick="closeAddProductModal()" class="text-slate-400 hover:text-slate-600 bg-white p-2 rounded-full hover:bg-slate-200 transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
            </button>
        </div>

        <div id="modalMessageContainer" class="px-6 pt-4"></div>

        <form id="addProductForm" enctype="multipart/form-data">

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
                        <input type="file" name="primaryImage" accept="image/*" required class="block w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-brand-50 file:text-brand-700 hover:file:bg-brand-100 border border-slate-200 rounded-lg p-1 cursor-pointer transition-all">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Secondary Image (Optional)</label>
                        <input type="file" name="secondaryImage" accept="image/*" class="block w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-slate-100 file:text-slate-700 hover:file:bg-slate-200 border border-slate-200 rounded-lg p-1 cursor-pointer transition-all">
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

                </div>
            </div>

            <div class="p-6 border-t border-slate-100 flex justify-end gap-3 bg-slate-50">
                <button type="button" onclick="closeAddProductModal()" class="px-5 py-2.5 rounded-lg border border-slate-300 text-slate-700 font-semibold hover:bg-slate-100 transition-colors text-sm">
                    Cancel
                </button>
                <button type="submit" id="saveProductBtn" class="px-5 py-2.5 rounded-lg bg-brand-500 hover:bg-brand-600 text-white font-semibold shadow-md shadow-brand-500/30 transition-all active:scale-95 flex items-center gap-2 text-sm">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                    <span>Save Product</span>
                </button>
            </div>

        </form>

    </div>
</div>
<script>
    const modal = document.getElementById('addProductModal');
    const modalBox = document.getElementById('modalBox');
    const addProductForm = document.getElementById('addProductForm');
    const modalMessageContainer = document.getElementById('modalMessageContainer');
    const saveProductBtn = document.getElementById('saveProductBtn');
    const originalBtnContent = saveProductBtn.innerHTML;

    function openAddProductModal() {
        modalMessageContainer.innerHTML = '';

        fetch('api/products?action=get_categories')
            .then(response => response.json())
            .then(data => {
                const categorySelect = document.getElementById('categorySelect');
                categorySelect.innerHTML = '<option value="">Select Category...</option>';
                data.forEach(category => {
                    const option = document.createElement('option');
                    option.value = category.categoryId;
                    option.text = category.name;
                    categorySelect.appendChild(option);
                });
            })
            .catch(err => console.error("Error loading categories", err));

        fetch('api/products?action=get_brands')
            .then(response => response.json())
            .then(data => {
                const brandSelect = document.getElementById('brandSelect');
                brandSelect.innerHTML = '<option value="">Select Brand...</option>';
                data.forEach(brand => {
                    const option = document.createElement('option');
                    option.value = brand.brandId;
                    option.text = brand.name;
                    brandSelect.appendChild(option);
                });
            })
            .catch(err => console.error("Error loading brands", err));

        modal.classList.remove('hidden');
        setTimeout(() => {
            modal.classList.remove('opacity-0');
            modalBox.classList.remove('scale-95');
            modalBox.classList.add('scale-100');
        }, 10);
    }

    function closeAddProductModal() {
        modal.classList.add('opacity-0');
        modalBox.classList.remove('scale-100');
        modalBox.classList.add('scale-95');
        setTimeout(() => {
            modal.classList.add('hidden');
            addProductForm.reset();
        }, 300);
    }

    modal.addEventListener('click', function(event) {
        if (event.target === modal) {
            closeAddProductModal();
        }
    });

    addProductForm.addEventListener('submit', function(event) {

        event.preventDefault();

        saveProductBtn.innerHTML = `
            <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            <span>Saving...</span>
        `;
        saveProductBtn.disabled = true;
        saveProductBtn.classList.add('opacity-75', 'cursor-not-allowed');
        modalMessageContainer.innerHTML = '';

        const formData = new FormData(this);

        fetch('${pageContext.request.contextPath}/ProductServlet?action=add', {
            method: 'POST',
            body: formData
        })
            .then(response => {
                if (response.ok) {
                    return response.text();
                } else {
                    throw new Error("Failed to save product.");
                }
            })
            .then(message => {
                modalMessageContainer.innerHTML = `
                <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg flex items-center gap-2 mb-4">
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>
                    <span class="text-sm font-medium">` + message + `</span>
                </div>
            `;

                setTimeout(() => {
                    closeAddProductModal();
                }, 1500);

            })
            .catch(error => {
                modalMessageContainer.innerHTML = `
                <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg flex items-center gap-2 mb-4">
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path></svg>
                    <span class="text-sm font-medium">` + error.message + `</span>
                </div>
            `;
            })
            .finally(() => {
                saveProductBtn.innerHTML = originalBtnContent;
                saveProductBtn.disabled = false;
                saveProductBtn.classList.remove('opacity-75', 'cursor-not-allowed');
            });

    });
</script>