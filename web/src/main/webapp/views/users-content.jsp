<div class="bg-white p-6 md:p-8 rounded-2xl shadow-sm border border-slate-100">

    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
        <div>
            <h3 class="text-xl font-bold text-slate-800">System Users & Customers</h3>
            <p class="text-sm text-slate-500 mt-1">Manage administrators and customer accounts.</p>
        </div>

        <div class="flex flex-col sm:flex-row gap-3 w-full md:w-auto">
            <div class="relative w-full sm:w-64">
                <input type="text" placeholder="Search users..."
                       class="w-full bg-slate-50 border border-slate-200 rounded-xl pl-10 pr-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:bg-white focus:ring-2 focus:ring-brand-500/20 transition-all">
                <span class="absolute left-3.5 top-3 text-slate-400">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                </span>
            </div>

            <button onclick="openViewAdminsModal()" class="bg-blue-50 border border-blue-100 hover:bg-blue-100 text-blue-700 font-semibold py-2.5 px-5 rounded-xl transition-all shadow-sm flex items-center justify-center gap-2 whitespace-nowrap">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
                <span>View Admins</span>
            </button>

            <% if ("Super Admin".equals(session.getAttribute("userRole"))) { %>
            <button onclick="openAddAdminModal()" class="bg-slate-800 hover:bg-slate-900 text-white font-semibold py-2.5 px-5 rounded-xl transition-all shadow-sm flex items-center justify-center gap-2 whitespace-nowrap">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"></path></svg>
                <span>Add Admin</span>
            </button>
            <% } %>
        </div>
    </div>

    <div class="overflow-x-auto border border-slate-200 rounded-xl">
        <table class="w-full text-left border-collapse whitespace-nowrap">
            <thead>
            <tr class="bg-slate-50 text-slate-500 text-xs uppercase tracking-wider">
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Customers</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Email</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Joined</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200 text-center">Orders</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200">Status</th>
                <th class="py-4 px-5 font-semibold border-b border-slate-200 text-right">Actions</th>
            </tr>
            </thead>
            <tbody class="text-sm divide-y divide-slate-100" id="userTableBody">
            </tbody>
        </table>
    </div>

    <div class="flex items-center justify-between mt-6">
        <p class="text-sm text-slate-500">Showing <span id="pageStart" class="font-medium text-slate-700">0</span> to <span id="pageEnd" class="font-medium text-slate-700">0</span> of <span id="pageTotal" class="font-medium text-slate-700">0</span> users</p>
        <div class="flex gap-2">
            <button id="btnPrev" onclick="prevPage()" disabled class="px-3 py-1.5 border border-slate-200 text-slate-400 rounded-lg text-sm font-medium cursor-not-allowed">Previous</button>
            <button id="btnCurrentPage" class="px-3 py-1.5 bg-brand-50 text-brand-600 rounded-lg text-sm font-medium">1</button>
            <button id="btnNext" onclick="nextPage()" disabled class="px-3 py-1.5 border border-slate-200 text-slate-400 rounded-lg text-sm font-medium cursor-not-allowed">Next</button>
        </div>
    </div>
</div>

<div id="addAdminModal" class="hidden fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-50 flex items-center justify-center p-4 transition-opacity duration-300 opacity-0">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden transform scale-95 transition-transform duration-300" id="adminModalBox">
        <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-brand-100 text-brand-600 rounded-lg flex items-center justify-center">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"></path></svg>
                </div>
                <div>
                    <h3 class="text-lg font-bold text-slate-800">Add New Admin</h3>
                    <p class="text-xs text-slate-500">Create a new system administrator.</p>
                </div>
            </div>
            <button type="button" onclick="closeAddAdminModal()" class="text-slate-400 hover:text-slate-600 bg-white p-2 rounded-full hover:bg-slate-200 transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
            </button>
        </div>
        <form id="addAdminForm">
            <div class="p-6 space-y-4">
                <div id="adminMsgDiv"></div>
                <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Username *</label>
                    <input type="text" name="username" required placeholder="admin123" class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-brand-500 focus:bg-white transition-colors">
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Email Address *</label>
                    <input type="email" name="email" required placeholder="admin@techmart.com" class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-brand-500 focus:bg-white transition-colors">
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">User Type *</label>
                    <select id="userTypeSelect" name="userTypeId" required class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-brand-500 focus:bg-white transition-colors">
                        <option value="">Loading...</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Password *</label>
                    <input type="password" name="password" required placeholder="••••••••" class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-brand-500 focus:bg-white transition-colors">
                </div>
            </div>
            <div class="p-6 border-t border-slate-100 flex justify-end gap-3 bg-slate-50">
                <button type="button" onclick="closeAddAdminModal()" class="px-5 py-2.5 rounded-lg border border-slate-300 text-slate-700 font-semibold hover:bg-slate-100 transition-colors text-sm">Cancel</button>
                <button type="submit" id="saveAdminBtn" class="px-5 py-2.5 rounded-lg bg-slate-800 hover:bg-slate-900 text-white font-semibold shadow-md transition-all active:scale-95 flex items-center justify-center gap-2 text-sm min-w-[120px]">
                    <span>Save Admin</span>
                </button>
            </div>
        </form>
    </div>
</div>

<div id="viewAdminsModal" class="hidden fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-50 flex items-center justify-center p-4 transition-opacity duration-300 opacity-0">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-4xl overflow-hidden transform scale-95 transition-transform duration-300 flex flex-col max-h-[80vh]" id="viewAdminsModalBox">
        <div class="p-5 border-b border-slate-100 flex justify-between items-center bg-slate-50">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-brand-100 text-brand-600 rounded-lg flex items-center justify-center">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
                </div>
                <div>
                    <h3 class="text-lg font-bold text-slate-800">System Administrators</h3>
                    <p class="text-xs text-slate-500">List of all active and inactive admins.</p>
                </div>
            </div>
            <button type="button" onclick="closeViewAdminsModal()" class="text-slate-400 hover:text-slate-600 bg-white p-2 rounded-full hover:bg-slate-200 transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
            </button>
        </div>
        <div class="overflow-y-auto flex-1 p-0">
            <table class="w-full text-left border-collapse whitespace-nowrap">
                <thead class="sticky top-0 bg-slate-50 text-slate-500 text-xs uppercase tracking-wider z-10">
                <tr>
                    <th class="py-3 px-5 font-semibold border-b border-slate-200">Username</th>
                    <th class="py-3 px-5 font-semibold border-b border-slate-200">Email</th>
                    <th class="py-3 px-5 font-semibold border-b border-slate-200">Role</th>
                    <th class="py-3 px-5 font-semibold border-b border-slate-200">Status</th>
                    <% if ("Super Admin".equals(session.getAttribute("userRole"))) { %>
                    <th class="py-3 px-5 font-semibold border-b border-slate-200 text-right">Action</th>
                    <% } %>
                </tr>
                </thead>
                <tbody class="text-sm divide-y divide-slate-100" id="adminsTableBody">
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    var LOGGED_USER_ROLE = '<%= session.getAttribute("userRole") != null ? session.getAttribute("userRole") : "" %>';
</script>
<script src="${pageContext.request.contextPath}/js/users-content.js"></script>