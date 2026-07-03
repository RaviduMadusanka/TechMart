package lk.techmart.ejb;

import jakarta.annotation.PostConstruct;
import jakarta.ejb.Lock;
import jakarta.ejb.LockType;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import lk.techmart.core.dto.PerformanceMetricDTO;
import lk.techmart.core.service.PerformanceMonitorService;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Singleton
@Startup
public class MetricsCollectorBean implements PerformanceMonitorService {

    private Map<String, MethodStat> statsMap;

    @PostConstruct
    public void init() {
        statsMap = new ConcurrentHashMap<>();
        System.out.println("📈 Performance MetricsCollectorBean started!");
    }

    @Override
    @Lock(LockType.WRITE)
    public void record(String methodKey, long durationNanos) {
        statsMap.computeIfAbsent(methodKey, k -> new MethodStat()).record(durationNanos);
    }

    @Override
    @Lock(LockType.READ)
    public List<PerformanceMetricDTO> getMetrics() {
        List<PerformanceMetricDTO> list = new ArrayList<>();
        for (Map.Entry<String, MethodStat> entry : statsMap.entrySet()) {
            list.add(entry.getValue().toDTO(entry.getKey()));
        }
        list.sort(Comparator.comparingLong(PerformanceMetricDTO::getTotalTimeMs).reversed());
        return list;
    }

    @Override
    @Lock(LockType.WRITE)
    public void reset() {
        statsMap.clear();
    }

    private static class MethodStat {
        private long count = 0;
        private long totalNanos = 0;
        private long minNanos = Long.MAX_VALUE;
        private long maxNanos = 0;

        synchronized void record(long durationNanos) {
            count++;
            totalNanos += durationNanos;
            if (durationNanos < minNanos) minNanos = durationNanos;
            if (durationNanos > maxNanos) maxNanos = durationNanos;
        }

        synchronized PerformanceMetricDTO toDTO(String methodName) {
            PerformanceMetricDTO dto = new PerformanceMetricDTO();
            dto.setMethodName(methodName);
            dto.setInvocationCount(count);
            dto.setTotalTimeMs(totalNanos / 1_000_000);
            dto.setAvgTimeMs(count == 0 ? 0.0 : (totalNanos / (double) count) / 1_000_000.0);
            dto.setMinTimeMs(minNanos == Long.MAX_VALUE ? 0.0 : minNanos / 1_000_000.0);
            dto.setMaxTimeMs(maxNanos / 1_000_000.0);
            return dto;
        }
    }
}
