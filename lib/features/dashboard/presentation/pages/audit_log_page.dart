import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.logs.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final log = state.logs[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.neutral100,
            child:
                const Icon(Icons.history_rounded, color: AppColors.neutral600),
          ),
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(log.admin,
                  style: AppTextStyle.bodySmall
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text('performed', style: AppTextStyle.bodySmall),
              const SizedBox(width: 8),
              Text(log.action,
                  style: AppTextStyle.bodySmall
                      .copyWith(color: AppColors.primary)),
            ],
          ),
          subtitle: Text(
              'Target: ${log.details?['details'] ?? log.targetId} • ${log.createdAt.toString()}',
              style: AppTextStyle.caption),
          trailing: const Icon(Icons.info_outline_rounded,
              size: 18, color: AppColors.neutral400),
        );
      },
    );
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

// Note: Using a slightly different model in the UI for simplicity in dummy data display.
extension on AuditLogModel {
  // Add some logic if needed
}
