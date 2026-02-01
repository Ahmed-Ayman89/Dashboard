import 'package:flutter/material.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/analytics_chart.dart';
import '../widgets/distribution_pie_chart.dart';
import '../widgets/comparison_bar_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Analytics & Reports', style: AppTextStyle.heading1),
          const SizedBox(height: 32),
          _buildTopCharts(),
          const SizedBox(height: 32),
          _buildPerformanceComparison(),
          const SizedBox(height: 32),
          _buildDistributionRow(),
        ],
      ),
    );
  }

  Widget _buildTopCharts() {
    return Row(
      children: [
        const Expanded(
          flex: 2,
          child: AnalyticsChart(
            title: 'Revenue Growth',
            spots: [
              FlSpot(0, 1500),
              FlSpot(1, 1800),
              FlSpot(2, 2200),
              FlSpot(3, 2100),
              FlSpot(4, 2800),
              FlSpot(5, 3500),
            ],
            xAxisLabels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 1,
          child: DistributionPieChart(
            title: 'User Distribution',
            sections: [
              PieChartSectionData(
                color: AppColors.brandPrimary,
                value: 65,
                title: 'Customers',
                radius: 50,
                titleStyle:
                    AppTextStyle.caption.copyWith(color: AppColors.white),
              ),
              PieChartSectionData(
                color: AppColors.secondary,
                value: 25,
                title: 'Workers',
                radius: 50,
                titleStyle:
                    AppTextStyle.caption.copyWith(color: AppColors.white),
              ),
              PieChartSectionData(
                color: AppColors.warning,
                value: 10,
                title: 'Owners',
                radius: 50,
                titleStyle:
                    AppTextStyle.caption.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceComparison() {
    return ComparisonBarChart(
      title: 'Kiosk Transactions (This Week)',
      xAxisLabels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      barGroups: [
        BarChartGroupData(
            x: 0,
            barRods: [BarChartRodData(toY: 8, color: AppColors.brandPrimary)]),
        BarChartGroupData(
            x: 1,
            barRods: [BarChartRodData(toY: 10, color: AppColors.brandPrimary)]),
        BarChartGroupData(
            x: 2,
            barRods: [BarChartRodData(toY: 14, color: AppColors.brandPrimary)]),
        BarChartGroupData(
            x: 3,
            barRods: [BarChartRodData(toY: 15, color: AppColors.warning)]),
        BarChartGroupData(
            x: 4,
            barRods: [BarChartRodData(toY: 13, color: AppColors.brandPrimary)]),
        BarChartGroupData(
            x: 5,
            barRods: [BarChartRodData(toY: 10, color: AppColors.brandPrimary)]),
        BarChartGroupData(
            x: 6, barRods: [BarChartRodData(toY: 18, color: AppColors.error)]),
      ],
    );
  }

  Widget _buildDistributionRow() {
    return Row(
      children: [
        Expanded(
          child: DistributionPieChart(
            title: 'Kiosk Status',
            sections: [
              PieChartSectionData(
                  color: AppColors.success,
                  value: 70,
                  title: 'Active',
                  radius: 40),
              PieChartSectionData(
                  color: AppColors.warning,
                  value: 20,
                  title: 'Maintenance',
                  radius: 40),
              PieChartSectionData(
                  color: AppColors.error,
                  value: 10,
                  title: 'Offline',
                  radius: 40),
            ],
          ),
        ),
        const SizedBox(width: 32),
        const Expanded(
          child: AnalyticsChart(
            title: 'New User Signups',
            spots: [
              FlSpot(0, 10),
              FlSpot(1, 25),
              FlSpot(2, 45),
              FlSpot(3, 30),
              FlSpot(4, 55),
              FlSpot(5, 70),
            ],
            xAxisLabels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            chartColor: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
