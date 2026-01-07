import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/model/load_test/load_test_config.dart';
import '../../domain/repository/load_test/device_benchmark_service.dart';

part 'load_test_config_event.dart';
part 'load_test_config_state.dart';

class LoadTestConfigBloc
    extends Bloc<LoadTestConfigEvent, LoadTestConfigState> {
  final DeviceBenchmarkService _benchmarkService;

  LoadTestConfigBloc({DeviceBenchmarkService? benchmarkService})
      : _benchmarkService = benchmarkService ?? DeviceBenchmarkService(),
        super(const LoadTestConfigState()) {
    on<LoadDeviceBenchmark>(_handleLoadBenchmark);
    on<UpdateVUs>(_handleUpdateVUs);
    on<UpdateDuration>(_handleUpdateDuration);
    on<UpdateProfile>(_handleUpdateProfile);
    on<UpdateRampStart>(_handleRampStart);
    on<UpdateRampEnd>(_handleRampEnd);
    on<UpdateSpikeAt>(_handleSpikeAt);
    on<UpdatePeakDuration>(_handlePeakDuration);
    on<RecalibrateDevice>(_handleRecalibrate);

  }

  // ============================
  // BENCHMARK
  // ============================
  Future<void> _handleLoadBenchmark(
    LoadDeviceBenchmark event,
    Emitter<LoadTestConfigState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LoadTestConfigStatus.loading));

      final result = await _benchmarkService.runBenchmark(
        testUrl: 'https://httpbin.org/get',
      );

      final cappedVUs =
          state.vus > result.maxStableConcurrency
              ? result.maxStableConcurrency
              : state.vus;

      emit(
        state.copyWith(
          status: LoadTestConfigStatus.ready,
          maxDeviceVUs: result.maxStableConcurrency,
          vus: cappedVUs,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LoadTestConfigStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  // ============================
  // FIELD UPDATES
  // ============================
  void _handleUpdateVUs(
    UpdateVUs event,
    Emitter<LoadTestConfigState> emit,
  ) {
    final value =
        event.value > state.maxDeviceVUs
            ? state.maxDeviceVUs
            : event.value;

    emit(state.copyWith(vus: value));
  }

  void _handleUpdateDuration(
    UpdateDuration event,
    Emitter<LoadTestConfigState> emit,
  ) {
    emit(state.copyWith(duration: event.value));
  }

  void _handleUpdateProfile(
    UpdateProfile event,
    Emitter<LoadTestConfigState> emit,
  ) {
    emit(state.copyWith(profile: event.profile));
  }

  void _handleRampStart(
    UpdateRampStart event,
    Emitter<LoadTestConfigState> emit,
  ) {
    emit(state.copyWith(rampStart: event.value));
  }

  void _handleRampEnd(
    UpdateRampEnd event,
    Emitter<LoadTestConfigState> emit,
  ) {
    emit(state.copyWith(rampEnd: event.value));
  }

  void _handleSpikeAt(
    UpdateSpikeAt event,
    Emitter<LoadTestConfigState> emit,
  ) {
    emit(state.copyWith(spikeAt: event.value));
  }

  void _handlePeakDuration(
    UpdatePeakDuration event,
    Emitter<LoadTestConfigState> emit,
  ) {
    emit(state.copyWith(peakDuration: event.value));
  }

  Future<void> _handleRecalibrate(
  RecalibrateDevice event,
  Emitter<LoadTestConfigState> emit,
) async {
  try {
    emit(state.copyWith(status: LoadTestConfigStatus.loading));

    final result = await _benchmarkService.runBenchmark(
      testUrl: 'https://httpbin.org/get',
    );

    final cappedVUs =
        state.vus > result.maxStableConcurrency
            ? result.maxStableConcurrency
            : state.vus;

    emit(
      state.copyWith(
        status: LoadTestConfigStatus.ready,
        maxDeviceVUs: result.maxStableConcurrency,
        vus: cappedVUs,
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(
        status: LoadTestConfigStatus.error,
        message: e.toString(),
      ),
    );
  }
}

}
