package lk.techmart.core.dto;

import java.io.Serializable;

public class PerformanceMetricDTO implements Serializable {

    private String methodName;
    private long invocationCount;
    private double avgTimeMs;
    private double minTimeMs;
    private double maxTimeMs;
    private long totalTimeMs;

    public PerformanceMetricDTO() {
    }

    public String getMethodName() {
        return methodName;
    }

    public void setMethodName(String methodName) {
        this.methodName = methodName;
    }

    public long getInvocationCount() {
        return invocationCount;
    }

    public void setInvocationCount(long invocationCount) {
        this.invocationCount = invocationCount;
    }

    public double getAvgTimeMs() {
        return avgTimeMs;
    }

    public void setAvgTimeMs(double avgTimeMs) {
        this.avgTimeMs = avgTimeMs;
    }

    public double getMinTimeMs() {
        return minTimeMs;
    }

    public void setMinTimeMs(double minTimeMs) {
        this.minTimeMs = minTimeMs;
    }

    public double getMaxTimeMs() {
        return maxTimeMs;
    }

    public void setMaxTimeMs(double maxTimeMs) {
        this.maxTimeMs = maxTimeMs;
    }

    public long getTotalTimeMs() {
        return totalTimeMs;
    }

    public void setTotalTimeMs(long totalTimeMs) {
        this.totalTimeMs = totalTimeMs;
    }
}
