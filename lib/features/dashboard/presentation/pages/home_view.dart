import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import '../widgets/summary_card.dart';
import '../widgets/filtered_analytics_chart.dart';
import '../cubit/graph_cubit.dart';
import '../cubit/dashboard_stats_cubit.dart';
import '../cubit/dashboard_stats_state.dart';
import '../../data/datasources/dashboard_remote_data_source.dart';
import '../../data/repositories/graph_repository_impl.dart';
import '../../data/repositories/dashboard_stats_repository_impl.dart';
import '../../domain/usecases/get_graph_data_usecase.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:dashboard_grow/core/services/local_notification_service.dart';

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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
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
              SizedBox(height: isMobile ? 24 : 32),
              if (isMobile) ...{
                const SizedBox(height: 24),
              } else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 32),
                  ],
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            LocalNotificationService.showTestNotification();
          },
          icon: const Icon(Icons.notifications_active_rounded),
          label: const Text('اختبار الإشعار'),
          backgroundColor: AppColors.brandPrimary,
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Business Overview', style: AppTextStyle.heading1),
              Text('Monitor platform performance',
                  style: AppTextStyle.bodyMedium),
            ],
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Business Overview', style: AppTextStyle.heading1),
        Text('Monitor platform performance and growth',
            style: AppTextStyle.bodyMedium),
      ],
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
              'value': '${totals.duesPending} points',
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
}
