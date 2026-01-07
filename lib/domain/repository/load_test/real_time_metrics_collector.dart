import 'dart:async';
import 'dart:isolate';
import '../../model/load_test/live_metrics_model.dart';

/// ===============================================================
/// REAL-TIME METRICS COLLECTOR
/// ---------------------------------------------------------------
/// Aggregates request results in real time and emits metrics
/// snapshots at a fixed interval (default: 1s).
///
/// Runs in an Isolate to avoid blocking UI or network execution.
/// ===============================================================

class RealTimeMetricsCollector {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _sendPort;

  /// Stream of live metrics snapshots for UI / Bloc
  final StreamController<LoadTestLiveMetrics> _metricsController =
      StreamController.broadcast();

  Stream<LoadTestLiveMetrics> get stream => _metricsController.stream;

  /// Start the collector isolate
  Future<void> start({Duration emitInterval = const Duration(seconds: 1)}) async {
    if (_isolate != null) return;

    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn<_IsolateInitMessage>(
      _collectorIsolateEntry,
      _IsolateInitMessage(
        mainSendPort: _receivePort!.sendPort,
        emitIntervalMs: emitInterval.inMilliseconds,
      ),
    );

    _receivePort!.listen((message) {
      if (message is SendPort) {
        // First message: isolate's SendPort
        _sendPort = message;
      } else if (message is LoadTestLiveMetrics) {
        // Metrics snapshot
        _metricsController.add(message);
      }
    });
  }

  /// Stop the collector isolate
  Future<void> stop() async {
    _sendPort?.send(_IsolateCommand.stop);
    _sendPort = null;
    _receivePort?.close();
    _receivePort = null;
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }

  /// Record one request result (called by LoadTestRunnerService)
  void record(RequestResultEvent event) {
    _sendPort?.send(event);
  }
}

/// ===============================================================
/// ISOLATE IMPLEMENTATION
/// ===============================================================

enum _IsolateCommand { stop }

class _IsolateInitMessage {
  final SendPort mainSendPort;
  final int emitIntervalMs;

  _IsolateInitMessage({
    required this.mainSendPort,
    required this.emitIntervalMs,
  });
}

/// Entry point for the collector isolate
void _collectorIsolateEntry(_IsolateInitMessage init) {
  final ReceivePort isolateReceivePort = ReceivePort();
  init.mainSendPort.send(isolateReceivePort.sendPort);

  // Rolling counters
  int totalRequests = 0;
  int successCount = 0;
  int failureCount = 0;

  // Windowed metrics (reset every emit interval)
  int windowCount = 0;
  int windowSuccess = 0;
  int windowFailure = 0;
  int windowLatencySum = 0;
  int activeUsers = 0;

  // Time-series buffer (cap to last N points)
  const int maxPoints = 300;
  final List<GraphPoint> series = [];

  Timer? timer;

  void emitSnapshot() {
    final now = DateTime.now().millisecondsSinceEpoch;

    final double avgLatency =
        windowCount == 0 ? 0 : windowLatencySum / windowCount;
    final double rps =
        (windowCount * 1000.0) / init.emitIntervalMs;
    final double errorRate = windowCount == 0
        ? 0
        : (windowFailure * 100.0) / windowCount;

    final point = GraphPoint(
      timestampMs: now,
      rps: rps,
      avgLatencyMs: avgLatency,
      errorRate: errorRate,
      activeUsers: activeUsers,
    );

    series.add(point);
    if (series.length > maxPoints) {
      series.removeAt(0);
    }

    init.mainSendPort.send(
      LoadTestLiveMetrics(
        activeUsers: activeUsers,
        totalRequests: totalRequests,
        successCount: successCount,
        failureCount: failureCount,
        avgLatencyMs: avgLatency,
        rps: rps,
        errorRate: errorRate,
        series: List.unmodifiable(series),
      ),
    );

    // Reset window
    windowCount = 0;
    windowSuccess = 0;
    windowFailure = 0;
    windowLatencySum = 0;
  }

  // Periodic emitter
  timer = Timer.periodic(
    Duration(milliseconds: init.emitIntervalMs),
    (_) => emitSnapshot(),
  );

  isolateReceivePort.listen((message) {
    if (message == _IsolateCommand.stop) {
      timer?.cancel();
      isolateReceivePort.close();
      return;
    }

    if (message is RequestResultEvent) {
      // Update totals
      totalRequests++;
      activeUsers = message.activeUsers;

      // Update window
      windowCount++;
      windowLatencySum += message.latencyMs;

      if (message.success) {
        successCount++;
        windowSuccess++;
      } else {
        failureCount++;
        windowFailure++;
      }
    }
  });
}
