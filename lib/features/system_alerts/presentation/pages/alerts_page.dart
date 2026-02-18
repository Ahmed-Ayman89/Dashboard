import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/core/network/api_helper.dart';
import 'package:intl/intl.dart';
import 'package:dashboard_grow/features/system_alerts/presentation/cubit/alerts_cubit.dart';
import 'package:dashboard_grow/features/system_alerts/presentation/cubit/alerts_state.dart';
import 'package:dashboard_grow/features/system_alerts/data/models/system_alert_model.dart';
import 'package:dashboard_grow/features/system_alerts/data/datasources/alerts_remote_data_source.dart';
import 'package:dashboard_grow/features/system_alerts/data/repositories/alerts_repository_impl.dart';
import 'package:dashboard_grow/features/system_alerts/domain/usecases/get_system_alerts_usecase.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlertsCubit(
        GetSystemAlertsUseCase(
          AlertsRepositoryImpl(
            remoteDataSource: AlertsRemoteDataSourceImpl(
              apiHelper: APIHelper(),
            ),
          ),
        ),
      )..getAlerts(),
      child: const _AlertsView(),
    );
  }
}

class _AlertsView extends StatefulWidget {
  const _AlertsView();

  @override
  State<_AlertsView> createState() => _AlertsViewState();
}

class _AlertsViewState extends State<_AlertsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<AlertsCubit>().state;
      if (state is AlertsLoaded && state is! AlertsFetchingMore) {
        final currentPage = state.pagination?.page ?? 1;
        final totalPages = state.pagination?.pages ?? 1;
        if (currentPage < totalPages) {
          context.read<AlertsCubit>().getAlerts(page: currentPage + 1);
        }
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('System Alerts', style: AppTextStyle.heading1),
                    const SizedBox(height: 8),
                    Text(
                        'Monitor and manage critical system activities and warnings.',
                        style: AppTextStyle.bodySmall),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => context.read<AlertsCubit>().getAlerts(),
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
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
              child: BlocBuilder<AlertsCubit, AlertsState>(
                builder: (context, state) {
                  if (state is AlertsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AlertsFailure) {
                    return _buildErrorView(context, state.message);
                  } else if (state is AlertsLoaded) {
                    return _buildAlertsList(context, state);
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

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text(message, style: AppTextStyle.bodyRegular),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<AlertsCubit>().getAlerts(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsList(BuildContext context, AlertsLoaded state) {
    if (state.alerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none_rounded,
                size: 64, color: AppColors.neutral300),
            const SizedBox(height: 16),
            Text('No system alerts found.',
                style: AppTextStyle.bodyMedium
                    .copyWith(color: AppColors.neutral500)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(24),
            itemCount:
                state.alerts.length + (state is AlertsFetchingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.alerts.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child:
                      Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _AlertCard(alert: state.alerts[index]),
              );
            },
          ),
        ),
        if (state.pagination != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Showing ${state.alerts.length} of ${state.pagination!.total} alerts',
              style: AppTextStyle.caption.copyWith(color: AppColors.neutral500),
            ),
          ),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  final SystemAlert alert;

  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          leading: _buildSeverityIcon(),
          title: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTypeBadge(),
                  const SizedBox(width: 8),
                  _buildStatusBadge(),
                ],
              ),
              Text(
                DateFormat('MMM d, yyyy • hh:mm a').format(alert.createdAt),
                style:
                    AppTextStyle.caption.copyWith(color: AppColors.neutral400),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(alert.summary,
                  style: AppTextStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral800)),
              const SizedBox(height: 6),
              Text(alert.message,
                  style: AppTextStyle.bodySmall
                      .copyWith(color: AppColors.neutral600, height: 1.4)),
              if (alert.user != null || alert.kiosk != null) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (alert.user != null) ...[
                      _buildChip(
                        icon: Icons.person_outline,
                        label: alert.user!.fullName,
                      ),
                    ],
                    if (alert.kiosk != null) ...[
                      _buildChip(
                        icon: Icons.storefront_outlined,
                        label: alert.kiosk!.name,
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
          onTap: () => _showDetailDialog(context),
        ),
      ),
    );
  }

  Widget _buildChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.neutral500),
          const SizedBox(width: 4),
          Text(label,
              style: AppTextStyle.caption
                  .copyWith(color: AppColors.neutral600, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSeverityIcon() {
    IconData icon;
    Color color;

    switch (alert.severity.toUpperCase()) {
      case 'HIGH':
        icon = Icons.error_rounded;
        color = AppColors.error;
        break;
      case 'MEDIUM':
        icon = Icons.warning_rounded;
        color = AppColors.warning;
        break;
      case 'LOW':
      default:
        icon = Icons.info_rounded;
        color = AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        alert.type.replaceAll('_', ' '),
        style: AppTextStyle.caption.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.neutral700,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    switch (alert.status.toUpperCase()) {
      case 'OPEN':
        color = AppColors.error;
        break;
      case 'RESOLVED':
        color = AppColors.success;
        break;
      case 'DISMISSED':
      default:
        color = AppColors.neutral400;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        alert.status,
        style: AppTextStyle.caption.copyWith(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: 10,
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alert Details', style: AppTextStyle.heading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailItem('Type', alert.type.replaceAll('_', ' ')),
            _detailItem('Severity', alert.severity),
            _detailItem('Status', alert.status),
            _detailItem('Summary', alert.summary),
            _detailItem('Message', alert.message),
            if (alert.user != null)
              _detailItem(
                  'User', '${alert.user!.fullName} (${alert.user!.phone})'),
            if (alert.kiosk != null) _detailItem('Kiosk', alert.kiosk!.name),
            if (alert.details != null && alert.details!.isNotEmpty)
              _detailItem('Extra Info',
                  alert.details!['info'] ?? alert.details.toString()),
            _detailItem('Created At',
                DateFormat('yyyy-MM-dd HH:mm:ss').format(alert.createdAt)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: AppTextStyle.bodySmall.copyWith(color: AppColors.neutral800),
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
}
