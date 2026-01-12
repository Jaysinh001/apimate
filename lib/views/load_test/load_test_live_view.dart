import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../bloc/load_test/load_test_bloc.dart';
import '../../main.dart';

class LoadTestLiveView extends StatelessWidget {
  const LoadTestLiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Live Load Test'),
        actions: [
          TextButton.icon(
            onPressed: () {
              context.read<LoadTestBloc>().add(StopLoadTest());
            },
            icon: Icon(Icons.stop_circle_outlined, color: currentTheme.error),
            label: Text('Stop', style: TextStyle(color: currentTheme.error)),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<LoadTestBloc, LoadTestState>(
          buildWhen:
              (p, c) => p.status != c.status || p.liveMetrics != c.liveMetrics,
          builder: (context, state) {
            if (state.status == LoadTestStatus.initial) {
              return const Center(child: Text('Not started'));
            }

            if (state.status == LoadTestStatus.error) {
              return Center(
                child: Text(
                  state.message ?? 'Something went wrong',
                  style: TextStyle(color: currentTheme.error),
                ),
              );
            }

            final metrics = state.liveMetrics;

            return Column(
              children: [
                const SizedBox(height: 12),

                // =============================
                // KPI CARDS
                // =============================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      _KpiCard(
                        title: 'Active VUs',
                        value: metrics.activeUsers.toString(),
                        accent: currentTheme.chartActiveVUs,
                      ),
                      const SizedBox(width: 12),
                      _KpiCard(
                        title: 'RPS',
                        value: metrics.rps.toStringAsFixed(1),
                        accent: currentTheme.chartRps,
                      ),
                      const SizedBox(width: 12),
                      _KpiCard(
                        title: 'Avg Latency (ms)',
                        value: metrics.avgLatencyMs.toStringAsFixed(0),
                        accent: currentTheme.chartLatency,
                      ),
                      const SizedBox(width: 12),
                      _KpiCard(
                        title: 'Error %',
                        value: metrics.errorRate.toStringAsFixed(1),
                        accent: currentTheme.chartError,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // =============================
                // CHARTS
                // =============================
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.6,
                          ),
                      children: [
                        _ChartCard(
                          title: 'Requests Per Second',
                          child: _LineChart(
                            spots: _spotsFromSeries(
                              metrics.series,
                              (p) => p.rps,
                            ),
                            gradient: [
                              currentTheme.chartRps.withOpacity(0.5),
                              currentTheme.chartRps,
                            ],
                            yLabel: 'RPS',
                          ),
                        ),
                        _ChartCard(
                          title: 'Avg Latency (ms)',
                          child: _LineChart(
                            spots: _spotsFromSeries(
                              metrics.series,
                              (p) => p.avgLatencyMs,
                            ),
                            gradient: [
                              currentTheme.chartLatency.withOpacity(0.5),
                              currentTheme.chartLatency,
                            ],
                            yLabel: 'ms',
                          ),
                        ),
                        _ChartCard(
                          title: 'Error Rate (%)',
                          child: _LineChart(
                            spots: _spotsFromSeries(
                              metrics.series,
                              (p) => p.errorRate,
                            ),
                            gradient: [
                              currentTheme.chartError.withOpacity(0.5),
                              currentTheme.chartError,
                            ],
                            yLabel: '%',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }

  // Convert time-series to chart points
  List<FlSpot> _spotsFromSeries(
    List series,
    double Function(dynamic p) selector,
  ) {
    if (series.isEmpty) return const [];
    return List.generate(series.length, (i) {
      return FlSpot(i.toDouble(), selector(series[i]));
    });
  }
}

// ===============================================================
// UI COMPONENTS
// ===============================================================

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final Color accent;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: currentTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 12)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: accent,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: currentTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: currentTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final List<Color> gradient;
  final String yLabel;

  const _LineChart({
    required this.spots,
    required this.gradient,
    required this.yLabel,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: spots.isNotEmpty ? spots.length.toDouble() - 1 : 0,
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _autoInterval(spots),
              getTitlesWidget:
                  (value, meta) => Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: currentTheme.textPrimary.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  ),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradient.map((c) => c.withOpacity(0.2)).toList(),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ],
      ),
      // swapAnimationDuration: const Duration(milliseconds: 300),
    );
  }

  static double _autoInterval(List<FlSpot> spots) {
    if (spots.isEmpty) return 1;

    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    if (maxY <= 0) return 1;

    // Find next power of 10
    final magnitude = pow(10, (log(maxY) / ln10).ceil()).toDouble();

    // Divide into 5 grid lines
    return magnitude / 5;
  }
}
