part of 'load_test_bloc.dart';

enum LoadTestStatus { initial, running, completed, stopped, error }

class LoadTestState extends Equatable {
  final LoadTestStatus status;
  final LoadTestLiveMetrics liveMetrics;
  final String? message;

  const LoadTestState({
    this.status = LoadTestStatus.initial,
    this.liveMetrics = LoadTestLiveMetrics.empty,
    this.message,
  });

  LoadTestState copyWith({
    LoadTestStatus? status,
    LoadTestLiveMetrics? liveMetrics,
    String? message,
  }) {
    return LoadTestState(
      status: status ?? this.status,
      liveMetrics: liveMetrics ?? this.liveMetrics,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, liveMetrics, message];
}
