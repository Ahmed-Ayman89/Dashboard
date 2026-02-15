import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/helper/app_text_style.dart';
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
  String _selectedResource = 'transactions_amount';
  bool _isAccumulative = true;

  @override
  void initState() {
    super.initState();
    _fetchGraph();
  }

  void _fetchGraph() {
    context.read<WorkerGraphCubit>().getWorkerGraph(
          id: widget.workerId,
          resource: _selectedResource,
          filter: _selectedFilter,
          accumulative: _isAccumulative,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkerGraphCubit, WorkerGraphState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilters(),
            const SizedBox(height: 16),
            if (state is WorkerGraphLoading)
              const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state is WorkerGraphFailure)
              SizedBox(
                height: 300,
                child: Center(child: Text('Error: ${state.message}')),
              )
            else if (state is WorkerGraphLoaded)
              _buildChart(state),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildResourceDropdown(),
            ),
            const SizedBox(width: 16),
            _buildAccumulativeToggle(),
          ],
        ),
        const SizedBox(height: 16),
        _buildTimeFilters(),
      ],
    );
  }

  Widget _buildResourceDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutral300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedResource,
          isExpanded: true,
          items: const [
            DropdownMenuItem(
              value: 'transactions_count',
              child: Text('Transactions Count'),
            ),
            DropdownMenuItem(
              value: 'transactions_amount',
              child: Text('Transactions Amount'),
            ),
            DropdownMenuItem(
              value: 'commission_earned',
              child: Text('Commission Earned'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedResource = value);
              _fetchGraph();
            }
          },
        ),
      ),
    );
  }

  Widget _buildAccumulativeToggle() {
    return Row(
      children: [
        Checkbox(
          value: _isAccumulative,
          activeColor: AppColors.brandPrimary,
          onChanged: (value) {
            if (value != null) {
              setState(() => _isAccumulative = value);
              _fetchGraph();
            }
          },
        ),
        Text('Accumulative', style: AppTextStyle.bodySmall),
      ],
    );
  }

  Widget _buildTimeFilters() {
    final filters = [
      '1d',
      'last day',
      '3d',
      '7d',
      'weekly',
      '30d',
      'monthly',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedFilter = filter);
                  _fetchGraph();
                }
              },
              selectedColor: AppColors.brandPrimary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChart(WorkerGraphLoaded state) {
    final data = state.graphData.data;
    List<FlSpot> spots = [];
    List<String> xAxisLabels = [];

    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i].volume));
      xAxisLabels.add(data[i].label);
    }

    String title = 'Graph';
    if (_selectedResource == 'transactions_count') title = 'Transactions Count';
    if (_selectedResource == 'transactions_amount')
      title = 'Transactions Amount';
    if (_selectedResource == 'commission_earned') title = 'Commission Earned';

    return AnalyticsChart(
      title: '$title (${state.graphData.period})',
      spots: spots,
      xAxisLabels: xAxisLabels,
      chartColor: AppColors.brandPrimary,
    );
  }
}
