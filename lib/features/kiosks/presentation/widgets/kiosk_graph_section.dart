import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/presentation/widgets/analytics_chart.dart';
import '../cubit/kiosk_graph_cubit.dart';
import '../cubit/kiosk_graph_state.dart';

class KioskGraphSection extends StatefulWidget {
  final String kioskId;

  const KioskGraphSection({super.key, required this.kioskId});

  @override
  State<KioskGraphSection> createState() => _KioskGraphSectionState();
}

class _KioskGraphSectionState extends State<KioskGraphSection> {
  String _selectedFilter = '7d';

  @override
  void initState() {
    super.initState();
    _fetchGraph();
  }

  void _fetchGraph() {
    context.read<KioskGraphCubit>().getKioskGraph(
          id: widget.kioskId,
          filter: _selectedFilter,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KioskGraphCubit, KioskGraphState>(
      builder: (context, state) {
        if (state is KioskGraphLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is KioskGraphFailure) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is KioskGraphLoaded) {
          final data = state.graphData.data;

          // Map data to FlSpots
          List<FlSpot> spots = [];
          List<String> xAxisLabels = [];

          for (int i = 0; i < data.length; i++) {
            spots.add(FlSpot(i.toDouble(), data[i].volume));
            xAxisLabels.add(DateFormat('MM/dd').format(data[i].date));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnalyticsChart(
                title: 'Commission Earned (${state.graphData.period})',
                spots: spots,
                xAxisLabels: xAxisLabels,
                chartColor: AppColors.brandPrimary,
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
