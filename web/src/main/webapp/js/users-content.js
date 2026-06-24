const CONTEXT_PATH = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

function loadUsers() {
    const tableBody = document.getElementById('userTableBody');
    if (!tableBody) return;

    // තීරු 6ටම ගැලපෙන්න colspan="6" දැම්මා
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
            tableBody.innerHTML = '';

            if (!Array.isArray(data)) {
                throw new Error("Invalid data format received from server.");
            }

            if (data.length === 0) {
                tableBody.innerHTML = `
                    <tr>
                        <td colspan="6" class="text-center py-8 text-slate-500 font-medium">
                            No customers found in the database.
                        </td>
                    </tr>
                `;
                return;
            }

            data.forEach(user => {
                const firstName = user.firstName || 'U';
                const lastName = user.lastName || 'U';
                const initials = (firstName.charAt(0) + lastName.charAt(0)).toUpperCase();

                const statusClass = user.status === 'ACTIVE' ? 'text-green-600' : 'text-red-600';
                const statusDot = user.status === 'ACTIVE' ? 'bg-green-500' : 'bg-red-500';
                const actionTitle = user.status === 'ACTIVE' ? 'Suspend User' : 'Activate User';

                const row = document.createElement('tr');
                row.className = 'hover:bg-slate-50 transition-colors group';

                // තීරු 6ට අදාළව Data ටික දානවා
                row.innerHTML = `
                    <td class="py-3 px-5 border-b border-slate-100">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 bg-brand-50 text-brand-600 rounded-full flex items-center justify-center font-bold text-xs border border-brand-100">${initials}</div>
                            <p class="font-bold text-slate-800">${firstName} ${lastName}</p>
                        </div>
                    </td>
                    <td class="py-3 px-5 border-b border-slate-100 text-slate-600">
                        ${user.email || 'N/A'}
                    </td>
                    <td class="py-3 px-5 border-b border-slate-100 text-slate-500">
                        ${user.joinedDate || 'N/A'}
                    </td>
                    <td class="py-3 px-5 border-b border-slate-100 text-center text-slate-600 font-bold">
                        0 <!-- දැනට Orders ගාණ 0යි කියලා දාමු -->
                    </td>
                    <td class="py-3 px-5 border-b border-slate-100">
                        <span class="inline-flex items-center gap-1.5 bg-slate-50 px-2.5 py-1 rounded-full text-xs font-semibold border border-slate-200 ${statusClass}">
                            <span class="w-1.5 h-1.5 ${statusDot} rounded-full"></span> ${user.status || 'UNKNOWN'}
                        </span>
                    </td>
                    <td class="py-3 px-5 border-b border-slate-100 text-right">
                        <div class="flex gap-2 justify-end">
                            <button class="p-1.5 text-slate-400 hover:text-brand-600 hover:bg-brand-50 rounded-lg transition-colors" title="View Details">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                            </button>
                            <button onclick="updateUserStatus(${user.customerId}, '${user.status}')" class="p-1.5 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors" title="${actionTitle}">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636"></path></svg>
                            </button>
                        </div>
                    </td>
                `;
                tableBody.appendChild(row);
            });
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

document.addEventListener('DOMContentLoaded', loadUsers);