import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/dues/data/models/dues_dashboard_model.dart';
import 'package:intl/intl.dart';

class DuesGraphSection extends StatelessWidget {
  final List<TopKiosk> topKiosks;

  const DuesGraphSection({super.key, required this.topKiosks});

  @override
  Widget build(BuildContext context) {
    if (topKiosks.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort descending by amount just in case the API didn't
    final sortedKiosks = List<TopKiosk>.from(topKiosks)
      ..sort((a, b) {
        final double amountA = double.tryParse(a.totalDue) ?? 0;
        final double amountB = double.tryParse(b.totalDue) ?? 0;
        return amountB.compareTo(amountA);
      });

    // Take top 5 for the chart
    final chartData = sortedKiosks.take(5).toList();

    return Container(
      width: double.infinity,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top Kiosks by Outstanding Dues',
                  style: AppTextStyle.heading3),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (double.tryParse(chartData.first.totalDue) ?? 0) * 1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.surface,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final kioskName = chartData[group.x.toInt()].kioskName;
                      final amount = NumberFormat.currency(
                              symbol: 'EGP ', decimalDigits: 0)
                          .format(rod.toY);
                      return BarTooltipItem(
                        '$kioskName\n',
                        AppTextStyle.bodySmall
                            .copyWith(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: amount,
                            style: AppTextStyle.bodySmall
                                .copyWith(color: AppColors.brandPrimary),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < chartData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              chartData[index].kioskName.split(' ').first,
                              style: AppTextStyle.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          NumberFormat.compact().format(value),
                          style: AppTextStyle.bodySmall
                              .copyWith(color: AppColors.neutral600),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval:
                      (double.tryParse(chartData.first.totalDue) ?? 0) / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.border,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: chartData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final amount = double.tryParse(item.totalDue) ?? 0;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: amount,
                        color: AppColors.brandPrimary,
                        width: 32,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8)),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY:
                              (double.tryParse(chartData.first.totalDue) ?? 0) *
                                  1.1,
                          color: AppColors.neutral100,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
