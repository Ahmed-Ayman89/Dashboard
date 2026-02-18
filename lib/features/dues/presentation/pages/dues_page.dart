import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/helper/role_helper.dart';
import 'package:dashboard_grow/core/network/api_helper.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/dues/data/datasources/dues_remote_data_source.dart';
import 'package:dashboard_grow/features/dues/data/repositories/dues_repository_impl.dart';
import 'package:dashboard_grow/features/dues/domain/entities/due.dart';
import 'package:dashboard_grow/features/dues/domain/usecases/collect_due_usecase.dart';
import 'package:dashboard_grow/features/dues/domain/usecases/get_dues_usecase.dart';
import 'package:dashboard_grow/features/dues/presentation/cubit/dues_cubit.dart';
import 'package:dashboard_grow/features/dues/data/models/dues_dashboard_model.dart';
import 'package:dashboard_grow/features/dues/domain/usecases/get_dues_dashboard_usecase.dart';
import 'package:dashboard_grow/features/dues/presentation/widgets/dues_graph_section.dart';
import 'package:intl/intl.dart';

class DuesPage extends StatelessWidget {
  const DuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiHelper = APIHelper();
    final remoteDataSource = DuesRemoteDataSourceImpl(apiHelper: apiHelper);
    final repository = DuesRepositoryImpl(remoteDataSource: remoteDataSource);

