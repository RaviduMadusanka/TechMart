package lk.techmart.core.service;

import jakarta.ejb.Local;
import lk.techmart.core.dto.PerformanceMetricDTO;

import java.util.List;

@Local
public interface PerformanceMonitorService {

    void record(String methodKey, long durationNanos);
    List<PerformanceMetricDTO> getMetrics();
    void reset();
}
