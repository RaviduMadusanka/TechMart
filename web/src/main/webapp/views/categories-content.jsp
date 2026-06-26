<div class="flex flex-col xl:flex-row gap-6">

    <div class="bg-white p-6 rounded-2xl shadow-sm border border-slate-100 flex-1">

        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6 gap-4">
            <div>
                <h3 class="text-xl font-bold text-slate-800">Product Categories</h3>
                <p class="text-sm text-slate-500 mt-1">Manage and organize your product catalog.</p>
            </div>

            <div class="relative w-full sm:w-72">
                <input type="text" placeholder="Search categories..."
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
                    <th class="py-3.5 px-5 font-semibold border-b border-slate-200">Category Name</th>
                    <th class="py-3.5 px-5 font-semibold border-b border-slate-200">Status</th>
                    <th class="py-3.5 px-5 font-semibold border-b border-slate-200 text-right">Actions</th>
                </tr>
                </thead>
                <tbody class="text-sm divide-y divide-slate-100" id="categoryTableBody">
                <tr>
                    <td colspan="3" class="text-center py-10">
                        <div class="animate-spin w-6 h-6 border-2 border-brand-500 border-t-transparent rounded-full mx-auto"></div>
                        <p class="text-slate-500 mt-2 text-sm font-medium">Loading categories...</p>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="flex items-center justify-between mt-6">
            <p class="text-sm text-slate-500">Showing <span id="pageStart" class="font-medium text-slate-700">0</span> to <span id="pageEnd" class="font-medium text-slate-700">0</span> of <span id="pageTotal" class="font-medium text-slate-700">0</span> categories</p>
            <div class="flex gap-2">
                <button id="btnPrev" onclick="prevPage()" disabled class="px-3 py-1.5 border border-slate-200 text-slate-400 rounded-lg text-sm font-medium cursor-not-allowed transition-colors">Previous</button>
                <button id="btnCurrentPage" class="px-3 py-1.5 bg-brand-50 text-brand-600 rounded-lg text-sm font-medium">1</button>
                <button id="btnNext" onclick="nextPage()" disabled class="px-3 py-1.5 border border-slate-200 text-slate-400 rounded-lg text-sm font-medium cursor-not-allowed transition-colors">Next</button>
            </div>
        </div>

    </div>

    <div class="w-full xl:w-[350px]">
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-slate-100 sticky top-6">

            <div class="flex items-center gap-3 mb-6 pb-4 border-b border-slate-100">
                <div class="w-10 h-10 bg-slate-900 text-white rounded-xl flex items-center justify-center shadow-md">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                </div>
                <div>
                    <h3 class="text-lg font-bold text-slate-800">New Category</h3>
                    <p class="text-xs text-slate-500">Add to catalog</p>
                </div>
            </div>

            <form id="addCategoryForm" class="space-y-5">
                <div>
                    <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Category Name *</label>
                    <input type="text" id="categoryName" name="name" required placeholder="e.g. Smart Watches"
                           class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-brand-500 focus:bg-white focus:ring-2 focus:ring-brand-500/20 transition-all font-medium text-slate-800">
                </div>

                <button type="submit" class="w-full bg-brand-500 hover:bg-brand-600 text-white font-semibold py-3 rounded-xl transition-all shadow-md shadow-brand-500/30 flex items-center justify-center gap-2 active:scale-[0.98]">
                    <span>Save Category</span>
                </button>
            </form>

            <div class="mt-6 pt-5 border-t border-slate-100">
                <div class="bg-blue-50 text-blue-700 p-3 rounded-xl text-xs flex items-start gap-2">
                    <svg class="w-4 h-4 shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"></path></svg>
                    <span>Categories you add here will immediately be available in the Product creation dropdown.</span>
                </div>
            </div>

        </div>
    </div>
</div>
<script>
    if (typeof CONTEXT_PATH === 'undefined') {
        var CONTEXT_PATH = '${pageContext.request.contextPath}';
    }
</script>
<script src="${pageContext.request.contextPath}/js/category-content.js"></script>