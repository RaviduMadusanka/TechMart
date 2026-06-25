const modal = document.getElementById('addProductModal');
const modalBox = document.getElementById('modalBox');
const addProductForm = document.getElementById('addProductForm');
const modalMessageContainer = document.getElementById('modalMessageContainer');
const saveProductBtn = document.getElementById('saveProductBtn');
let originalBtnContent = '';
if(saveProductBtn) {
    originalBtnContent = saveProductBtn.innerHTML;
}

let allProductsList = [];
let currentPage = 1;
const itemsPerPage = 5;

function loadDropdowns(selectedCategoryId = '', selectedBrandId = '') {
    fetch(CONTEXT_PATH + '/api/products?action=get_categories')
        .then(response => response.json())
        .then(data => {
            const categorySelect = document.getElementById('categorySelect');
            if(categorySelect) {
                categorySelect.innerHTML = '<option value="">Select Category...</option>';
                data.forEach(category => {
                    const option = document.createElement('option');
                    option.value = category.categoryId;
                    option.text = category.name;
                    if(category.categoryId == selectedCategoryId) option.selected = true;
                    categorySelect.appendChild(option);
                });
            }
        })
        .catch(err => console.error("Error loading categories", err));

    fetch(CONTEXT_PATH + '/api/products?action=get_brands')
        .then(response => response.json())
        .then(data => {
            const brandSelect = document.getElementById('brandSelect');
            if(brandSelect) {
                brandSelect.innerHTML = '<option value="">Select Brand...</option>';
                data.forEach(brand => {
                    const option = document.createElement('option');
                    option.value = brand.brandId;
                    option.text = brand.name;
                    if(brand.brandId == selectedBrandId) option.selected = true;
                    brandSelect.appendChild(option);
                });
            }
        })
        .catch(err => console.error("Error loading brands", err));
}

function loadProducts() {
    const tableBody = document.getElementById('productsTableBody');
    if(!tableBody) return;

    tableBody.innerHTML = `
        <tr>
            <td colspan="7" class="text-center py-10">
                <div class="animate-spin w-8 h-8 border-4 border-brand-500 border-t-transparent rounded-full mx-auto"></div>
                <p class="text-slate-500 mt-2 font-medium">Loading products...</p>
            </td>
        </tr>
    `;

    fetch(CONTEXT_PATH + '/api/products?action=get_all')
        .then(response => response.json())
        .then(data => {
            allProductsList = data;
            currentPage = 1;
            renderProductsTable();
        })
        .catch(err => {
            console.error("Error loading products:", err);
            tableBody.innerHTML = `
                <tr>
                    <td colspan="7" class="text-center py-10 text-red-500 font-medium">
                        Failed to load products. Please refresh the page.
                    </td>
                </tr>
            `;
        });
}

