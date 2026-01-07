enum LoadProfileType { fixed, rampUp, spike, peak }

class LoadTestConfig {
  final int requestedVUs;
  final int durationSeconds;
  final LoadProfileType profile;

  // Advanced profile params (optional)
  final int? rampStart;
  final int? rampEnd;
  final int? spikeAtSecond;
  final int? peakDuration;

  const LoadTestConfig({
    required this.requestedVUs,
    required this.durationSeconds,
    required this.profile,
    this.rampStart,
    this.rampEnd,
    this.spikeAtSecond,
    this.peakDuration,
  });

  /// Apply device capacity cap
  LoadTestConfig applyDeviceCap(int maxVUs) {
    return LoadTestConfig(
      requestedVUs: requestedVUs > maxVUs ? maxVUs : requestedVUs,
      durationSeconds: durationSeconds,
      profile: profile,
      rampStart: rampStart,
      rampEnd: rampEnd != null && rampEnd! > maxVUs ? maxVUs : rampEnd,
      spikeAtSecond: spikeAtSecond,
      peakDuration: peakDuration,
    );
  }
}
