import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import '../widgets/summary_card.dart';
import '../widgets/analytics_chart.dart';
import '../widgets/filtered_analytics_chart.dart';
import '../cubit/graph_cubit.dart';
import '../cubit/dashboard_stats_cubit.dart';
import '../cubit/dashboard_stats_state.dart';
import '../../data/datasources/dashboard_remote_data_source.dart';
import '../../data/repositories/graph_repository_impl.dart';
import '../../data/repositories/dashboard_stats_repository_impl.dart';
import '../../domain/usecases/get_graph_data_usecase.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GraphCubit(
            GetGraphDataUseCase(
              GraphRepositoryImpl(
                remoteDataSource: DashboardRemoteDataSource(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => DashboardStatsCubit(
            GetDashboardStatsUseCase(
              DashboardStatsRepositoryImpl(
                remoteDataSource: DashboardRemoteDataSource(),
              ),
            ),
          )..loadDashboardStats(),
        ),
      ],
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isMobile),
            SizedBox(height: isMobile ? 24 : 32),
            _buildKpiGrid(context, isMobile),
            SizedBox(height: isMobile ? 24 : 32),
            const FilteredAnalyticsChart(),
            SizedBox(height: isMobile ? 24 : 32),
            // _buildChartsSection(isMobile),
            SizedBox(height: isMobile ? 24 : 32),
            if (isMobile) ...{
              // _buildSystemHealth(),
              const SizedBox(height: 24),
              // _buildQuickActions(),
            } else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expanded(flex: 2, child: _buildSystemHealth()),
                  const SizedBox(width: 32),
                  // Expanded(flex: 1, child: _buildQuickActions()),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Widget _buildChartsSection(bool isMobile) {
  //   if (isMobile) {
  //     return Column(
  //       children: [
  //         AnalyticsChart(
  //           title: 'Accumulative Transactions',
  //           spots: const [
  //             FlSpot(0, 5),
  //             FlSpot(1, 12),
  //             FlSpot(2, 18),
  //             FlSpot(3, 22),
  //             FlSpot(4, 30),
  //             FlSpot(5, 35),
  //           ],
  //           xAxisLabels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
  //         ),
  //         const SizedBox(height: 24),
  //         AnalyticsChart(
  //           title: 'Daily Points Sent',
  //           spots: const [
  //             FlSpot(0, 10),
  //             FlSpot(1, 8),
  //             FlSpot(2, 12),
  //             FlSpot(3, 14),
  //             FlSpot(4, 9),
  //             FlSpot(5, 15),
  //           ],
  //           xAxisLabels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
  //           chartColor: AppColors.secondary,
  //         ),
  //       ],
  //     );
  //   }
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: AnalyticsChart(
  //           title: 'Accumulative Transactions',
  //           spots: const [
  //             FlSpot(0, 5),
  //             FlSpot(1, 12),
  //             FlSpot(2, 18),
  //             FlSpot(3, 22),
  //             FlSpot(4, 30),
  //             FlSpot(5, 35),
  //           ],
  //           xAxisLabels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
  //         ),
  //       ),
  //       const SizedBox(width: 24),
  //       Expanded(
  //         child: AnalyticsChart(
  //           title: 'Daily Points Sent',
  //           spots: const [
  //             FlSpot(0, 10),
  //             FlSpot(1, 8),
  //             FlSpot(2, 12),
  //             FlSpot(3, 14),
  //             FlSpot(4, 9),
  //             FlSpot(5, 15),
  //           ],
  //           xAxisLabels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
  //           chartColor: AppColors.secondary,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Business Overview', style: AppTextStyle.heading1),
                    Text('Monitor platform performance',
                        style: AppTextStyle.bodyMedium),
                  ],
                ),
              ),
              // Mobile specific compact date selector if needed, or keep stacked
            ],
          ),
          const SizedBox(height: 16),
          _buildDateRangeSelector(),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Business Overview', style: AppTextStyle.heading1),
            Text('Monitor platform performance and growth',
                style: AppTextStyle.bodyMedium),
          ],
        ),
        _buildDateRangeSelector(),
      ],
    );
  }

  Widget _buildDateRangeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_rounded,
              size: 18, color: AppColors.neutral600),
          const SizedBox(width: 12),
          Text('Last 30 Days',
              style: AppTextStyle.bodyMedium
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(width: 12),
          Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.neutral600),
        ],
      ),
    );
  }

  Widget _buildKpiGrid(BuildContext context, bool isMobile) {
    return BlocBuilder<DashboardStatsCubit, DashboardStatsState>(
      builder: (context, state) {
        if (state is DashboardStatsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DashboardStatsError) {
          return Center(
            child: Text(
              'Error loading stats: ${state.message}',
              style: AppTextStyle.bodyMedium.copyWith(color: AppColors.error),
            ),
          );
        }

        if (state is DashboardStatsSuccess) {
          final totals = state.stats.totals;

          final kpis = [
            {
              'title': 'Total Kiosks',
              'value': '${totals.kiosks}',
              'icon': Icons.store_rounded,
              'color': AppColors.primary
            },
            {
              'title': 'Total Workers',
              'value': '${totals.workers}',
              'icon': Icons.engineering_rounded,
              'color': AppColors.secondary
            },
            {
              'title': 'Total Customers',
              'value': '${totals.customers}',
              'icon': Icons.people_rounded,
              'color': AppColors.success
            },
            {
              'title': 'Total Transactions',
              'value': '${totals.transactions}',
              'icon': Icons.receipt_long_rounded,
              'color': AppColors.warning
            },
            {
              'title': 'Points Sent',
              'value': totals.pointsSent,
              'icon': Icons.send_rounded,
              'color': AppColors.brandPrimary
            },
            {
              'title': 'Dues Pending',
              'value': '${totals.duesPending} EGP',
              'icon': Icons.account_balance_wallet_rounded,
              'color': AppColors.error
            },
          ];

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : 3,
              crossAxisSpacing: isMobile ? 12 : 24,
              mainAxisSpacing: isMobile ? 12 : 24,
              childAspectRatio: isMobile ? 1.4 : 2.1,
            ),
            itemCount: kpis.length,
            itemBuilder: (context, index) {
              final kpi = kpis[index];
              return SummaryCard(
                title: kpi['title'] as String,
                value: kpi['value'] as String,
                icon: kpi['icon'] as IconData,
                color: kpi['color'] as Color,
              );
            },
          );
        }

        // Initial state
        return const SizedBox.shrink();
      },
    );
  }

  // Widget _buildSystemHealth() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('System Health', style: AppTextStyle.heading2),
  //       const SizedBox(height: 16),
  //       Container(
  //         padding: const EdgeInsets.all(24),
  //         decoration: BoxDecoration(
  //           color: AppColors.white,
  //           borderRadius: BorderRadius.circular(16),
  //           boxShadow: [
  //             BoxShadow(
  //               color: AppColors.black.withOpacity(0.05),
  //               blurRadius: 10,
  //               offset: const Offset(0, 4),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           children: [
  //             _buildAlertItem(
  //               title: 'High Transaction Velocity',
  //               description:
  //                   'Kiosk "City Mall" exceeded daily limit 3 times in a row.',
  //               type: 'Critical',
  //             ),
  //             const Divider(height: 32),
  //             _buildAlertItem(
  //               title: 'Suspicious Deletion Attempt',
  //               description:
  //                   'User 0102345678 tried to delete account with 500 EGP dues.',
  //               type: 'Warning',
  //             ),
  //             const Divider(height: 32),
  //             _buildAlertItem(
  //               title: 'New Verification Requests',
  //               description: '15 new kiosk owners are waiting for approval.',
  //               type: 'Info',
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildAlertItem(
  //     {required String title,
  //     required String description,
  //     required String type}) {
  //   Color color;
  //   IconData icon;
  //   switch (type) {
  //     case 'Critical':
  //       color = AppColors.error;
  //       icon = Icons.error_rounded;
  //       break;
  //     case 'Warning':
  //       color = AppColors.warning;
  //       icon = Icons.warning_rounded;
  //       break;
  //     default:
  //       color = AppColors.primary;
  //       icon = Icons.info_rounded;
  //   }

  //   return Row(
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.all(12),
  //         decoration: BoxDecoration(
  //           color: color.withOpacity(0.1),
  //           shape: BoxShape.circle,
  //         ),
  //         child: Icon(icon, color: color, size: 24),
  //       ),
  //       const SizedBox(width: 16),
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(title,
  //                 style: AppTextStyle.bodyRegular
  //                     .copyWith(fontWeight: FontWeight.bold)),
  //             Text(description, style: AppTextStyle.bodySmall),
  //           ],
  //         ),
  //       ),
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //         decoration: BoxDecoration(
  //           color: color.withOpacity(0.1),
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         child: Text(
  //           type,
  //           style: AppTextStyle.caption
  //               .copyWith(color: color, fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildQuickActions() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('Quick Actions', style: AppTextStyle.heading2),
  //       const SizedBox(height: 16),
  //       _buildActionButton('Verify New Owners', Icons.verified_user_rounded,
  //           AppColors.primary),
  //       const SizedBox(height: 12),
  //       _buildActionButton(
  //           'Approve Redemptions', Icons.payments_rounded, AppColors.success),
  //       const SizedBox(height: 12),
  //       _buildActionButton('Dues Follow-up', Icons.notifications_active_rounded,
  //           AppColors.warning),
  //       const SizedBox(height: 12),
  //       _buildActionButton('Customer Support', Icons.support_agent_rounded,
  //           AppColors.brandPrimary),
  //     ],
  //   );
  // }

//   Widget _buildActionButton(String title, IconData icon, Color color) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: color, size: 24),
//           const SizedBox(width: 16),
//           Text(title,
//               style: AppTextStyle.bodyMedium
//                   .copyWith(fontWeight: FontWeight.w600)),
//           const Spacer(),
//           Icon(Icons.chevron_right_rounded, color: AppColors.neutral400),
//         ],
//       ),
//     );
//   }
// }
}
