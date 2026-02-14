import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/helper/app_text_style.dart';
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
  final List<Map<String, String>> _filters = [
    {'label': 'Daily', 'value': '1d'},
    {'label': 'Weekly', 'value': '7d'},
    {'label': 'Monthly', 'value': '30d'},
    {'label': 'Yearly', 'value': '365d'},
    {'label': 'All', 'value': 'all'},
  ];

  final List<Map<String, String>> _resources = [
    {'label': 'Transaction Amount', 'value': 'transactions_amount'},
    {'label': 'Commission Earned', 'value': 'commission_earned'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchGraph();
  }

  void _fetchGraph() {
    context.read<OwnerGraphCubit>().getOwnerGraph(id: widget.ownerId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerGraphCubit, OwnerGraphState>(
      builder: (context, state) {
        final cubit = context.read<OwnerGraphCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilters(context, cubit),
            const SizedBox(height: 24),
            _buildContent(context, state),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, OwnerGraphState state) {
    if (state is OwnerGraphLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    } else if (state is OwnerGraphFailure) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text('Error: ${state.message}',
              style: AppTextStyle.bodyRegular.copyWith(color: AppColors.error)),
        ),
      );
    } else if (state is OwnerGraphLoaded) {
      final data = state.graphData.data;

      List<FlSpot> spots = [];
      List<String> xAxisLabels = [];

      final cubit = context.read<OwnerGraphCubit>();
      for (int i = 0; i < data.length; i++) {
        spots.add(FlSpot(i.toDouble(), data[i].volume));

        // Prioritize API label
        String label = data[i].label;
        if (label.isEmpty) {
          // Fallback based on filter
          final filter = cubit.currentFilter;
          if (filter == '365d' || filter == 'all') {
            label = DateFormat('MMM yyyy').format(data[i].date);
          } else if (filter == '7d') {
            label = DateFormat('EEE').format(data[i].date);
          } else if (filter == '30d') {
            label = DateFormat('MMM dd').format(data[i].date);
          } else if (filter == '1d') {
            label = DateFormat('HH:mm').format(data[i].date);
          } else {
            label = DateFormat('MM/dd').format(data[i].date);
          }
        }
        xAxisLabels.add(label);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnalyticsChart(
            title: _getResourceLabel(state.graphData.resource),
            spots: spots,
            xAxisLabels: xAxisLabels,
            chartColor: AppColors.brandPrimary,
          ),
        ],
      );
    }
    return const SizedBox();
  }

  String _getResourceLabel(String value) {
    return _resources.firstWhere((r) => r['value'] == value,
        orElse: () => {'label': 'Data'})['label']!;
  }

  Widget _buildFilters(BuildContext context, OwnerGraphCubit cubit) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ..._filters.map((filter) {
          final isSelected = cubit.currentFilter == filter['value'];
          return InkWell(
            onTap: () => cubit.updateFilter(widget.ownerId, filter['value']!),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected ? AppColors.brandPrimary : AppColors.neutral100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filter['label']!,
                style: AppTextStyle.bodySmall.copyWith(
                  color: isSelected ? Colors.white : AppColors.neutral700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        _buildAccumulativeToggle(cubit),
        const SizedBox(width: 8),
        _buildResourceDropdown(cubit),
      ],
    );
  }

  Widget _buildAccumulativeToggle(OwnerGraphCubit cubit) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Accumulative', style: AppTextStyle.caption),
        Switch(
          value: cubit.isAccumulative,
          activeColor: AppColors.brandPrimary,
          onChanged: (_) => cubit.toggleAccumulative(widget.ownerId),
        ),
      ],
    );
  }

  Widget _buildResourceDropdown(OwnerGraphCubit cubit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: cubit.currentResource,
        underline: const SizedBox(),
        items: _resources.map((r) {
          return DropdownMenuItem(
            value: r['value'],
            child: Text(r['label']!, style: AppTextStyle.bodySmall),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            cubit.updateResource(widget.ownerId, value);
          }
        },
      ),
    );
  }
}
