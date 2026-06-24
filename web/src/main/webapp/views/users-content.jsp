<div class="bg-white p-6 md:p-8 rounded-2xl shadow-sm border border-slate-100">

    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
        <div>
            <h3 class="text-xl font-bold text-slate-800">System Users & Customers</h3>
            <p class="text-sm text-slate-500 mt-1">Manage administrators and customer accounts.</p>
        </div>

        <div class="flex flex-col sm:flex-row gap-3 w-full md:w-auto">
            <!-- Search Box -->
            <div class="relative w-full sm:w-64">
                <input type="text" placeholder="Search users..."
                       class="w-full bg-slate-50 border border-slate-200 rounded-xl pl-10 pr-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:bg-white focus:ring-2 focus:ring-brand-500/20 transition-all">
                <span class="absolute left-3.5 top-3 text-slate-400">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                </span>
            </div>

            <button class="bg-slate-800 hover:bg-slate-900 text-white font-semibold py-2.5 px-5 rounded-xl transition-all shadow-sm flex items-center justify-center gap-2 whitespace-nowrap">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"></path></svg>
                <span>Add Admin</span>
            </button>
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
        <p class="text-sm text-slate-500">Showing <span class="font-medium text-slate-700">3</span> users</p>
        <div class="flex gap-2">
            <button class="px-3 py-1.5 border border-slate-200 text-slate-400 rounded-lg text-sm font-medium cursor-not-allowed">Previous</button>
            <button class="px-3 py-1.5 bg-brand-50 text-brand-600 rounded-lg text-sm font-medium">1</button>
            <button class="px-3 py-1.5 border border-slate-200 text-slate-400 rounded-lg text-sm font-medium cursor-not-allowed">Next</button>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/users-content.js"></script>