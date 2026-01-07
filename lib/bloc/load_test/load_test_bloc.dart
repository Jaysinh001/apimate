import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/model/load_test/live_metrics_model.dart';
import '../../../domain/model/load_test/load_test_config.dart';
import '../../../domain/model/request_client_model/request_execution_input.dart';
import '../../domain/repository/load_test/load_test_runner_service.dart';

part 'load_test_event.dart';
part 'load_test_state.dart';

class LoadTestBloc extends Bloc<LoadTestEvent, LoadTestState> {
  final LoadTestRunnerService _runner;
  StreamSubscription? _metricsSub;

  LoadTestBloc({LoadTestRunnerService? runner})
      : _runner = runner ?? LoadTestRunnerService(),
        super(const LoadTestState()) {
    on<StartLoadTest>(_handleStart);
    on<LiveMetricsUpdated>(_handleLiveMetrics);
    on<StopLoadTest>(_handleStop);
  }

  // =========================
  // START
  // =========================
  Future<void> _handleStart(
    StartLoadTest event,
    Emitter<LoadTestState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LoadTestStatus.running));

      // Listen to live metrics
      _metricsSub = _runner.liveStream.listen((metrics) {
        add(LiveMetricsUpdated(metrics));
      });

      // Run test
      await _runner.runLoadTest(
        requests: event.requests,
        config: event.config,
      );

      emit(state.copyWith(status: LoadTestStatus.completed));
    } catch (e) {
      emit(
        state.copyWith(
          status: LoadTestStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  // =========================
  // LIVE UPDATES
  // =========================
  void _handleLiveMetrics(
    LiveMetricsUpdated event,
    Emitter<LoadTestState> emit,
  ) {
    emit(state.copyWith(liveMetrics: event.metrics));
  }

  // =========================
  // STOP
  // =========================
  Future<void> _handleStop(
    StopLoadTest event,
    Emitter<LoadTestState> emit,
  ) async {
    await _metricsSub?.cancel();
    emit(state.copyWith(status: LoadTestStatus.stopped));
  }

  @override
  Future<void> close() {
    _metricsSub?.cancel();
    return super.close();
  }
}
