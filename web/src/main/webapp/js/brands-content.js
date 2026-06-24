function loadBrands() {
    const tableBody = document.getElementById('brandTableBody');
    if (!tableBody) return;

    tableBody.innerHTML = `
        <tr>
            <td colspan="3" class="text-center py-10">
                <div class="animate-spin w-6 h-6 border-2 border-brand-500 border-t-transparent rounded-full mx-auto"></div>
                <p class="text-slate-500 mt-2 text-sm font-medium">Loading brands...</p>
            </td>
        </tr>
    `;

    fetch(CONTEXT_PATH + '/api/products?action=get_brands')
        .then(response => response.json())
        .then(data => {
            tableBody.innerHTML = '';

            if (data.length === 0) {
                tableBody.innerHTML = `
                    <tr>
                        <td colspan="3" class="text-center py-8 text-slate-500 text-sm">
                            No brands found. Add a new brand from the right panel.
                        </td>
                    </tr>
                `;
                document.getElementById('brandCount').innerText = "Showing 0 brands";
                return;
            }

            data.forEach(brand => {
                const initials = brand.name.substring(0, 2).toUpperCase();

                const row = document.createElement('tr');
                row.className = 'hover:bg-slate-50/80 transition-colors group';

                row.innerHTML = `
                    <td class="py-3 px-5">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 rounded-lg bg-orange-50 text-orange-600 flex items-center justify-center font-bold text-xs border border-orange-100 uppercase">
                                ${initials}
                            </div>
                            <span class="font-semibold text-slate-800">${brand.name}</span>
                        </div>
                    </td>
                    <td class="py-3 px-5">
                        <span class="inline-flex items-center gap-1 bg-green-50 text-green-700 px-2.5 py-1 rounded-md text-xs font-medium border border-green-200">
                            Active
                        </span>
                    </td>
                    <td class="py-3 px-5 text-right">
                        <button class="p-1.5 text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors mx-0.5" title="Edit">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path></svg>
                        </button>
                        <button class="p-1.5 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors mx-0.5" title="Delete">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                        </button>
                    </td>
                `;
                tableBody.appendChild(row);
            });

            const countElement = document.getElementById('brandCount');
            if(countElement) {
                countElement.innerText = `Showing ${data.length} brands`;
            }
        })
        .catch(error => {
            console.error("Error loading brands:", error);
            tableBody.innerHTML = `
                <tr>
                    <td colspan="3" class="text-center py-8 text-red-500 text-sm font-medium">
                        Failed to load brands! Check your connection.
                    </td>
                </tr>
            `;
        });
}

document.addEventListener('DOMContentLoaded', loadBrands);

const addBrandForm = document.getElementById('addBrandForm');

if (addBrandForm) {
    addBrandForm.addEventListener('submit', function(e) {
        e.preventDefault();

        const submitBtn = this.querySelector('button[type="submit"]');
        const originalBtnHtml = submitBtn.innerHTML;

        submitBtn.disabled = true;
        submitBtn.classList.add('opacity-75', 'cursor-not-allowed');
        submitBtn.innerHTML = `
            <svg class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
            <span>Saving...</span>
        `;

        let msgDiv = document.getElementById('brandMsgDiv');
        if(!msgDiv) {
            msgDiv = document.createElement('div');
            msgDiv.id = 'brandMsgDiv';
            this.insertBefore(msgDiv, submitBtn);
        }
        msgDiv.innerHTML = '';

        const formData = new FormData(this);

        fetch(CONTEXT_PATH + '/api/products?action=add_brand', {
            method: 'POST',
            body: new URLSearchParams(formData)
        })
            .then(async response => {
                const data = await response.json();

                if (response.ok && data.success) {
                    msgDiv.className = 'mb-4 text-sm font-medium text-green-700 bg-green-50 p-3 rounded-xl border border-green-200';
                    msgDiv.innerText = data.message;

                    this.reset();
                    loadBrands();
                } else {
                    msgDiv.className = 'mb-4 text-sm font-medium text-red-700 bg-red-50 p-3 rounded-xl border border-red-200';
                    msgDiv.innerText = data.message || "Failed to add brand.";
                }

                setTimeout(() => {
                    if(msgDiv) {
                        msgDiv.innerHTML = '';
                        msgDiv.className = '';
                    }
                }, 3000);
            })
            .catch(err => {
                msgDiv.className = 'mb-4 text-sm font-medium text-red-700 bg-red-50 p-3 rounded-xl border border-red-200';
                msgDiv.innerText = "Network error. Please try again.";
            })
            .finally(() => {
                submitBtn.disabled = false;
                submitBtn.classList.remove('opacity-75', 'cursor-not-allowed');
                submitBtn.innerHTML = originalBtnHtml;
            });
    });
}