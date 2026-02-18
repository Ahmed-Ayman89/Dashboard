import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/dashboard/data/models/audit_log_model.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/usecases/get_audit_logs_usecase.dart';
import '../cubit/audit_logs_cubit.dart';
import '../cubit/audit_logs_state.dart';

class AuditLogPage extends StatelessWidget {
  const AuditLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuditLogsCubit(
        GetAuditLogsUseCase(DashboardRepositoryImpl()),
      )..getLogs(),
      child: const _AuditLogView(),
    );
  }
}

class _AuditLogView extends StatelessWidget {
  const _AuditLogView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Audit Log', style: AppTextStyle.heading1),
          const SizedBox(height: 8),
          Text(
              'Track every administrative action for security and accountability.',
              style: AppTextStyle.bodyMedium),
          const SizedBox(height: 32),
          Expanded(
            child: Container(
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
              child: BlocBuilder<AuditLogsCubit, AuditLogsState>(
                builder: (context, state) {
                  if (state is AuditLogsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AuditLogsFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 48, color: AppColors.error),
                          const SizedBox(height: 16),
                          Text(state.message, style: AppTextStyle.bodyRegular),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<AuditLogsCubit>().getLogs(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is AuditLogsSuccess) {
                    return Column(
                      children: [
                        Expanded(child: _buildLogsList(context, state)),
                        _buildPagination(context, state),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsList(BuildContext context, AuditLogsSuccess state) {
    if (state.logs.isEmpty) {
      return const Center(child: Text('No audit logs found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: state.logs.length,
      itemBuilder: (context, index) {
        final log = state.logs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutral200.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: _getActionColor(log.action).withOpacity(0.1),
              child: Icon(_getActionIcon(log.action),
                  color: _getActionColor(log.action), size: 20),
            ),
            title: Text(
              log.summary,
              style:
                  AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${DateFormat('MMM d, yyyy • hh:mm a').format(log.createdAt)} • IP: ${log.ipAddress ?? 'N/A'}',
              style: AppTextStyle.caption.copyWith(color: AppColors.neutral500),
            ),
            childrenPadding: const EdgeInsets.all(16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              _buildDetailItem('Admin', '${log.admin} (${log.adminPhone})'),
              _buildDetailItem('Action', log.action),
              _buildDetailItem('Target ID', log.targetId),
              if (log.details != null && log.details!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Details:',
                    style: AppTextStyle.caption
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    log.details.toString(),
                    style:
                        AppTextStyle.caption.copyWith(fontFamily: 'monospace'),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          style: AppTextStyle.caption.copyWith(color: AppColors.neutral800),
          children: [
            TextSpan(
                text: '$label: ',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Color _getActionColor(String action) {
    if (action.contains('DELETE')) return AppColors.error;
    if (action.contains('UPDATE') || action.contains('EDIT')) {
      return AppColors.warning;
    }
    if (action.contains('COLLECT')) return AppColors.success;
    if (action.contains('LOGIN')) return AppColors.primary;
    return AppColors.neutral600;
  }

  IconData _getActionIcon(String action) {
    if (action.contains('DELETE')) return Icons.delete_outline_rounded;
    if (action.contains('UPDATE') || action.contains('EDIT')) {
      return Icons.edit_outlined;
    }
    if (action.contains('COLLECT')) {
      return Icons.account_balance_wallet_outlined;
    }
    if (action.contains('LOGIN')) return Icons.login_rounded;
    return Icons.history_rounded;
  }

  Widget _buildPagination(BuildContext context, AuditLogsSuccess state) {
    if (state.total == 0) return const SizedBox.shrink();
    final totalPages = (state.total / state.limit).ceil();
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'Showing ${(state.page - 1) * state.limit + 1} to ${state.page * state.limit > state.total ? state.total : state.page * state.limit} of ${state.total} entries',
              style: AppTextStyle.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: state.page > 1
                    ? () => context
                        .read<AuditLogsCubit>()
                        .changePage(state.page - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
              ),
              const SizedBox(width: 8),
              Text('Page ${state.page} of $totalPages',
                  style: AppTextStyle.bodySmall),
              const SizedBox(width: 8),
              IconButton(
                onPressed: state.page < totalPages
                    ? () => context
                        .read<AuditLogsCubit>()
                        .changePage(state.page + 1)
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension on AuditLogModel {}
