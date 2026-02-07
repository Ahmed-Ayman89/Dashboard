import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import '../cubit/graph_cubit.dart';
import '../cubit/graph_state.dart';

class FilteredAnalyticsChart extends StatefulWidget {
  const FilteredAnalyticsChart({super.key});

  @override
  State<FilteredAnalyticsChart> createState() => _FilteredAnalyticsChartState();
}

class _FilteredAnalyticsChartState extends State<FilteredAnalyticsChart> {
  String selectedFilter = 'weekly';
  String selectedResource = 'transactions';

  final List<String> filters = ['weekly', 'monthly', 'yearly', 'custom'];
  final List<Map<String, String>> resources = [
    {'value': 'transactions', 'label': 'Transactions'},
    {'value': 'kiosks', 'label': 'Kiosks'},
    {'value': 'workers', 'label': 'Workers'},
    {'value': 'customers', 'label': 'Customers'},
    {'value': 'points_sent', 'label': 'Points Sent'},
    {'value': 'dues_pending', 'label': 'Dues Pending'},
    {'value': 'redeemed', 'label': 'Redeemed'},
    {'value': 'commissions', 'label': 'Commissions'},
    {'value': 'app_downloads', 'label': 'App Downloads'},
    {'value': 'shadow_accounts', 'label': 'Shadow Accounts'},
  ];

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GraphCubit>().loadGraphData(
            filter: selectedFilter,
            resource: selectedResource,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile),
          const SizedBox(height: 16),
          _buildFilters(isMobile),
          const SizedBox(height: 24),
          _buildChart(),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Analytics Overview', style: AppTextStyle.heading3),
          const SizedBox(height: 12),
          _buildResourceSelector(),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Analytics Overview',
            style: AppTextStyle.heading3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 16),
        _buildResourceSelector(),
      ],
    );
  }

  Widget _buildResourceSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedResource,
          isDense: true,
          icon: Icon(Icons.keyboard_arrow_down,
              color: AppColors.neutral600, size: 20),
          style: AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w600),
          items: resources.map((resource) {
            return DropdownMenuItem<String>(
              value: resource['value'],
              child: Text(resource['label']!),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => selectedResource = value);
              context.read<GraphCubit>().updateResource(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildFilters(bool isMobile) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filters.map((filter) {
        final isSelected = selectedFilter == filter;
        return InkWell(
          onTap: () {
            setState(() => selectedFilter = filter);
            if (filter == 'custom') {
              _showCustomDatePicker();
            } else {
              context.read<GraphCubit>().updateFilter(filter);
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.brandPrimary : AppColors.neutral100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.brandPrimary : AppColors.divider,
              ),
            ),
            child: Text(
              filter[0].toUpperCase() + filter.substring(1),
              style: AppTextStyle.bodySmall.copyWith(
                color: isSelected ? AppColors.white : AppColors.neutral700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _showCustomDatePicker() async {
    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.brandPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      final formattedFrom = DateFormat('d-M-yyyy').format(pickedRange.start);
      final formattedTo = DateFormat('d-M-yyyy').format(pickedRange.end);
      context
          .read<GraphCubit>()
          .updateCustomDateRange(formattedFrom, formattedTo);
    }
  }

  Widget _buildChart() {
    return BlocBuilder<GraphCubit, GraphState>(
      builder: (context, state) {
        if (state is GraphLoading) {
          return const SizedBox(
            height: 250,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is GraphError) {
          return SizedBox(
            height: 250,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading data',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: AppTextStyle.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (state is GraphSuccess) {
          final data = state.graphData;

          if (data.dataPoints.isEmpty) {
            return SizedBox(
              height: 250,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline,
                        color: AppColors.neutral400, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'No data available',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.neutral600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Convert data to FlSpot
          final spots = data.dataPoints
              .asMap()
              .entries
              .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
              .toList();

          final labels = data.dataPoints.map((point) => point.label).toList();

          return SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => AppColors.white,
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;
                        return LineTooltipItem(
                          '${flSpot.y.toInt()}',
                          AppTextStyle.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.brandPrimary,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.divider,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(labels[index],
                                style: AppTextStyle.caption),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: AppTextStyle.caption,
                          textAlign: TextAlign.left,
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (labels.length - 1).toDouble(),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.brandPrimary,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.white,
                        strokeWidth: 2,
                        strokeColor: AppColors.brandPrimary,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.brandPrimary.withOpacity(0.3),
                          AppColors.brandPrimary.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox(height: 250);
      },
    );
  }
}
