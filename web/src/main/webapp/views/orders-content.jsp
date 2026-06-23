<div class="bg-white p-8 rounded-2xl shadow-sm">

    <div class="flex justify-between items-center mb-6">
        <div class="flex gap-3">
            <select class="bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-sm focus:outline-none">
                <option>All Orders</option>
                <option>Pending</option>
                <option>Delivered</option>
            </select>
            <input type="date" class="bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-sm focus:outline-none">
        </div>
        <button class="border border-slate-300 text-slate-700 hover:bg-slate-50 font-semibold py-2.5 px-5 rounded-xl transition-all">
            📥 Export CSV
        </button>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
            <thead>
            <tr class="bg-slate-50 text-slate-500 text-sm uppercase tracking-wider">
                <th class="py-4 px-4 font-semibold rounded-tl-xl border-b border-slate-200">Order ID</th>
                <th class="py-4 px-4 font-semibold border-b border-slate-200">Customer</th>
                <th class="py-4 px-4 font-semibold border-b border-slate-200">Date</th>
                <th class="py-4 px-4 font-semibold border-b border-slate-200">Total (Rs.)</th>
                <th class="py-4 px-4 font-semibold border-b border-slate-200">Status</th>
                <th class="py-4 px-4 font-semibold rounded-tr-xl border-b border-slate-200">Action</th>
            </tr>
            </thead>
            <tbody class="text-sm">
            <tr class="hover:bg-slate-50 transition-colors">
                <td class="py-4 px-4 border-b border-slate-100 font-bold text-brand-600">#ORD-9901</td>
                <td class="py-4 px-4 border-b border-slate-100 text-slate-700">Kamal Perera</td>
                <td class="py-4 px-4 border-b border-slate-100 text-slate-500">Oct 24, 2026</td>
                <td class="py-4 px-4 border-b border-slate-100 font-semibold">150,000.00</td>
                <td class="py-4 px-4 border-b border-slate-100">
                    <span class="bg-yellow-100 text-yellow-700 px-3 py-1 rounded-full text-xs font-bold">Pending</span>
                </td>
                <td class="py-4 px-4 border-b border-slate-100">
                    <button class="bg-slate-800 text-white px-4 py-1.5 rounded-lg text-xs font-semibold hover:bg-slate-700">View</button>
                </td>
            </tr>
            <tr class="hover:bg-slate-50 transition-colors">
                <td class="py-4 px-4 border-b border-slate-100 font-bold text-brand-600">#ORD-9902</td>
                <td class="py-4 px-4 border-b border-slate-100 text-slate-700">Nimal Silva</td>
                <td class="py-4 px-4 border-b border-slate-100 text-slate-500">Oct 24, 2026</td>
                <td class="py-4 px-4 border-b border-slate-100 font-semibold">45,500.00</td>
                <td class="py-4 px-4 border-b border-slate-100">
                    <span class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-bold">Delivered</span>
                </td>
                <td class="py-4 px-4 border-b border-slate-100">
                    <button class="bg-slate-800 text-white px-4 py-1.5 rounded-lg text-xs font-semibold hover:bg-slate-700">View</button>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>