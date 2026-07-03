<div class="bg-white rounded-2xl shadow-sm p-8 mb-6 border-l-8 border-brand-500">
    <div class="flex justify-between items-center flex-wrap gap-4">
        <div>
            <h2 class="text-2xl font-bold text-slate-800">Performance Monitoring</h2>
            <p class="text-slate-500 mt-1">Live method-level timing captured by <code>PerformanceInterceptor</code> on the core session beans (Product, Order, Cart, Inventory, Customer).</p>
        </div>
        <div class="flex gap-3">
            <button id="btn-refresh" class="bg-brand-500 hover:bg-brand-600 text-white px-5 py-2.5 rounded-xl font-semibold transition">Refresh</button>
            <button id="btn-reset" class="bg-red-500 hover:bg-red-600 text-white px-5 py-2.5 rounded-xl font-semibold transition">Reset Stats</button>
        </div>
    </div>
</div>

<div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
    <div class="bg-white p-6 rounded-2xl shadow-sm border-l-4 border-brand-500">
        <h4 class="text-slate-500">Monitored Methods</h4>
        <h2 id="perf-method-count" class="text-4xl font-bold mt-3 text-slate-800">0</h2>
    </div>
    <div class="bg-white p-6 rounded-2xl shadow-sm border-l-4 border-green-500">
        <h4 class="text-slate-500">Total Invocations</h4>
        <h2 id="perf-total-calls" class="text-4xl font-bold mt-3 text-slate-800">0</h2>
    </div>
    <div class="bg-white p-6 rounded-2xl shadow-sm border-l-4 border-yellow-500">
        <h4 class="text-slate-500">Slowest Avg (ms)</h4>
        <h2 id="perf-slowest" class="text-4xl font-bold mt-3 text-slate-800">-</h2>
    </div>
</div>

<div class="bg-white rounded-2xl shadow-sm p-8">
    <h3 class="text-xl font-bold text-slate-800 mb-4">Method Timing Breakdown</h3>
    <div class="overflow-x-auto">
        <table class="w-full text-left">
            <thead>
            <tr class="text-slate-500 text-sm border-b">
                <th class="py-3 pr-4">Method</th>
                <th class="py-3 pr-4">Calls</th>
                <th class="py-3 pr-4">Avg (ms)</th>
                <th class="py-3 pr-4">Min (ms)</th>
                <th class="py-3 pr-4">Max (ms)</th>
                <th class="py-3 pr-4">Total (ms)</th>
                <th class="py-3 pr-4 w-1/4">Relative Load</th>
            </tr>
            </thead>
            <tbody id="perf-table-body">
            <tr>
                <td colspan="7" class="py-6 text-center text-slate-400">Loading metrics...</td>
            </tr>
            </tbody>
        </table>
    </div>
    <p class="text-slate-400 text-xs mt-4">Tip: browse Products / Orders / Cart pages first so the interceptor has invocations to record, then hit Refresh.</p>
</div>

<script>
    (function () {
        const ctxPath = '<%= request.getContextPath() %>';
        const tbody = document.getElementById('perf-table-body');

        function escapeHtml(str) {
            const d = document.createElement('div');
            d.innerText = str;
            return d.innerHTML;
        }

        function loadMetrics() {
            fetch(ctxPath + '/api/performance')
                .then(r => r.json())
                .then(data => {
                    if (data.error) {
                        tbody.innerHTML = '<tr><td colspan="7" class="py-6 text-center text-red-400">' + escapeHtml(data.error) + '</td></tr>';
                        return;
                    }

                    const metrics = data.metrics || [];
                    document.getElementById('perf-method-count').innerText = data.methodCount || 0;

                    let totalCalls = 0;
                    let slowestAvg = 0;
                    let maxTotal = 0;
                    metrics.forEach(m => {
                        totalCalls += m.invocationCount;
                        if (m.avgTimeMs > slowestAvg) slowestAvg = m.avgTimeMs;
                        if (m.totalTimeMs > maxTotal) maxTotal = m.totalTimeMs;
                    });
                    document.getElementById('perf-total-calls').innerText = totalCalls.toLocaleString();
                    document.getElementById('perf-slowest').innerText = metrics.length ? slowestAvg.toFixed(2) : '-';

                    if (metrics.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="7" class="py-6 text-center text-slate-400">No invocations recorded yet.</td></tr>';
                        return;
                    }

                    tbody.innerHTML = metrics.map(m => {
                        const widthPct = maxTotal > 0 ? Math.max(4, Math.round((m.totalTimeMs / maxTotal) * 100)) : 0;
                        return '<tr class="border-b last:border-0">' +
                            '<td class="py-3 pr-4 font-mono text-sm text-slate-700">' + escapeHtml(m.methodName) + '</td>' +
                            '<td class="py-3 pr-4">' + m.invocationCount + '</td>' +
                            '<td class="py-3 pr-4">' + m.avgTimeMs.toFixed(2) + '</td>' +
                            '<td class="py-3 pr-4">' + m.minTimeMs.toFixed(2) + '</td>' +
                            '<td class="py-3 pr-4">' + m.maxTimeMs.toFixed(2) + '</td>' +
                            '<td class="py-3 pr-4">' + m.totalTimeMs + '</td>' +
                            '<td class="py-3 pr-4">' +
                            '<div class="w-full bg-slate-100 rounded-full h-3">' +
                            '<div class="bg-brand-500 h-3 rounded-full" style="width:' + widthPct + '%"></div>' +
                            '</div>' +
                            '</td>' +
                            '</tr>';
                    }).join('');
                })
                .catch(err => {
                    tbody.innerHTML = '<tr><td colspan="7" class="py-6 text-center text-red-400">Failed to load metrics</td></tr>';
                    console.error('Error loading performance metrics:', err);
                });
        }

        document.getElementById('btn-refresh').addEventListener('click', loadMetrics);
        document.getElementById('btn-reset').addEventListener('click', function () {
            fetch(ctxPath + '/api/performance?action=reset').then(loadMetrics);
        });

        loadMetrics();
    })();
</script>