function renderProductsTable() {
    const tableBody = document.getElementById('productsTableBody');
    tableBody.innerHTML = '';

    if(allProductsList.length === 0) {
        tableBody.innerHTML = `
            <tr>
                <td colspan="7" class="text-center py-10 text-slate-500 font-medium">
                    No products found. Click "Add New Product" to create one.
                </td>
            </tr>
        `;
        updatePaginationUI(0, 0, 0);
        return;
    }

    const totalItems = allProductsList.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage);

    if(currentPage > totalPages) currentPage = totalPages;
    if(currentPage < 1) currentPage = 1;

    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = Math.min(startIndex + itemsPerPage, totalItems);

    const currentItems = allProductsList.slice(startIndex, endIndex);

    currentItems.forEach(product => {
        const catName = product.category ? product.category.name : '-';
        const catId = product.category ? product.category.categoryId : '';
        const brandName = product.brand ? product.brand.name : '-';
        const brandId = product.brand ? product.brand.brandId : '';

        const sellPrice = product.price ? parseFloat(product.price).toLocaleString('en-US', {minimumFractionDigits: 2}) : '0.00';
        const costPrice = product.costPrice ? parseFloat(product.costPrice).toLocaleString('en-US', {minimumFractionDigits: 2}) : '0.00';
        const weight = product.weight ? parseFloat(product.weight).toFixed(2) : '-';

        let statusHtml = '';
        let statusIdVal = "1";
        if(product.status === 'ACTIVE') {
            statusHtml = `<span class="inline-flex items-center gap-1.5 bg-green-50 text-green-700 px-3 py-1 rounded-full text-xs font-semibold border border-green-200"><span class="w-1.5 h-1.5 bg-green-500 rounded-full"></span> Active</span>`;
            statusIdVal = "1";
        } else if(product.status === 'INACTIVE') {
            statusHtml = `<span class="inline-flex items-center gap-1.5 bg-red-50 text-red-700 px-3 py-1 rounded-full text-xs font-semibold border border-red-200"><span class="w-1.5 h-1.5 bg-red-500 rounded-full"></span> Inactive</span>`;
            statusIdVal = "2";
        } else {
            statusHtml = `<span class="inline-flex items-center gap-1.5 bg-yellow-50 text-yellow-700 px-3 py-1 rounded-full text-xs font-semibold border border-yellow-200"><span class="w-1.5 h-1.5 bg-yellow-500 rounded-full"></span> Out of Stock</span>`;
            statusIdVal = "3";
        }

        const safeDesc = product.description ? product.description.replace(/'/g, "\\'").replace(/\n/g, "\\n") : '';
        const safeName = product.productName ? product.productName.replace(/'/g, "\\'") : '';

        const row = document.createElement('tr');
        row.className = 'hover:bg-slate-50/80 transition-colors group';

        row.innerHTML = `
            <td class="py-4 px-5">
                <div class="flex items-center gap-3">
                    ${product.imageUrl
            ? `<img src="${CONTEXT_PATH}/image?file=${product.imageUrl}" class="w-10 h-10 rounded-lg object-cover border border-slate-200">`
            : `<div class="w-10 h-10 rounded-lg bg-slate-100 flex items-center justify-center text-slate-400 border border-slate-200"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg></div>`
        }
                    <div>
                        <p class="font-bold text-slate-800 text-sm">${product.productName}</p>
                        <p class="text-slate-400 text-xs mt-0.5 font-mono">${product.productCode}</p>
                    </div>
                </div>
            </td>
            <td class="py-4 px-5">
                <p class="text-slate-600 truncate max-w-[150px]" title="${product.description}">${product.description || '-'}</p>
            </td>
            <td class="py-4 px-5">
                <div class="flex flex-col gap-1">
                    <span class="text-slate-800 font-bold">${sellPrice} <span class="text-[10px] text-slate-400 font-normal uppercase">(Sell)</span></span>
                    <span class="text-slate-500 text-xs">${costPrice} <span class="text-[10px] text-slate-400 uppercase">(Cost)</span></span>
                </div>
            </td>
            <td class="py-4 px-5">
                <span class="bg-slate-100 text-slate-600 px-2.5 py-1 rounded-md text-xs font-medium border border-slate-200">${weight} kg</span>
            </td>
            <td class="py-4 px-5">
                <div class="flex flex-col gap-1 text-xs">
                    <span class="text-brand-600 font-medium"><span class="text-slate-400 font-normal">Cat:</span> ${catName}</span>
                    <span class="text-brand-600 font-medium"><span class="text-slate-400 font-normal">Br:</span> ${brandName}</span>
                </div>
            </td>
            <td class="py-4 px-5">
                    ${statusHtml}
            </td>
            <td class="py-4 px-5 text-right">
                <button onclick="openUpdateProductModal(${product.productId}, '${safeName}', '${safeDesc}', ${product.price}, ${product.costPrice || 0}, ${product.weight || 0}, '${catId}', '${brandId}', '${statusIdVal}')" class="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors" title="Edit">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path></svg>
                </button>
                <button class="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors" title="Delete">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                </button>
            </td>
        `;
        tableBody.appendChild(row);
    });

    updatePaginationUI(startIndex + 1, endIndex, totalItems);
}

function updatePaginationUI(start, end, total) {
    document.getElementById('pageStart').innerText = total === 0 ? 0 : start;
    document.getElementById('pageEnd').innerText = total === 0 ? 0 : end;
    document.getElementById('pageTotal').innerText = total;
    document.getElementById('btnCurrentPage').innerText = currentPage;

    const btnPrev = document.getElementById('btnPrev');
    const btnNext = document.getElementById('btnNext');
    const totalPages = Math.ceil(total / itemsPerPage);

    if (currentPage <= 1) {
        btnPrev.disabled = true;
        btnPrev.classList.add('cursor-not-allowed', 'text-slate-400', 'opacity-50');
        btnPrev.classList.remove('hover:bg-slate-50', 'text-slate-700');
    } else {
        btnPrev.disabled = false;
        btnPrev.classList.remove('cursor-not-allowed', 'text-slate-400', 'opacity-50');
        btnPrev.classList.add('hover:bg-slate-50', 'text-slate-700', 'cursor-pointer');
    }

    if (currentPage >= totalPages || total === 0) {
        btnNext.disabled = true;
        btnNext.classList.add('cursor-not-allowed', 'text-slate-400', 'opacity-50');
        btnNext.classList.remove('hover:bg-slate-50', 'text-slate-700');
    } else {
        btnNext.disabled = false;
        btnNext.classList.remove('cursor-not-allowed', 'text-slate-400', 'opacity-50');
        btnNext.classList.add('hover:bg-slate-50', 'text-slate-700', 'cursor-pointer');
    }
}

function prevPage() {
    if (currentPage > 1) {
        currentPage--;
        renderProductsTable();
    }
}

function nextPage() {
    const totalPages = Math.ceil(allProductsList.length / itemsPerPage);
    if (currentPage < totalPages) {
        currentPage++;
        renderProductsTable();
    }
}

document.addEventListener('DOMContentLoaded', loadProducts);


function openAddProductModal() {
    modalMessageContainer.innerHTML = '';

    document.getElementById('modalTitle').innerText = "Add New Product";
    document.getElementById('modalSubtitle').innerText = "Fill in the details to add a product to the catalog.";
    document.getElementById('btnText').innerText = "Save Product";
    document.getElementById('formAction').value = "add";
    document.getElementById('productId').value = "";

    document.getElementById('primaryImage').required = true;
    document.getElementById('imageHelpText').classList.add('hidden');

    addProductForm.reset();
    loadDropdowns();

    modal.classList.remove('hidden');
    setTimeout(() => {
        modal.classList.remove('opacity-0');
        modalBox.classList.remove('scale-95');
        modalBox.classList.add('scale-100');
    }, 10);
}

function openUpdateProductModal(id, name, desc, price, cost, weight, catId, brandId, statusId) {
    modalMessageContainer.innerHTML = '';

    document.getElementById('modalTitle').innerText = "Update Product";
    document.getElementById('modalSubtitle').innerText = "Modify the details of the selected product.";
    document.getElementById('btnText').innerText = "Update Product";
    document.getElementById('formAction').value = "update";
    document.getElementById('productId').value = id;

    document.querySelector('input[name="productName"]').value = name;
    document.querySelector('textarea[name="description"]').value = desc;
    document.querySelector('input[name="price"]').value = price;
    document.querySelector('input[name="costPrice"]').value = cost;
    document.querySelector('input[name="weight"]').value = weight;
    document.querySelector('select[name="statusId"]').value = statusId;

    document.getElementById('primaryImage').required = false;
    document.getElementById('imageHelpText').classList.remove('hidden');

    loadDropdowns(catId, brandId);

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

if(modal) {
    modal.addEventListener('click', function(event) {
        if (event.target === modal) {
            closeAddProductModal();
        }
    });
}

if(addProductForm) {
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
        const actionType = document.getElementById('formAction').value;

        fetch(CONTEXT_PATH + '/ProductServlet?action=' + actionType, {
            method: 'POST',
            body: formData
        })
            .then(response => {
                if(response.ok) {
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
                    loadProducts(); // අලුත් Product එකක් දැම්මට පස්සෙත් ඔටෝම Refresh වෙනවා!
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
}