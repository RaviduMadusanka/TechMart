function loadInventoryData() {
    const tableBody = document.getElementById('inventoryTableBody');
    tableBody.innerHTML = `<tr><td colspan="6" class="text-center py-10">Loading inventory...</td></tr>`;

    fetch(CONTEXT_PATH + '/api/inventory?action=get_all')
        .then(response => response.json())
        .then(data => {
            tableBody.innerHTML = '';

            if (data.length === 0) {
                tableBody.innerHTML = `<tr><td colspan="6" class="text-center py-10 text-slate-500">No inventory records found.</td></tr>`;
                return;
            }

            data.forEach(inv => {
                const p = inv.product;
                const brandName = p.brand ? p.brand.name : 'Unknown Brand';
                const catName = p.category ? p.category.name : 'Uncategorized';
                const price = p.price ? parseFloat(p.price).toLocaleString('en-US', {minimumFractionDigits: 2}) : '0.00';

                let statusHtml = '';
                if (inv.quantity <= 0) {
                    statusHtml = `<span class="inline-flex items-center gap-1.5 text-xs font-bold text-red-600 uppercase tracking-wide"><span class="w-2 h-2 bg-red-500 rounded-full"></span> Out of Stock</span>`;
                } else if (inv.quantity <= inv.reorderLevel) {
                    statusHtml = `<span class="inline-flex items-center gap-1.5 text-xs font-bold text-yellow-600 uppercase tracking-wide"><span class="w-2 h-2 bg-yellow-500 rounded-full"></span> Low Stock</span>`;
                } else {
                    statusHtml = `<span class="inline-flex items-center gap-1.5 text-xs font-bold text-green-600 uppercase tracking-wide"><span class="w-2 h-2 bg-green-500 rounded-full"></span> Active</span>`;
                }

                const imgTag = p.imageUrl
                    ? `<img src="${CONTEXT_PATH}/image?file=${p.imageUrl}" class="w-10 h-10 rounded-lg object-cover border border-slate-200">`
                    : `<div class="w-10 h-10 rounded-lg bg-slate-100 flex items-center justify-center text-slate-400 border border-slate-200"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg></div>`;

                const row = document.createElement('tr');
                row.className = 'hover:bg-slate-50/80 transition-colors group';
                row.innerHTML = `
                    <td class="py-3 px-5">
                        <div class="flex items-center gap-3">
                            ${imgTag}
                            <div>
                                <p class="font-bold text-slate-800 text-sm">${p.productName}</p>
                                <p class="text-slate-400 text-xs mt-0.5">${brandName}</p>
                            </div>
                        </div>
                    </td>
                    <td class="py-3 px-5 font-medium text-slate-600">${catName}</td>
                    <td class="py-3 px-5">
                        <div class="bg-slate-100/50 border border-slate-200 rounded-lg px-3 py-1.5 inline-block text-slate-700 font-semibold font-mono text-xm">
                            Rs.${price}
                        </div>
                    </td>
                    <td class="py-3 px-5">
                        <div class="flex items-center border border-slate-300 rounded-lg w-max bg-white shadow-sm overflow-hidden">
                            <button type="button" class="px-3 py-1.5 text-slate-500 hover:bg-slate-100 hover:text-slate-700 border-r border-slate-300 font-bold transition-colors" onclick="updateQty(${inv.inventoryId}, -1)">−</button>
                            <input type="text" id="qty-${inv.inventoryId}" class="w-12 text-center text-sm font-bold ${inv.quantity <= inv.reorderLevel ? 'text-red-600' : 'text-slate-800'} outline-none bg-transparent" value="${inv.quantity}" readonly>
                            <button type="button" class="px-3 py-1.5 text-slate-500 hover:bg-slate-100 hover:text-slate-700 border-l border-slate-300 font-bold transition-colors" onclick="updateQty(${inv.inventoryId}, 1)">+</button>
                        </div>
                    </td>
                    <td class="py-3 px-5">
                        ${statusHtml}
                    </td>
                    <td class="py-3 px-5 text-right">
                        <div class="flex items-center justify-end gap-4">
                            <button class="text-slate-400 hover:text-red-500 transition-colors" title="Delete">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                            </button>
                            <button onclick="saveInventoryUpdate(${inv.inventoryId})" class="bg-brand-500 hover:bg-brand-600 text-white text-xs font-semibold px-4 py-2 rounded-lg transition-colors shadow-sm">
                                Update
                            </button>
                        </div>
                    </td>
                `;
                tableBody.appendChild(row);
            });
        })
        .catch(err => console.error("Error loading inventory:", err));
}

document.addEventListener('DOMContentLoaded', loadInventoryData);

function updateQty(invId, amount) {
    const input = document.getElementById(`qty-${invId}`);
    let currentQty = parseInt(input.value);
    let newQty = currentQty + amount;
    if (newQty >= 0) {
        input.value = newQty;
    }
}

function saveInventoryUpdate(inventoryId) {
    const qty = document.getElementById(`qty-${inventoryId}`).value;

    fetch(CONTEXT_PATH + '/api/inventory?action=update_stock', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `inventoryId=${inventoryId}&quantity=${qty}`
    })
        .then(response => response.json())
        .then(data => {
            if(data.status === 'success') {
                showToast("Stock updated successfully!");
                loadInventoryData();
            } else {
                console.log(data.message);
            }
        })
        .catch(err => console.error("Update error:", err));
}

function showToast(message) {
    const toast = document.getElementById('toast');
    const toastMessage = document.getElementById('toastMessage');

    toastMessage.innerText = message;
    toast.classList.remove('hidden');

    setTimeout(() => {
        toast.classList.remove('translate-y-10');
        toast.classList.add('translate-y-0');
    }, 10);

    setTimeout(() => {
        toast.classList.add('translate-y-10');
        setTimeout(() => {
            toast.classList.add('hidden');
        }, 300);
    }, 3000);
}