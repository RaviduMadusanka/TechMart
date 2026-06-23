<div class="bg-white p-8 rounded-2xl shadow-sm">
    <div class="flex justify-between items-center mb-6">
        <h3 class="text-xl font-bold text-slate-800">Warehouse Stock Control</h3>
        <button class="bg-brand-500 hover:bg-brand-600 text-white font-semibold py-2 px-5 rounded-xl transition-all shadow-sm">
            ↻ Sync Stock
        </button>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
            <thead>
            <tr class="bg-slate-50 text-slate-500 text-sm uppercase tracking-wider">
                <th class="py-4 px-4 font-semibold border-b border-slate-200">Product Name</th>
                <th class="py-4 px-4 font-semibold border-b border-slate-200">SKU</th>
                <th class="py-4 px-4 font-semibold border-b border-slate-200">Available Stock</th>
                <th class="py-4 px-4 font-semibold border-b border-slate-200">Reorder Level</th>
                <th class="py-4 px-4 font-semibold border-b border-slate-200">Status</th>
                <th class="py-4 px-4 font-semibold border-b border-slate-200">Update</th>
            </tr>
            </thead>
            <tbody class="text-sm">
            <tr class="hover:bg-slate-50 transition-colors">
                <td class="py-4 px-4 border-b border-slate-100 font-semibold text-slate-800">Asus ROG Strix G15</td>
                <td class="py-4 px-4 border-b border-slate-100 text-slate-500">PROD-1024</td>
                <td class="py-4 px-4 border-b border-slate-100 font-bold text-lg text-slate-800">45</td>
                <td class="py-4 px-4 border-b border-slate-100 text-slate-500">10</td>
                <td class="py-4 px-4 border-b border-slate-100">
                    <span class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-bold">In Stock</span>
                </td>
                <td class="py-4 px-4 border-b border-slate-100">
                    <input type="number" class="w-20 border border-slate-300 rounded px-2 py-1 text-sm outline-none" value="45">
                </td>
            </tr>
            <tr class="hover:bg-slate-50 transition-colors bg-red-50/30">
                <td class="py-4 px-4 border-b border-slate-100 font-semibold text-slate-800">Logitech Gaming Mouse</td>
                <td class="py-4 px-4 border-b border-slate-100 text-slate-500">PROD-3099</td>
                <td class="py-4 px-4 border-b border-slate-100 font-bold text-lg text-red-600">02</td>
                <td class="py-4 px-4 border-b border-slate-100 text-slate-500">15</td>
                <td class="py-4 px-4 border-b border-slate-100">
                    <span class="bg-red-100 text-red-700 px-3 py-1 rounded-full text-xs font-bold">Low Stock</span>
                </td>
                <td class="py-4 px-4 border-b border-slate-100">
                    <input type="number" class="w-20 border border-slate-300 rounded px-2 py-1 text-sm outline-none" value="2">
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>