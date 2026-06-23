<div class="bg-white p-8 rounded-2xl shadow-sm">
    <div class="flex justify-between items-center mb-6">
        <h3 class="text-xl font-bold text-slate-800">System Users & Customers</h3>
        <button class="bg-slate-800 hover:bg-slate-900 text-white font-semibold py-2 px-5 rounded-xl transition-all shadow-sm">
            + Add New Admin
        </button>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
            <thead>
            <tr class="bg-slate-50 text-slate-500 text-sm uppercase tracking-wider">
                <th class="py-4 px-4 font-semibold border-b border-slate-200">User Details</th>
                <th class="py-4 px-4 font-semibold border-b border-slate-200">Role</th>
                <th class="py-4 px-4 font-semibold border-b border-slate-200">Joined Date</th>
                <th class="py-4 px-4 font-semibold border-b border-slate-200">Status</th>
                <th class="py-4 px-4 font-semibold border-b border-slate-200">Actions</th>
            </tr>
            </thead>
            <tbody class="text-sm">
            <tr class="hover:bg-slate-50 transition-colors">
                <td class="py-3 px-4 border-b border-slate-100 flex items-center gap-3">
                    <div class="w-10 h-10 bg-brand-100 text-brand-600 rounded-full flex items-center justify-center font-bold">SA</div>
                    <div>
                        <p class="font-bold text-slate-800">System Admin</p>
                        <p class="text-slate-400 text-xs">admin@techmart.com</p>
                    </div>
                </td>
                <td class="py-3 px-4 border-b border-slate-100">
                    <span class="bg-purple-100 text-purple-700 px-3 py-1 rounded-full text-xs font-bold">Administrator</span>
                </td>
                <td class="py-3 px-4 border-b border-slate-100 text-slate-500">Jan 10, 2026</td>
                <td class="py-3 px-4 border-b border-slate-100">
                    <span class="text-green-600 font-semibold">● Active</span>
                </td>
                <td class="py-3 px-4 border-b border-slate-100">
                    <button class="text-slate-400 hover:text-slate-700 font-medium">Manage</button>
                </td>
            </tr>
            <tr class="hover:bg-slate-50 transition-colors">
                <td class="py-3 px-4 border-b border-slate-100 flex items-center gap-3">
                    <div class="w-10 h-10 bg-slate-200 text-slate-600 rounded-full flex items-center justify-center font-bold">KP</div>
                    <div>
                        <p class="font-bold text-slate-800">Kamal Perera</p>
                        <p class="text-slate-400 text-xs">kamal@example.com</p>
                    </div>
                </td>
                <td class="py-3 px-4 border-b border-slate-100">
                    <span class="bg-slate-100 text-slate-600 px-3 py-1 rounded-full text-xs font-bold">Customer</span>
                </td>
                <td class="py-3 px-4 border-b border-slate-100 text-slate-500">Oct 20, 2026</td>
                <td class="py-3 px-4 border-b border-slate-100">
                    <span class="text-green-600 font-semibold">● Active</span>
                </td>
                <td class="py-3 px-4 border-b border-slate-100">
                    <button class="text-red-500 hover:text-red-700 font-medium">Suspend</button>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>