import 'package:apimate/config/components/my_btn.dart';
import 'package:apimate/config/utility/utility.dart';
import 'package:apimate/main.dart';
import 'package:flutter/material.dart';

import '../../../domain/model/load_test/load_test_config.dart';
import '../../bloc/load_test/load_test_bloc.dart';
import '../../config/routes/routes_name.dart';
import '../../domain/model/request_client_model/request_execution_input.dart';
import '../../domain/repository/request_client/request_client_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/load_test_config/load_test_config_bloc.dart';

class LoadTestConfigView extends StatelessWidget {
  final List<int> selectedRequestIds;

  const LoadTestConfigView({super.key, required this.selectedRequestIds});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoadTestConfigBloc()..add(LoadDeviceBenchmark()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Load Test Configuration'),
        ),
        body: SafeArea(
          child: BlocBuilder<LoadTestConfigBloc, LoadTestConfigState>(
            builder: (context, state) {
              if (state.status == LoadTestConfigStatus.loading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        "Analyzing device capacity…",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: currentTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "This usually takes around 15-30 seconds",
                        style: TextStyle(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Please keep the app open and avoid switching apps",
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              if (state.status == LoadTestConfigStatus.error) {
                return Center(
                  child: Text(
                    state.message ?? 'Failed to load device benchmark',
                    style: TextStyle(color: currentTheme.error),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // =============================
                    // DEVICE CAP
                    // =============================
                    Row(
                      children: [
                        const Icon(Icons.phone_iphone, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Max Supported VUs: ${state.maxDeviceVUs}',
                          style: TextStyle(
                            color: currentTheme.primary,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed:
                              state.status == LoadTestConfigStatus.loading
                                  ? null
                                  : () {
                                    context.read<LoadTestConfigBloc>().add(
                                      RecalibrateDevice(),
                                    );
                                  },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Recalibrate'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // =============================
                    // DEVICE ADVISORY
                    // =============================
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: currentTheme.cardBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: currentTheme.warning),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: currentTheme.warning,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'For accurate results:\n'
                              '• Close other running apps\n'
                              '• Use a stable internet connection\n'
                              '• Device may heat during tests',
                              style: TextStyle(fontSize: 13, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // =============================
                    // BASIC
                    // =============================
                    _SectionCard(
                      title: 'Basic',
                      child: Column(
                        children: [
                          _SliderField(
                            label: 'Virtual Users',
                            value: state.vus,
                            min: 1,
                            max: state.maxDeviceVUs,
                            onChanged:
                                (v) => context.read<LoadTestConfigBloc>().add(
                                  UpdateVUs(v),
                                ),
                          ),
                          const SizedBox(height: 12),
                          _SliderField(
                            label: 'Duration (seconds)',
                            value: state.duration,
                            min: 5,
                            max: 300,
                            onChanged:
                                (v) => context.read<LoadTestConfigBloc>().add(
                                  UpdateDuration(v),
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // =============================
                    // PROFILE
                    // =============================
                    _SectionCard(
                      title: 'Load Profile',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProfileSelector(
                            selected: state.profile,
                            onChanged:
                                (p) => context.read<LoadTestConfigBloc>().add(
                                  UpdateProfile(p),
                                ),
                          ),
                          const SizedBox(height: 12),
                          _buildProfileFields(context, state),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // =============================
                    // START
                    // =============================
                    MyBtn(
                      onBtnTap: () => _startTest(context, state),
                      title: "Start Load Test",
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // PROFILE FIELDS
  // ===============================================================
  Widget _buildProfileFields(BuildContext context, LoadTestConfigState state) {
    switch (state.profile) {
      case LoadProfileType.fixed:
        return const Text(
          'Fixed: Runs with constant users for the entire duration.',
        );

      case LoadProfileType.rampUp:
        if (state.vus < 2) {
          return const Text(
            'Load test in RAMPUP profile needs atleast 2 Virtual Users.',
          );
        }

        return Column(
          children: [
            _SliderField(
              label: 'Start Users',
              value: state.rampStart,
              min: 1,
              max: state.vus,
              onChanged:
                  (v) => context.read<LoadTestConfigBloc>().add(
                    UpdateRampStart(v),
                  ),
            ),
            const SizedBox(height: 8),
            _SliderField(
              label: 'End Users',
              value: state.rampEnd,
              min: state.rampStart,
              max: state.vus,
              onChanged:
                  (v) =>
                      context.read<LoadTestConfigBloc>().add(UpdateRampEnd(v)),
            ),
          ],
        );

      case LoadProfileType.spike:
        return _SliderField(
          label: 'Spike At (seconds)',
          value: state.spikeAt,
          min: 1,
          max: state.duration,
          onChanged:
              (v) => context.read<LoadTestConfigBloc>().add(UpdateSpikeAt(v)),
        );

      case LoadProfileType.peak:
        return _SliderField(
          label: 'Peak Duration (seconds)',
          value: state.peakDuration,
          min: 1,
          max: state.duration,
          onChanged:
              (v) =>
                  context.read<LoadTestConfigBloc>().add(UpdatePeakDuration(v)),
        );
    }
  }

  // ===============================================================
  // START TEST
  // ===============================================================
  Future<void> _startTest(
    BuildContext context,
    LoadTestConfigState state,
  ) async {
    final config = LoadTestConfig(
      requestedVUs: state.vus,
      durationSeconds: state.duration,
      profile: state.profile,
      rampStart: state.rampStart,
      rampEnd: state.rampEnd,
      spikeAtSecond: state.spikeAt,
      peakDuration: state.peakDuration,
    );

    try {
      // 1️⃣ Load selected APIs from DB
      final repo = RequestClientRepo();
      final List<RequestExecutionInput> inputs = [];

      for (final id in selectedRequestIds) {
        final requestData = await repo.loadRequest(id);

        Utility.showLog("RequestData : $requestData");

        inputs.add(
          RequestExecutionInput(
            method: requestData.method,
            url: requestData.rawUrl,
            headers: requestData.headers,
            queryParams: requestData.queryParams,
            body: requestData.body?.content,
            contentType: requestData.body?.contentType,
          ),
        );
      }

      // 2️⃣ Dispatch to LoadTestBloc
      context.read<LoadTestBloc>().add(
        StartLoadTest(requests: inputs, config: config),
      );

      // 3️⃣ Navigate to Live View
      Navigator.pushNamed(context, RoutesName.loadTestLiveView);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start load test: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: currentTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: currentTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ProfileSelector extends StatelessWidget {
  final LoadProfileType selected;
  final ValueChanged<LoadProfileType> onChanged;

  const _ProfileSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children:
          LoadProfileType.values.map((type) {
            final bool isActive = type == selected;
            return ChoiceChip(
              label: Text(type.name.toUpperCase()),
              selected: isActive,
              onSelected: (_) => onChanged(type),
              selectedColor: currentTheme.primary,
              backgroundColor: currentTheme.panelBackground,
              // labelStyle: TextStyle(
              //   color: isActive ? Colors.white : Colors.white70,
              // ),
            );
          }).toList(),
    );
  }
}

class _SliderField extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _SliderField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label),
            const Spacer(),
            Text(
              value.toString(),
              style: TextStyle(
                color: currentTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          label: value.toString(),
          activeColor: const Color(0xFF6C9CFF),
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }
}
