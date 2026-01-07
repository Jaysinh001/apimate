/// ===============================================================
/// LIVE METRICS MODELS
/// ---------------------------------------------------------------
/// These models represent real-time metrics for load testing.
/// They are lightweight, immutable, and safe to pass between
/// isolates (simple value types only).
/// ===============================================================

class GraphPoint {
  /// Epoch milliseconds
  final int timestampMs;

  /// Requests per second in the last window
  final double rps;

  /// Average latency in milliseconds (last window)
  final double avgLatencyMs;

  /// Error rate in percentage (0..100)
  final double errorRate;

  /// Active virtual users at this moment
  final int activeUsers;

  const GraphPoint({
    required this.timestampMs,
    required this.rps,
    required this.avgLatencyMs,
    required this.errorRate,
    required this.activeUsers,
  });

  @override
  String toString() =>
      'GraphPoint(t=$timestampMs, rps=$rps, avg=${avgLatencyMs}ms, err=$errorRate%, vus=$activeUsers)';
}

/// Snapshot of live metrics for UI consumption
class LoadTestLiveMetrics {
  final int activeUsers;
  final int totalRequests;
  final int successCount;
  final int failureCount;

  /// Aggregates over the last window (e.g., 1s)
  final double avgLatencyMs;
  final double rps;
  final double errorRate;

  /// Time-series buffer for charts
  final List<GraphPoint> series;

  const LoadTestLiveMetrics({
    required this.activeUsers,
    required this.totalRequests,
    required this.successCount,
    required this.failureCount,
    required this.avgLatencyMs,
    required this.rps,
    required this.errorRate,
    required this.series,
  });

  static const empty = LoadTestLiveMetrics(
    activeUsers: 0,
    totalRequests: 0,
    successCount: 0,
    failureCount: 0,
    avgLatencyMs: 0,
    rps: 0,
    errorRate: 0,
    series: [],
  );

  @override
  String toString() =>
      'Live(active=$activeUsers, total=$totalRequests, ok=$successCount, fail=$failureCount, '
      'avg=${avgLatencyMs}ms, rps=$rps, err=$errorRate%)';
}

/// Internal event from the runner (one request result)
class RequestResultEvent {
  final int latencyMs;
  final bool success;
  final int activeUsers;

  const RequestResultEvent({
    required this.latencyMs,
    required this.success,
    required this.activeUsers,
  });
}
