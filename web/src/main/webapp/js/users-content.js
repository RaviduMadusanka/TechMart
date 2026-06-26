if (typeof CONTEXT_PATH === 'undefined') {
    var CONTEXT_PATH = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
}

let allUsersList = [];
let currentPage = 1;
const itemsPerPage = 5;

function loadUsers() {
    const tableBody = document.getElementById('userTableBody');
    if (!tableBody) return;

    tableBody.innerHTML = `
        <tr>
            <td colspan="6" class="text-center py-10">
                <div class="animate-spin w-8 h-8 border-4 border-brand-500 border-t-transparent rounded-full mx-auto"></div>
                <p class="text-slate-500 mt-2 font-medium">Loading customers...</p>
            </td>
        </tr>
    `;

    fetch(CONTEXT_PATH + '/api/users?action=get_customers')
        .then(response => {
            if (!response.ok) {
                return response.json().then(err => { throw new Error(err.error || 'Server Error'); });
            }
            return response.json();
        })
        .then(data => {

            if (!Array.isArray(data)) {
                throw new Error("Invalid data format received from server.");
            }

            if (data.length === 0) {
                allUsersList = [];
                renderUsersTable();
                return;
            }
            allUsersList = data;
            currentPage = 1;

            renderUsersTable();
        })
        .catch(error => {
            console.error("Error loading users:", error);
            tableBody.innerHTML = `
                <tr>
                    <td colspan="6" class="text-center py-8">
                        <div class="bg-red-50 text-red-600 px-4 py-3 rounded-lg inline-block text-sm font-medium border border-red-200">
                            Failed to load users: ${error.message}
                        </div>
                    </td>
                </tr>
            `;
        });
}

