import 'package:flutter/material.dart';

import '../../../domain/model/load_test/load_test_config.dart';
import 'load_test_live_view.dart';

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
        backgroundColor: const Color(0xFF0F1220),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF0F1220),
          title: const Text('Load Test Configuration'),
        ),
        body: SafeArea(
          child: BlocBuilder<LoadTestConfigBloc, LoadTestConfigState>(
            builder: (context, state) {
              if (state.status == LoadTestConfigStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == LoadTestConfigStatus.error) {
                return Center(
                  child: Text(
                    state.message ?? 'Failed to load device benchmark',
                    style: const TextStyle(color: Colors.red),
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
                        const Icon(
                          Icons.phone_iphone,
                          size: 16,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Max Supported VUs: ${state.maxDeviceVUs}',
                          style: const TextStyle(
                            color: Colors.white70,
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
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF6C9CFF),
                          ),
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
                        color: const Color(0xFF1A1F3D),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'For accurate results:\n'
                              '• Close other running apps\n'
                              '• Use a stable internet connection\n'
                              '• Device may heat during tests',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                height: 1.4,
                              ),
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _startTest(context, state),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C9CFF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Start Load Test',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
          style: TextStyle(color: Colors.white70),
        );

      case LoadProfileType.rampUp:
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
  void _startTest(BuildContext context, LoadTestConfigState state) {
    final config = LoadTestConfig(
      requestedVUs: state.vus,
      durationSeconds: state.duration,
      profile: state.profile,
      rampStart: state.rampStart,
      rampEnd: state.rampEnd,
      spikeAtSecond: state.spikeAt,
      peakDuration: state.peakDuration,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoadTestLiveView()),
    );

    // TODO:
    // Load RequestExecutionInput from DB using selectedRequestIds
    // context.read<LoadTestBloc>().add(StartLoadTest(...));
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
        color: const Color(0xFF141834),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
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
              selectedColor: const Color(0xFF6C9CFF),
              backgroundColor: const Color(0xFF1A1F3D),
              labelStyle: TextStyle(
                color: isActive ? Colors.white : Colors.white70,
              ),
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
            Text(label, style: const TextStyle(color: Colors.white70)),
            const Spacer(),
            Text(
              value.toString(),
              style: const TextStyle(
                color: Colors.white,
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
