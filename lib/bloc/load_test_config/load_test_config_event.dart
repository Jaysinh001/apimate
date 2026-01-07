part of 'load_test_config_bloc.dart';

abstract class LoadTestConfigEvent extends Equatable {
  const LoadTestConfigEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger device benchmark
class LoadDeviceBenchmark extends LoadTestConfigEvent {}

/// Update Virtual Users
class UpdateVUs extends LoadTestConfigEvent {
  final int value;
  const UpdateVUs(this.value);

  @override
  List<Object?> get props => [value];
}

/// Update duration
class UpdateDuration extends LoadTestConfigEvent {
  final int value;
  const UpdateDuration(this.value);

  @override
  List<Object?> get props => [value];
}

/// Change load profile
class UpdateProfile extends LoadTestConfigEvent {
  final LoadProfileType profile;
  const UpdateProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Advanced fields
class UpdateRampStart extends LoadTestConfigEvent {
  final int value;
  const UpdateRampStart(this.value);
}

class UpdateRampEnd extends LoadTestConfigEvent {
  final int value;
  const UpdateRampEnd(this.value);
}

class UpdateSpikeAt extends LoadTestConfigEvent {
  final int value;
  const UpdateSpikeAt(this.value);
}

class UpdatePeakDuration extends LoadTestConfigEvent {
  final int value;
  const UpdatePeakDuration(this.value);
}

/// Re-run device benchmark manually
class RecalibrateDevice extends LoadTestConfigEvent {}
