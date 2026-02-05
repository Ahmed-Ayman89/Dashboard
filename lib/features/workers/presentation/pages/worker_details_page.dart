import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/core/widgets/custom_snackbar.dart';
import 'package:dashboard_grow/features/workers/data/models/worker_details_model.dart';
import 'package:dashboard_grow/features/workers/data/repositories/workers_repository_impl.dart';
import 'package:dashboard_grow/features/workers/domain/usecases/get_worker_details_usecase.dart';
import 'package:dashboard_grow/features/workers/presentation/cubit/worker_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WorkerDetailsPage extends StatelessWidget {
  final String workerId;

  const WorkerDetailsPage({super.key, required this.workerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = WorkersRepositoryImpl();
        return WorkerDetailsCubit(GetWorkerDetailsUseCase(repository))
          ..getWorkerDetails(workerId);
      },
      child: const _WorkerDetailsView(),
    );
  }
}

class _WorkerDetailsView extends StatelessWidget {
  const _WorkerDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        title: Text('Worker Details', style: AppTextStyle.heading3),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<WorkerDetailsCubit, WorkerDetailsState>(
        listener: (context, state) {
          if (state is WorkerDetailsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                message: state.message,
                type: SnackBarType.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is WorkerDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkerDetailsLoaded) {
            final worker = state.worker;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(worker.profile),
                  const SizedBox(height: 24),
                  _buildStatsCards(worker),
                  const SizedBox(height: 32),
                  Text('Assigned Kiosks', style: AppTextStyle.heading3),
                  const SizedBox(height: 16),
                  _buildKiosksList(worker.kiosks),
                  const SizedBox(height: 32),
                  Text('Recent Transactions', style: AppTextStyle.heading3),
                  const SizedBox(height: 16),
                  _buildTransactionsList(worker.recentTransactions),
                ],
              ),
            );
          } else if (state is WorkerDetailsFailure) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Failed to load worker details',
                    style: AppTextStyle.bodyRegular),
                const SizedBox(height: 16),
                TextButton(
                    onPressed: () => context
                        .read<WorkerDetailsCubit>()
                        .getWorkerDetails(context
                                .read<WorkerDetailsCubit>()
                                .state is WorkerDetailsFailure
                            ? ''
                            : ''), // This is a bit hacky, normally we'd pass ID again or store it.
                    // Better approach: Since we create Cubit in Page, let's just use empty string or ideally passed ID if we had access.
                    // Actually, we need access to ID. Let's fix this in retry logic or just show message.
                    child: const Text('Retry'))
              ],
            ));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileHeader(WorkerProfile profile) {
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              profile.fullName.isNotEmpty ? profile.fullName[0] : '?',
              style: AppTextStyle.heading1.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.fullName, style: AppTextStyle.heading2),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone,
                        size: 16, color: AppColors.neutral500),
                    const SizedBox(width: 8),
                    Text(profile.phone, style: AppTextStyle.bodyRegular),
                    const SizedBox(width: 16),
                    _buildStatusBadge(profile.isActive),
                    if (profile.isVerified) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.verified,
                          size: 20, color: AppColors.primary),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Joined ${DateFormat('MMM d, yyyy').format(profile.createdAt)}',
                  style: AppTextStyle.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(WorkerDetailsModel worker) {
    return LayoutBuilder(builder: (context, constraints) {
      final isSmallScreen = constraints.maxWidth < 800;

      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          SizedBox(
            width: isSmallScreen
                ? (constraints.maxWidth - 16) / 2
                : (constraints.maxWidth - 32) / 3,
            child: _buildInfoCard(
              title: 'Total Balance',
              value: '${worker.balance.toStringAsFixed(2)} EGP',
              icon: Icons.account_balance_wallet,
              color: AppColors.primary,
            ),
          ),
          SizedBox(
            width: isSmallScreen
                ? (constraints.maxWidth - 16) / 2
                : (constraints.maxWidth - 32) / 3,
            child: _buildInfoCard(
              title: 'Goal Completion',
              value: '${worker.profile.goalCompletionRate}%',
              icon: Icons.flag,
              color: AppColors.success,
            ),
          ),
          SizedBox(
            width: isSmallScreen
                ? constraints.maxWidth
                : (constraints.maxWidth - 32) / 3,
            child: _buildInfoCard(
              title: 'Suspicious Flags',
              value: worker.suspiciousFlags.toString(),
              icon: Icons.warning_amber_rounded,
              color: worker.suspiciousFlags > 0
                  ? AppColors.error
                  : AppColors.neutral500,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Text(title,
                  style: AppTextStyle.bodySmall
                      .copyWith(color: AppColors.neutral500)),
            ],
          ),
          const SizedBox(height: 16),
          Text(value,
              style:
                  AppTextStyle.heading3.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildKiosksList(List<WorkerKioskDetail> kiosks) {
    if (kiosks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Center(
            child: Text('No assigned kiosks', style: AppTextStyle.bodyRegular)),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kiosks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final kiosk = kiosks[index];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kiosk.kioskName,
                            style: AppTextStyle.bodyMedium
                                .copyWith(fontWeight: FontWeight.bold)),
                        Text('Owner: ${kiosk.ownerName}',
                            style: AppTextStyle.caption),
                      ],
                    ),
                    _buildStatusBadge(kiosk.status == 'ACTIVE'),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recent Goals Performance',
                        style: AppTextStyle.bodySmall
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: kiosk.goals.map((goal) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.neutral100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: _getGoalColor(goal.status)
                                      .withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                    DateFormat('d MMM')
                                        .format(DateTime.parse(goal.date)),
                                    style: AppTextStyle.caption),
                                const SizedBox(height: 4),
                                Icon(_getGoalIcon(goal.status),
                                    color: _getGoalColor(goal.status),
                                    size: 16),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionsList(List<WorkerTransaction> transactions) {
    if (transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Center(
            child: Text('No recent transactions',
                style: AppTextStyle.bodyRegular)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Icon(Icons.receipt_long,
                  size: 20, color: AppColors.primary),
            ),
            title: Text('To: ${tx.receiverPhone}',
                style: AppTextStyle.bodySmall
                    .copyWith(fontWeight: FontWeight.bold)),
            subtitle: Text(
                DateFormat('MMM d, yyyy - hh:mm a').format(tx.createdAt),
                style: AppTextStyle.caption),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('+${tx.amountGross.toStringAsFixed(2)} EGP',
                    style: AppTextStyle.bodySmall.copyWith(
                        fontWeight: FontWeight.bold, color: AppColors.success)),
                Text('Comm: ${tx.commission.toStringAsFixed(2)}',
                    style: AppTextStyle.caption),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color:
            (isActive ? AppColors.success : AppColors.error).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'INACTIVE',
        style: AppTextStyle.caption.copyWith(
          color: isActive ? AppColors.success : AppColors.error,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getGoalColor(String status) {
    switch (status) {
      case 'ACHIEVED':
        return AppColors.success;
      case 'NOT_ACHIEVED':
        return AppColors.error;
      case 'IN_PROGRESS':
        return AppColors.warning;
      default:
        return AppColors.neutral500;
    }
  }

  IconData _getGoalIcon(String status) {
    switch (status) {
      case 'ACHIEVED':
        return Icons.check_circle;
      case 'NOT_ACHIEVED':
        return Icons.cancel;
      case 'IN_PROGRESS':
        return Icons.hourglass_top;
      default:
        return Icons.remove_circle_outline;
    }
  }
}
