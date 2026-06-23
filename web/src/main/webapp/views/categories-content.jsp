<div class="bg-white p-8 rounded-2xl shadow-sm">
    <div class="flex justify-between items-center mb-6">
        <h3 class="text-xl font-bold text-slate-800">Product Categories</h3>
        <button class="bg-slate-800 hover:bg-slate-900 text-white font-semibold py-2 px-5 rounded-xl transition-all shadow-sm">
            + Create Category
        </button>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="border border-slate-200 p-5 rounded-xl hover:shadow-md transition cursor-pointer">
            <div class="text-3xl mb-2">💻</div>
            <h4 class="font-bold text-lg text-slate-800">Laptops</h4>
            <p class="text-sm text-slate-500 mt-1">45 Active Products</p>
        </div>
        <div class="border border-slate-200 p-5 rounded-xl hover:shadow-md transition cursor-pointer">
            <div class="text-3xl mb-2">📱</div>
            <h4 class="font-bold text-lg text-slate-800">Smartphones</h4>
            <p class="text-sm text-slate-500 mt-1">120 Active Products</p>
        </div>
        <div class="border border-slate-200 p-5 rounded-xl hover:shadow-md transition cursor-pointer border-dashed bg-slate-50 flex items-center justify-center flex-col">
            <div class="text-3xl text-slate-300 mb-2">➕</div>
            <h4 class="font-semibold text-slate-500">Add New Category</h4>
        </div>
    </div>

    <div class="bg-slate-50 p-6 rounded-xl border border-slate-200">
        <h4 class="font-semibold text-slate-700 mb-4">Quick Add Category</h4>
        <form class="flex gap-4">
            <input type="text" placeholder="Category Name" class="flex-1 bg-white border border-slate-300 rounded-lg px-4 py-2 outline-none focus:border-brand-500">
            <button type="button" class="bg-brand-500 text-white px-6 py-2 rounded-lg font-medium hover:bg-brand-600">Save</button>
        </form>
    </div>
</div>