function renderUsersTable() {
    const tableBody = document.getElementById('userTableBody');
    tableBody.innerHTML = '';

    if (allUsersList.length === 0) {
        tableBody.innerHTML = `<tr><td colspan="6" class="text-center py-8 text-slate-500 font-medium">No customers found.</td></tr>`;
        updatePaginationUI(0, 0, 0);
        return;
    }

    const totalItems = allUsersList.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage);

    if (currentPage > totalPages) currentPage = totalPages;
    if (currentPage < 1) currentPage = 1;

    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = Math.min(startIndex + itemsPerPage, totalItems);

    const currentItems = allUsersList.slice(startIndex, endIndex);

    currentItems.forEach(user => {
        const firstName = user.firstName || 'U';
        const lastName = user.lastName || 'U';
        const initials = (firstName.charAt(0) + lastName.charAt(0)).toUpperCase();

        const statusClass = user.status === 'ACTIVE' ? 'text-green-600' : 'text-red-600';
        const statusDot = user.status === 'ACTIVE' ? 'bg-green-500' : 'bg-red-500';

        const row = document.createElement('tr');
        row.className = 'hover:bg-slate-50 transition-colors';

        row.innerHTML = `
            <td class="py-4 px-5">
                <div class="flex items-center gap-3">
                    <div class="w-9 h-9 bg-slate-200 text-slate-600 rounded-full flex items-center justify-center font-bold text-xs">${initials}</div>
                    <span class="font-bold text-slate-800">${firstName} ${lastName}</span>
                </div>
            </td>
            <td class="py-4 px-5 text-slate-500 text-sm">${user.email || '-'}</td>
            <td class="py-4 px-5 text-slate-500 text-sm">${user.joinedDate || '-'}</td>
            <td class="py-4 px-5 text-center text-slate-500 text-sm font-medium">0</td>
            <td class="py-4 px-5">
                <span class="inline-flex items-center gap-1.5 bg-slate-50 px-2.5 py-1 rounded-full text-xs font-semibold border border-slate-200 ${statusClass}">
                    <span class="w-1.5 h-1.5 ${statusDot} rounded-full"></span> ${user.status || 'UNKNOWN'}
                </span>
            </td>
            <td class="py-4 px-5 text-right">
                <button onclick="updateUserStatus(${user.customerId}, '${user.status}')" class="p-1.5 text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors" title="Change Status">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4"></path></svg>
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
    if (currentPage > 1) { currentPage--; renderUsersTable(); }
}

function nextPage() {
    const totalPages = Math.ceil(allUsersList.length / itemsPerPage);
    if (currentPage < totalPages) { currentPage++; renderUsersTable(); }
}

document.addEventListener('DOMContentLoaded', loadUsers);

function loadUserTypes() {
    const select = document.getElementById('userTypeSelect');
    if (!select) return;

    fetch(CONTEXT_PATH + '/api/users?action=get_user_types')
        .then(res => {
            if(!res.ok) throw new Error("API not ready");
            return res.json();
        })
        .then(data => {
            select.innerHTML = '<option value="" disabled selected>Select a role</option>';
            data.forEach(type => {
                select.innerHTML += `<option value="${type.id || type.typeId}">${type.typeName || type.name}</option>`;
            });
        })
        .catch(err => {
            select.innerHTML = `
                <option value="" disabled selected>Select a role</option>
                <option value="1">Super Admin</option>
                <option value="2">Manager</option>
                <option value="3">Editor</option>
            `;
        });
}

function openAddAdminModal() {
    const modal = document.getElementById('addAdminModal');
    const modalBox = document.getElementById('adminModalBox');
    document.getElementById('addAdminForm').reset();

    let msgDiv = document.getElementById('adminMsgDiv');
    if (msgDiv) {
        msgDiv.innerHTML = '';
        msgDiv.className = '';
    }

    loadUserTypes();

    modal.classList.remove('hidden');
    setTimeout(() => {
        modal.classList.remove('opacity-0');
        modalBox.classList.remove('scale-95');
        modalBox.classList.add('scale-100');
    }, 10);
}

function closeAddAdminModal() {
    const modal = document.getElementById('addAdminModal');
    const modalBox = document.getElementById('adminModalBox');

    modal.classList.add('opacity-0');
    modalBox.classList.remove('scale-100');
    modalBox.classList.add('scale-95');
    setTimeout(() => { modal.classList.add('hidden'); }, 300);
}

const addAdminForm = document.getElementById('addAdminForm');
if (addAdminForm) {
    addAdminForm.addEventListener('submit', function(e) {
        e.preventDefault();
        const submitBtn = document.getElementById('saveAdminBtn');
        const originalBtnHtml = submitBtn.innerHTML;

        submitBtn.disabled = true;
        submitBtn.classList.add('opacity-75', 'cursor-not-allowed');
        submitBtn.innerHTML = `<span>Saving...</span>`;

        const msgDiv = document.getElementById('adminMsgDiv');
        const formData = new FormData(this);

        fetch(CONTEXT_PATH + '/api/users?action=add_admin', {
            method: 'POST',
            body: new URLSearchParams(formData)
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    msgDiv.className = 'mb-4 text-sm font-medium text-green-700 bg-green-50 p-3 rounded-xl border border-green-200';
                    msgDiv.innerText = data.message || "Admin saved successfully!";
                    this.reset();
                    setTimeout(() => { closeAddAdminModal(); loadAdminsList(); }, 1500);
                } else {
                    msgDiv.className = 'mb-4 text-sm font-medium text-red-700 bg-red-50 p-3 rounded-xl border border-red-200';
                    msgDiv.innerText = data.message || "Failed to add admin.";
                }
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

function loadAdminsList() {
    const tableBody = document.getElementById('adminsTableBody');
    if(!tableBody) return;

    tableBody.innerHTML = `<tr><td colspan="5" class="text-center py-6 text-slate-500">Loading admins...</td></tr>`;

    fetch(CONTEXT_PATH + '/api/users?action=get_admins')
        .then(res => {
            if(!res.ok) throw new Error("API not ready");
            return res.json();
        })
        .then(data => {

            tableBody.innerHTML = '';
            if(data.length === 0) {
                tableBody.innerHTML = `<tr><td colspan="5" class="text-center py-6 text-slate-500">No admins found.</td></tr>`;
                return;
            }

            data.forEach(admin => {
                console.log(admin);
                const statusClass = admin.status === 'ACTIVE' ? 'text-green-600' : 'text-red-600';

                const statusDot = admin.status === 'ACTIVE' ? 'bg-green-500' : 'bg-red-500';

                let adminActionHtml = '';
                if (typeof LOGGED_USER_ROLE !== 'undefined' && LOGGED_USER_ROLE === 'Super Admin') {
                    adminActionHtml = `
                        <td class="py-3 px-5 text-right">
                            <button onclick="updateAdminStatus(${admin.id}, '${admin.status}')" class="p-1.5 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors" title="Change Status">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636"></path></svg>
                            </button>
                        </td>
                    `;
                }

                tableBody.innerHTML += `
                    <tr class="hover:bg-slate-50 border-b border-slate-50">
                        <td class="py-3 px-5 font-semibold text-slate-800">${admin.username}</td>
                        <td class="py-3 px-5 text-slate-600">${admin.email || '-'}</td>
                        <td class="py-3 px-5"><span class="bg-indigo-50 text-indigo-700 px-2.5 py-1 rounded-md text-xs font-bold">${admin.role || 'Admin'}</span></td>
                        <td class="py-3 px-5">
                            <span class="inline-flex items-center gap-1.5 text-xs font-semibold ${statusClass}">
                                <span class="w-1.5 h-1.5 ${statusDot} rounded-full"></span> ${admin.status || 'ACTIVE'}
                            </span>
                        </td>
                        ${adminActionHtml}
                    </tr>
                `;
            });
        })
        .catch(err => {
            tableBody.innerHTML = `<tr><td colspan="5" class="text-center py-6 text-red-500">Failed to load admins data!</td></tr>`;
        });
}

function openViewAdminsModal() {
    const modal = document.getElementById('viewAdminsModal');
    const modalBox = document.getElementById('viewAdminsModalBox');

    loadAdminsList();

    modal.classList.remove('hidden');
    setTimeout(() => {
        modal.classList.remove('opacity-0');
        modalBox.classList.remove('scale-95');
        modalBox.classList.add('scale-100');
    }, 10);
}

function closeViewAdminsModal() {
    const modal = document.getElementById('viewAdminsModal');
    const modalBox = document.getElementById('viewAdminsModalBox');

    modal.classList.add('opacity-0');
    modalBox.classList.remove('scale-100');
    modalBox.classList.add('scale-95');
    setTimeout(() => { modal.classList.add('hidden'); }, 300);
}

function updateAdminStatus(adminId, currentStatus) {

    const newStatus = currentStatus === 'ACTIVE'
        ? 'SUSPENDED'
        : 'ACTIVE';

    fetch(CONTEXT_PATH + '/api/users?action=update_admin_status', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: new URLSearchParams({
            'adminId': adminId,
            'status': newStatus
        })
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                loadAdminsList();
            } else {
                console.log("Failed to update admin status");
            }
        })
        .catch(err => {
            console.error(err);
        });
}

function updateUserStatus(customerId, currentStatus) {
    const newStatus = currentStatus === 'ACTIVE' ? 'SUSPENDED' : 'ACTIVE';

    fetch(CONTEXT_PATH + '/api/users?action=update_status', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ 'customerId': customerId, 'status': newStatus })
    })
        .then(response => response.json())
        .then(data => {
            if(data.success) {
                loadUsers();
            } else {
                alert("Failed to update status: " + (data.error || "Unknown error"));
            }
        })
        .catch(error => {
            console.error("Network error:", error);
            alert("Network error occurred.");
        });
}