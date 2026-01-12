part of 'load_test_config_bloc.dart';

enum LoadTestConfigStatus { initial, loading, ready, error }

class LoadTestConfigState extends Equatable {
  final LoadTestConfigStatus status;

  // Device benchmark
  final int maxDeviceVUs;
  final String? message;

  // Config values
  final int vus;
  final int duration;
  final LoadProfileType profile;

  final int rampStart;
  final int rampEnd;
  final int spikeAt;
  final int peakDuration;

  const LoadTestConfigState({
    this.status = LoadTestConfigStatus.initial,
    this.maxDeviceVUs = 500,
    this.message,
    this.vus = 10,
    this.duration = 30,
    this.profile = LoadProfileType.fixed,
    this.rampStart = 1,
    this.rampEnd = 10,
    this.spikeAt = 5,
    this.peakDuration = 5,
  });

  LoadTestConfigState copyWith({
    LoadTestConfigStatus? status,
    int? maxDeviceVUs,
    String? message,
    int? vus,
    int? duration,
    LoadProfileType? profile,
    int? rampStart,
    int? rampEnd,
    int? spikeAt,
    int? peakDuration,
  }) {
    return LoadTestConfigState(
      status: status ?? this.status,
      maxDeviceVUs: maxDeviceVUs ?? this.maxDeviceVUs,
      message: message,
      vus: vus ?? this.vus,
      duration: duration ?? this.duration,
      profile: profile ?? this.profile,
      rampStart: rampStart ?? this.rampStart,
      rampEnd: rampEnd ?? this.rampEnd,
      spikeAt: spikeAt ?? this.spikeAt,
      peakDuration: peakDuration ?? this.peakDuration,
    );
  }

  @override
  List<Object?> get props => [
    status,
    maxDeviceVUs,
    message,
    vus,
    duration,
    profile,
    rampStart,
    rampEnd,
    spikeAt,
    peakDuration,
  ];
}
