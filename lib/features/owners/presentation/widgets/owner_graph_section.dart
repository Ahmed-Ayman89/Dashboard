import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/presentation/widgets/analytics_chart.dart';
import '../cubit/owner_graph_cubit.dart';
import '../cubit/owner_graph_state.dart';

class OwnerGraphSection extends StatefulWidget {
  final String ownerId;

  const OwnerGraphSection({super.key, required this.ownerId});

  @override
  State<OwnerGraphSection> createState() => _OwnerGraphSectionState();
}

class _OwnerGraphSectionState extends State<OwnerGraphSection> {
  String _selectedFilter = 'weekly';

  @override
  void initState() {
    super.initState();
    _fetchGraph();
  }

  void _fetchGraph() {
    context.read<OwnerGraphCubit>().getOwnerGraph(
          id: widget.ownerId,
          filter: _selectedFilter,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerGraphCubit, OwnerGraphState>(
      builder: (context, state) {
        if (state is OwnerGraphLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OwnerGraphFailure) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is OwnerGraphLoaded) {
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
