import 'dart:async';

import '../../model/request_client_model/request_execution_input.dart';
import '../request_client/request_execution_service.dart';

/// ===============================================================
/// DEVICE BENCHMARK SERVICE
/// ---------------------------------------------------------------
/// Runs an adaptive micro-benchmark on the device to determine:
/// - Maximum stable concurrency (Virtual Users)
/// - Baseline latency
/// - Degradation point
///
/// Uses progressive scaling instead of fixed caps (e.g., 50 VUs)
/// to discover the *real* capacity of the phone.
///
/// This value is used to cap load testing on mobile devices.
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
    double? baselineLatency;
    int? maxStable;
    int? degradationPoint;

    // ------------------------------------------------------------
    // Warm-up run (avoid cold-start bias)
    // ------------------------------------------------------------
    await _runWave(
      concurrency: 2,
      testUrl: testUrl,
      method: method,
      timeout: timeout,
    );

    // ------------------------------------------------------------
    // Adaptive progressive scaling
    // ------------------------------------------------------------
    int concurrency = 5;
    const int maxLimit = 500; // safety cap to protect devices

    while (concurrency <= maxLimit) {
      final metrics = await _runWave(
        concurrency: concurrency,
        testUrl: testUrl,
        method: method,
        timeout: timeout,
      );

      // Capture baseline from first real run
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

      // Progressive ramp strategy
      if (concurrency < 50) {
        concurrency += 5;
      } else if (concurrency < 150) {
        concurrency += 10;
      } else {
        concurrency += 25;
      }
    }

    return BenchmarkResult(
      maxStableConcurrency: maxStable ?? 5,
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
    // Tunable thresholds
    const double maxLatencyMultiplier = 2.0; // 2× baseline
    const double maxErrorRate = 0.05; // 5%

    if (errorRate > maxErrorRate) {
      return true;
    }

    if (avgLatencyMs > baselineLatencyMs * maxLatencyMultiplier) {
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

  // Create a BenchmarkResult from a JSON map
  factory BenchmarkResult.fromJson(Map<String, dynamic> json) {
    return BenchmarkResult(
      maxStableConcurrency: json['max_stable_concurrency'] as int,
      baselineLatencyMs: json['baseline_latency_ms'] as int,
      degradationPoint: json['degradation_point'] as int?,
      testedAt: DateTime.parse(json['tested_at'] as String),
    );
  }

  // Convert a BenchmarkResult instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'max_stable_concurrency': maxStableConcurrency,
      'baseline_latency_ms': baselineLatencyMs,
      'degradation_point': degradationPoint,
      'tested_at': testedAt.toIso8601String(),
    };
  }
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
