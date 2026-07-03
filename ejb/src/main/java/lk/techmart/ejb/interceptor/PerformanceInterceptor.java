package lk.techmart.ejb.interceptor;

import jakarta.ejb.EJB;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;
import lk.techmart.core.service.PerformanceMonitorService;

public class PerformanceInterceptor {

    @EJB
    private PerformanceMonitorService metricsCollector;

    @AroundInvoke
    public Object monitor(InvocationContext ctx) throws Exception {
        long start = System.nanoTime();
        try {
            return ctx.proceed();
        } finally {
            long durationNanos = System.nanoTime() - start;
            String methodKey = ctx.getTarget().getClass().getSimpleName() + "." + ctx.getMethod().getName();

            if (metricsCollector != null) {
                metricsCollector.record(methodKey, durationNanos);
            }

            long durationMs = durationNanos / 1_000_000;
            if (durationMs > 200) {
                System.out.println("SLOW METHOD: " + methodKey + " took " + durationMs + " ms");
            }
        }
    }
}
