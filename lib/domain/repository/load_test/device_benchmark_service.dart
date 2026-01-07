import 'dart:async';
import 'dart:math';

import '../../model/request_client_model/request_execution_input.dart';
import '../request_client/request_execution_service.dart';

/// ===============================================================
/// DEVICE BENCHMARK SERVICE
/// ---------------------------------------------------------------
/// Runs a micro-benchmark on the device to determine:
/// - Maximum stable concurrency (Virtual Users)
/// - Baseline latency
/// - Degradation point
///
/// This is used to cap load testing on mobile devices.
/// ===============================================================

class DeviceBenchmarkService {
  final RequestExecutionService _executor;

  DeviceBenchmarkService({RequestExecutionService? executor})
    : _executor = executor ?? RequestExecutionService();

  /// Run device benchmark and return capacity result
  Future<BenchmarkResult> runBenchmark({
    required String testUrl,
    String method = 'GET',
    Duration timeout = const Duration(seconds: 8),
  }) async {
    // Concurrency steps (can be tuned later)
    final List<int> steps = [2, 5, 10, 15, 20, 30, 40, 50];

    double? baselineLatency;
    int? maxStable;
    int? degradationPoint;

    for (final concurrency in steps) {
      final metrics = await _runWave(
        concurrency: concurrency,
        testUrl: testUrl,
        method: method,
        timeout: timeout,
      );

      // Capture baseline from first run
      baselineLatency ??= metrics.averageLatencyMs;

      final bool isDegrading = _isDegrading(
        baselineLatencyMs: baselineLatency!,
        avgLatencyMs: metrics.averageLatencyMs,
        errorRate: metrics.errorRate,
      );

      if (isDegrading) {
        degradationPoint = concurrency;
        break;
      }

      maxStable = concurrency;
    }

    return BenchmarkResult(
      maxStableConcurrency: maxStable ?? steps.first,
      baselineLatencyMs: baselineLatency?.round() ?? 0,
      degradationPoint: degradationPoint,
      testedAt: DateTime.now(),
    );
  }

  // ============================================================
  // Run one benchmark wave at a given concurrency
  // ============================================================
  Future<_BenchmarkWaveMetrics> _runWave({
    required int concurrency,
    required String testUrl,
    required String method,
    required Duration timeout,
  }) async {
    final List<Future<_SingleRequestResult>> tasks = [];

    for (int i = 0; i < concurrency; i++) {
      tasks.add(_executeSingle(testUrl, method, timeout));
    }

    final results = await Future.wait(tasks);

    int successCount = 0;
    int failureCount = 0;
    int totalLatency = 0;

    for (final r in results) {
      if (r.success) {
        successCount++;
        totalLatency += r.latencyMs;
      } else {
        failureCount++;
      }
    }

    final int total = results.length;
    final double avgLatency =
        successCount == 0 ? double.infinity : totalLatency / successCount;
    final double errorRate = total == 0 ? 1.0 : failureCount / total;

    return _BenchmarkWaveMetrics(
      concurrency: concurrency,
      averageLatencyMs: avgLatency,
      errorRate: errorRate,
    );
  }

  // ============================================================
  // Execute a single lightweight request
  // ============================================================
  Future<_SingleRequestResult> _executeSingle(
    String url,
    String method,
    Duration timeout,
  ) async {
    try {
      final stopwatch = Stopwatch()..start();

      final input = RequestExecutionInput(
        method: method,
        url: url,
        headers: const {},
        queryParams: const {},
        body: null,
        contentType: null,
      );

      await _executor.executeRaw(input: input, timeout: timeout);

      stopwatch.stop();

      return _SingleRequestResult(
        success: true,
        latencyMs: stopwatch.elapsedMilliseconds,
      );
    } catch (_) {
      return _SingleRequestResult(success: false, latencyMs: 0);
    }
  }

  // ============================================================
  // Determine if performance is degrading
  // ============================================================
  bool _isDegrading({
    required double baselineLatencyMs,
    required double avgLatencyMs,
    required double errorRate,
  }) {
    // Thresholds (can be tuned)
    const double maxLatencyMultiplier = 2.0; // 2× baseline
    const double maxErrorRate = 0.05; // 5%

    if (avgLatencyMs > baselineLatencyMs * maxLatencyMultiplier) {
      return true;
    }

    if (errorRate > maxErrorRate) {
      return true;
    }

    return false;
  }
}

/// ===============================================================
/// RESULT MODELS
/// ===============================================================

class BenchmarkResult {
  final int maxStableConcurrency;
  final int baselineLatencyMs;
  final int? degradationPoint;
  final DateTime testedAt;

  BenchmarkResult({
    required this.maxStableConcurrency,
    required this.baselineLatencyMs,
    required this.degradationPoint,
    required this.testedAt,
  });
}

/// Internal: single wave metrics
class _BenchmarkWaveMetrics {
  final int concurrency;
  final double averageLatencyMs;
  final double errorRate;

  _BenchmarkWaveMetrics({
    required this.concurrency,
    required this.averageLatencyMs,
    required this.errorRate,
  });
}

/// Internal: single request result
class _SingleRequestResult {
  final bool success;
  final int latencyMs;

  _SingleRequestResult({required this.success, required this.latencyMs});
}
