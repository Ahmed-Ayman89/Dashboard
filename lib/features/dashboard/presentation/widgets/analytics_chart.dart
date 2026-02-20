import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';

class AnalyticsChart extends StatelessWidget {
  final String title;
  final List<FlSpot> spots;
  final List<String> xAxisLabels;
  final Color chartColor;
  final int? totalCount;
  final double? totalVolume;

  const AnalyticsChart({
    super.key,
    required this.title,
    required this.spots,
    required this.xAxisLabels,
    this.chartColor = AppColors.brandPrimary,
    this.totalCount,
    this.totalVolume,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.heading3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.more_vert_rounded, color: AppColors.neutral500),
            ],
          ),
          if (totalCount != null || totalVolume != null) ...[
            const SizedBox(height: 24),
            _buildTotals(),
          ],
          const SizedBox(height: 32),
          SizedBox(
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
                          '${flSpot.y.toInt()} Points',
                          AppTextStyle.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: chartColor,
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
                      interval: (xAxisLabels.length > 10)
                          ? (xAxisLabels.length / 6).ceilToDouble()
                          : 1,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < xAxisLabels.length) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            child: Text(
                              xAxisLabels[index],
                              style: AppTextStyle.caption,
                            ),
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
                      interval: _calculateLeftInterval(),
                      getTitlesWidget: (value, meta) {
                        // Only show whole numbers to avoid overlapping zeros
                        if (value % 1 != 0) return const SizedBox();
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
                maxX: (xAxisLabels.length - 1).toDouble(),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: chartColor,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.white,
                        strokeWidth: 2,
                        strokeColor: chartColor,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          chartColor.withOpacity(0.3),
                          chartColor.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateLeftInterval() {
    if (spots.isEmpty) return 1.0;
    double maxY = 0;
    for (final spot in spots) {
      if (spot.y > maxY) maxY = spot.y;
    }
    if (maxY == 0) return 1.0;
    // Aim for ~5-6 intervals
    return (maxY / 5).ceilToDouble();
  }

  Widget _buildTotals() {
    final showCount = totalCount != null && totalCount! > 0;
    final showVolume = totalVolume != null && totalVolume! > 0;

    if (!showCount && !showVolume) return const SizedBox.shrink();

    return Row(
      children: [
        if (showCount)
          _buildTotalItem(
            'Total Count',
            totalCount.toString(),
            chartColor,
          ),
        if (showCount && showVolume) const SizedBox(width: 24),
        if (showVolume)
          _buildTotalItem(
            'Total Volume',
            '$totalVolume',
            AppColors.success,
          ),
      ],
    );
  }

  Widget _buildTotalItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.caption.copyWith(color: AppColors.neutral500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyle.heading3.copyWith(color: color),
        ),
      ],
    );
  }
}
