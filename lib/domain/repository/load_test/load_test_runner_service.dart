import 'dart:async';
import '../../model/load_test/live_metrics_model.dart';
import '../../model/load_test/load_test_config.dart';
import '../../model/request_client_model/request_execution_input.dart';
import '../load_test/device_benchmark_service.dart';
import '../load_test/real_time_metrics_collector.dart';
import '../request_client/request_execution_service.dart';


class LoadTestRunnerService {
  final RequestExecutionService _executor;
  final DeviceBenchmarkService _benchmarkService;
  final RealTimeMetricsCollector _collector;

  LoadTestRunnerService({
    RequestExecutionService? executor,
    DeviceBenchmarkService? benchmarkService,
    RealTimeMetricsCollector? collector,
  })  : _executor = executor ?? RequestExecutionService(),
        _benchmarkService = benchmarkService ?? DeviceBenchmarkService(),
        _collector = collector ?? RealTimeMetricsCollector();

  Stream<LoadTestLiveMetrics> get liveStream => _collector.stream;

  // =========================
  // ENTRY POINT
  // =========================
  Future<void> runLoadTest({
    required List<RequestExecutionInput> requests,
    required LoadTestConfig config,
  }) async {
    // 1️⃣ Benchmark device
    final benchmark = await _benchmarkService.runBenchmark(
      testUrl: requests.first.url,
    );

    // 2️⃣ Cap VUs
    final cappedConfig = config.applyDeviceCap(
      benchmark.maxStableConcurrency,
    );

    // 3️⃣ Start metrics collector
    await _collector.start();

    // 4️⃣ Execute based on profile
    switch (cappedConfig.profile) {
      case LoadProfileType.fixed:
        await _runFixed(
          requests: requests,
          vus: cappedConfig.requestedVUs,
          duration: cappedConfig.durationSeconds,
        );
        break;

      case LoadProfileType.rampUp:
        await _runRampUp(
          requests: requests,
          start: cappedConfig.rampStart ?? 1,
          end: cappedConfig.requestedVUs,
          duration: cappedConfig.durationSeconds,
        );
        break;

      case LoadProfileType.spike:
        await _runSpike(
          requests: requests,
          peak: cappedConfig.requestedVUs,
          spikeAt: cappedConfig.spikeAtSecond ?? 10,
          duration: cappedConfig.durationSeconds,
        );
        break;

      case LoadProfileType.peak:
        await _runPeak(
          requests: requests,
          peak: cappedConfig.requestedVUs,
          peakDuration: cappedConfig.peakDuration ?? 10,
          duration: cappedConfig.durationSeconds,
        );
        break;
    }

    // 5️⃣ Stop collector after completion
    await _collector.stop();
  }

  // ============================================================
  // PROFILES
  // ============================================================

  Future<void> _runFixed({
    required List<RequestExecutionInput> requests,
    required int vus,
    required int duration,
  }) async {
    final endTime = DateTime.now().add(Duration(seconds: duration));

    while (DateTime.now().isBefore(endTime)) {
      final tasks = List.generate(
        vus,
        (i) => _executeAndRecord(
          input: requests[i % requests.length],
          activeUsers: vus,
        ),
      );
      await Future.wait(tasks);
    }
  }

  Future<void> _runRampUp({
    required List<RequestExecutionInput> requests,
    required int start,
    required int end,
    required int duration,
  }) async {
    final steps = duration;
    final increment = (end - start) / steps;

    for (int t = 0; t < duration; t++) {
      final currentVUs = (start + increment * t).round().clamp(1, end);

      final tasks = List.generate(
        currentVUs,
        (i) => _executeAndRecord(
          input: requests[i % requests.length],
          activeUsers: currentVUs,
        ),
      );

      await Future.wait(tasks);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> _runSpike({
    required List<RequestExecutionInput> requests,
    required int peak,
    required int spikeAt,
    required int duration,
  }) async {
    for (int t = 0; t < duration; t++) {
      final currentVUs = t >= spikeAt ? peak : 1;

      final tasks = List.generate(
        currentVUs,
        (i) => _executeAndRecord(
          input: requests[i % requests.length],
          activeUsers: currentVUs,
        ),
      );

      await Future.wait(tasks);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> _runPeak({
    required List<RequestExecutionInput> requests,
    required int peak,
    required int peakDuration,
    required int duration,
  }) async {
    final rampTime = (duration - peakDuration) ~/ 2;

    for (int t = 0; t < duration; t++) {
      int currentVUs;

      if (t < rampTime) {
        currentVUs = (peak * t / rampTime).round().clamp(1, peak);
      } else if (t < rampTime + peakDuration) {
        currentVUs = peak;
      } else {
        final down = t - (rampTime + peakDuration);
        currentVUs =
            (peak * (1 - down / rampTime)).round().clamp(1, peak);
      }

      final tasks = List.generate(
        currentVUs,
        (i) => _executeAndRecord(
          input: requests[i % requests.length],
          activeUsers: currentVUs,
        ),
      );

      await Future.wait(tasks);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  // ============================================================
  // EXECUTE + RECORD METRICS
  // ============================================================
  Future<void> _executeAndRecord({
    required RequestExecutionInput input,
    required int activeUsers,
  }) async {
    try {
      final response = await _executor.executeRaw(input: input);

      _collector.record(
        RequestResultEvent(
          latencyMs: response.durationMs,
          success: !response.isError,
          activeUsers: activeUsers,
        ),
      );
    } catch (_) {
      _collector.record(
        const RequestResultEvent(
          latencyMs: 0,
          success: false,
          activeUsers: 0,
        ),
      );
    }
  }
}
