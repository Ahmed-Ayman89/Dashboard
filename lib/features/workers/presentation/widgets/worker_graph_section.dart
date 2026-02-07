import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/presentation/widgets/analytics_chart.dart';
import '../cubit/worker_graph_cubit.dart';
import '../cubit/worker_graph_state.dart';

class WorkerGraphSection extends StatefulWidget {
  final String workerId;

  const WorkerGraphSection({super.key, required this.workerId});

  @override
  State<WorkerGraphSection> createState() => _WorkerGraphSectionState();
}

class _WorkerGraphSectionState extends State<WorkerGraphSection> {
  String _selectedFilter = 'weekly';

  @override
  void initState() {
    super.initState();
    _fetchGraph();
  }

  void _fetchGraph() {
    context.read<WorkerGraphCubit>().getWorkerGraph(
          id: widget.workerId,
          filter: _selectedFilter,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkerGraphCubit, WorkerGraphState>(
      builder: (context, state) {
        if (state is WorkerGraphLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WorkerGraphFailure) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is WorkerGraphLoaded) {
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
              // Filter buttons (optional, for now just static weekly)
              // AnalyticsChart
              AnalyticsChart(
                title: 'Transaction Volume (${state.graphData.period})',
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