    return BlocProvider(
      create: (context) => DuesCubit(
        getDuesUseCase: GetDuesUseCase(repository: repository),
        collectDueUseCase: CollectDueUseCase(repository: repository),
        getDuesDashboardUseCase:
            GetDuesDashboardUseCase(repository: repository),
      )..getDues(),
      child: Scaffold(
        body: BlocConsumer<DuesCubit, DuesState>(
          listener: (context, state) {
            if (state is DuesActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                ),
              );
            } else if (state is DuesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is DuesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DuesLoaded) {
              return _DuesContent(
                dues: state.dues,
                dashboardData: state.dashboardData,
                total: state.total,
                page: state.page,
                limit: state.limit,
              );
            }
            if (state is DuesActionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _DuesContent extends StatelessWidget {
  final List<Due> dues;
  final DuesDashboardModel? dashboardData;
  final int total;
  final int page;
  final int limit;

  const _DuesContent({
    required this.dues,
    this.dashboardData,
    required this.total,
    required this.page,
    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(symbol: 'Points ', decimalDigits: 0);

    // Use dashboard data if available, otherwise fallback/calculate locally
    final double totalOutstandingVal = dashboardData != null
        ? double.tryParse(dashboardData!.summary.totalOutstanding) ?? 0.0
        : dues.fold<double>(0.0, (sum, due) {
            if (!due.isPaid) {
              return sum + (double.tryParse(due.amount) ?? 0);
            }
            return sum;
          });
    final totalOutstanding = currencyFormat.format(totalOutstandingVal);

    final highRiskCount =
        dashboardData != null ? dashboardData!.highRiskCount.toString() : '0';

    final collectedToday = dashboardData != null
        ? currencyFormat.format(dashboardData!.summary.amountCollectedToday)
        : currencyFormat.format(0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dues Management', style: AppTextStyle.heading1),
          const SizedBox(height: 32),
          _buildDuesOverview(
            totalOutstanding: totalOutstanding,
            highRiskCount: highRiskCount,
            collectedToday: collectedToday,
          ),
          const SizedBox(height: 32),
          if (dashboardData != null && dashboardData!.topKiosks.isNotEmpty) ...[
            DuesGraphSection(topKiosks: dashboardData!.topKiosks),
            const SizedBox(height: 32),
          ],
          // We can eventually add Top Kiosks or High Risk Kiosks sections here using dashboardData
          Text('Kiosk Dues Details', style: AppTextStyle.heading2),
          const SizedBox(height: 16),
          _buildDuesTable(context, dues, currencyFormat),
          _buildPagination(context),
        ],
      ),
    );
  }

  Widget _buildDuesOverview({
    required String totalOutstanding,
    required String highRiskCount,
    required String collectedToday,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return Column(
            children: [
              _buildSummaryBox('Total Outstanding', totalOutstanding,
                  AppColors.brandPrimary),
              const SizedBox(height: 16),
              _buildSummaryBox(
                  'High Risk Kiosks', highRiskCount, AppColors.error),
              const SizedBox(height: 16),
              _buildSummaryBox(
                  'Collected Today', collectedToday, AppColors.success),
            ],
          );
        }
        return Row(
          children: [
            Expanded(
              child: _buildSummaryBox('Total Outstanding', totalOutstanding,
                  AppColors.brandPrimary),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildSummaryBox(
                  'High Risk Kiosks', highRiskCount, AppColors.error),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildSummaryBox(
                  'Collected Today', collectedToday, AppColors.success),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryBox(String label, String value, Color color) {
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
          Text(label, style: AppTextStyle.bodySmall),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyle.heading2.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildDuesTable(
      BuildContext context, List<Due> dues, NumberFormat currencyFormat) {
    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - 64,
            ),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.neutral100),
              columns: const [
                DataColumn(label: Text('Kiosk')),
                DataColumn(label: Text('Owner')),
                DataColumn(label: Text('Total Created')),
                DataColumn(label: Text('Outstanding')),
                DataColumn(label: Text('Last Payment')),
                DataColumn(label: Text('Actions')),
              ],
              rows: dues.map((due) {
                final amount = double.tryParse(due.amount) ?? 0;
                final outstanding = due.isPaid ? 0 : amount;
                final isHighRisk = !due.isPaid && _isHighRisk(due);

                String lastPayment = 'N/A';
                if (due.lastCollectedAt != null) {
                  final date = DateTime.tryParse(due.lastCollectedAt!);
                  if (date != null) {
                    final now = DateTime.now();
                    final difference = now.difference(date).inDays;
                    lastPayment = '$difference days ago';
                  }
                }

                return DataRow(cells: [
                  DataCell(
                    Text(
                      due.kioskName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isHighRisk
                            ? AppColors.error
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  DataCell(Text(due.ownerName)),
                  DataCell(Text(currencyFormat.format(amount))),
                  DataCell(
                    Text(
                      currencyFormat.format(outstanding),
                      style: TextStyle(
                        fontWeight:
                            isHighRisk ? FontWeight.bold : FontWeight.normal,
                        color: isHighRisk
                            ? AppColors.error
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  DataCell(Text(lastPayment)),
                  DataCell(
                    _buildActionButton(context, due),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, Due due) {
    if (due.isPaid) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Paid',
          style: TextStyle(
            color: AppColors.success,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return FutureBuilder<bool>(
      future: RoleHelper.canTakeActions(),
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox.shrink();
        return ElevatedButton(
          onPressed: () => _showCollectDialog(context, due),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brandPrimary.withOpacity(0.1),
            foregroundColor: AppColors.brandPrimary,
            elevation: 0,
          ),
          child: const Text('Collect'),
        );
      },
    );
  }

  void _showCollectDialog(BuildContext context, Due due) {
    final amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Collect Due', style: AppTextStyle.heading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Owner: ${due.ownerName}', style: AppTextStyle.bodyMedium),
            const SizedBox(height: 8),
            Text('Kiosk: ${due.kioskName}', style: AppTextStyle.bodyMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Outstanding: ', style: AppTextStyle.bodyMedium),
                Text(
                  due.amount,
                  style: AppTextStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: amountController,
              style: AppTextStyle.bodyRegular,
              decoration: InputDecoration(
                labelText: 'Amount to Collect',
                labelStyle: AppTextStyle.bodyMedium,
                prefixText: 'Points ',
                prefixStyle: AppTextStyle.bodyRegular
                    .copyWith(fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.brandPrimary, width: 2),
                ),
                filled: true,
                fillColor: AppColors.neutral100,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.neutral600,
              textStyle:
                  AppTextStyle.button.copyWith(color: AppColors.neutral600),
            ),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid amount')),
                );
                return;
              }
              // Call cubit to collect due
              context.read<DuesCubit>().collectDue(due.id, amount);
              Navigator.pop(dialogContext);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brandPrimary,
              foregroundColor: AppColors.white,
              textStyle: AppTextStyle.button,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Collect'),
          ),
        ],
      ),
    );
  }

  bool _isHighRisk(Due due) {
    final createdAt = DateTime.tryParse(due.createdAt);
    if (createdAt == null) return false;
    final daysSinceCreated = DateTime.now().difference(createdAt).inDays;
    return daysSinceCreated > 30;
  }

  Widget _buildPagination(BuildContext context) {
    final totalPages = (total / limit).ceil();
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'Showing ${(page - 1) * limit + 1} to ${page * limit > total ? total : page * limit} of $total kiosks',
              style: AppTextStyle.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: page > 1
                    ? () => context.read<DuesCubit>().changePage(page - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text('Page $page of $totalPages', style: AppTextStyle.bodySmall),
              const SizedBox(width: 8),
              IconButton(
                onPressed: page < totalPages
                    ? () => context.read<DuesCubit>().changePage(page + 1)
                    : null,
                icon: const Icon(Icons.chevron_right),
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
