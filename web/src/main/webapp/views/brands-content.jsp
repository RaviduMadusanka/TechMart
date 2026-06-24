<div class="flex flex-col xl:flex-row gap-6">

    <!-- වම් පැත්ත: Brands Table එක -->
    <div class="bg-white p-6 rounded-2xl shadow-sm border border-slate-100 flex-1">

        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6 gap-4">
            <div>
                <h3 class="text-xl font-bold text-slate-800">Product Brands</h3>
                <p class="text-sm text-slate-500 mt-1">Manage all your product brands here.</p>
            </div>

            <!-- Search Box -->
            <div class="relative w-full sm:w-72">
                <input type="text" placeholder="Search brands..."
                       class="w-full bg-slate-50 border border-slate-200 rounded-xl pl-10 pr-4 py-2.5 text-sm focus:outline-none focus:border-brand-500 focus:bg-white focus:ring-2 focus:ring-brand-500/20 transition-all">
                <span class="absolute left-3.5 top-3 text-slate-400">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                </span>
            </div>
        </div>

        <div class="overflow-x-auto border border-slate-200 rounded-xl">
            <table class="w-full text-left border-collapse whitespace-nowrap">
                <thead>
                <tr class="bg-slate-50 text-slate-500 text-xs uppercase tracking-wider">
                    <th class="py-3.5 px-5 font-semibold border-b border-slate-200">Brand Name</th>
                    <th class="py-3.5 px-5 font-semibold border-b border-slate-200">Status</th>
                    <th class="py-3.5 px-5 font-semibold border-b border-slate-200 text-right">Actions</th>
                </tr>
                </thead>
                <tbody class="text-sm divide-y divide-slate-100" id="brandTableBody">
                <!-- Data එක JS වලින් Load වෙනවා -->
                </tbody>
            </table>
        </div>

        <div class="flex items-center justify-between mt-4 text-sm text-slate-500">
            <p id="brandCount">Loading...</p>
        </div>

    </div>

    <!-- දකුණු පැත්ත: අලුත් Brand එකක් Add කරන Form එක -->
    <div class="w-full xl:w-[350px]">
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-slate-100 sticky top-6">

            <div class="flex items-center gap-3 mb-6 pb-4 border-b border-slate-100">
                <div class="w-10 h-10 bg-slate-900 text-white rounded-xl flex items-center justify-center shadow-md">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                </div>
                <div>
                    <h3 class="text-lg font-bold text-slate-800">New Brand</h3>
                    <p class="text-xs text-slate-500">Add to catalog</p>
                </div>
            </div>

            <form id="addBrandForm" class="space-y-5">
                <div>
                    <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Brand Name *</label>
                    <input type="text" id="brandName" name="name" required placeholder="e.g. Asus"
                           class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-brand-500 focus:bg-white focus:ring-2 focus:ring-brand-500/20 transition-all font-medium text-slate-800">
                </div>

                <button type="submit" class="w-full bg-brand-500 hover:bg-brand-600 text-white font-semibold py-3 rounded-xl transition-all shadow-md shadow-brand-500/30 flex items-center justify-center gap-2 active:scale-[0.98]">
                    <span>Save Brand</span>
                </button>
            </form>

        </div>
    </div>

</div>

<!-- JS ලින්ක් කිරීම -->
<script>
    if (typeof CONTEXT_PATH === 'undefined') {
        var CONTEXT_PATH = '${pageContext.request.contextPath}';
    }
</script>
<script src="${pageContext.request.contextPath}/js/brands-content.js"></script>