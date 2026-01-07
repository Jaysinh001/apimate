part of 'load_test_bloc.dart';

abstract class LoadTestEvent extends Equatable {
  const LoadTestEvent();

  @override
  List<Object?> get props => [];
}

class StartLoadTest extends LoadTestEvent {
  final List<RequestExecutionInput> requests;
  final LoadTestConfig config;

  const StartLoadTest({
    required this.requests,
    required this.config,
  });

  @override
  List<Object?> get props => [requests, config];
}

class StopLoadTest extends LoadTestEvent {}

class LiveMetricsUpdated extends LoadTestEvent {
  final LoadTestLiveMetrics metrics;

  const LiveMetricsUpdated(this.metrics);

  @override
  List<Object?> get props => [metrics];
}
