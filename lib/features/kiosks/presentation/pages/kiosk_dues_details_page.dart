import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/helper/app_text_style.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/kiosk_dues_details_model.dart';
import '../../data/repositories/kiosks_repository_impl.dart';
import '../../domain/usecases/get_kiosk_dues_details_usecase.dart';
import '../cubit/kiosk_dues_details_cubit.dart';

class KioskDuesDetailsPage extends StatelessWidget {
  final String kioskId;

  const KioskDuesDetailsPage({super.key, required this.kioskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = KiosksRepositoryImpl();
        return KioskDuesDetailsCubit(GetKioskDuesDetailsUseCase(repository))
          ..getDuesDetails(kioskId);
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF8FAFC),
        appBar: AppBar(
          title: const Text('Dues Details'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          titleTextStyle:
              AppTextStyle.heading3.copyWith(color: AppColors.textPrimary),
        ),
        body: const _KioskDuesDetailsView(),
      ),
    );
  }
}

class _KioskDuesDetailsView extends StatelessWidget {
  const _KioskDuesDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KioskDuesDetailsCubit, KioskDuesDetailsState>(
      builder: (context, state) {
        if (state is KioskDuesDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is KioskDuesDetailsFailure) {
          return Center(
            child: Text(state.message,
                style: const TextStyle(color: AppColors.error)),
          );
        } else if (state is KioskDuesDetailsSuccess) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(state.details),
                const SizedBox(height: 24),
                _buildFinancialsSummary(state.details.financials),
                const SizedBox(height: 24),
                _buildSectionTitle('Dues History'),
                const SizedBox(height: 16),
                _buildDuesHistoryList(state.details.duesHistory),
                const SizedBox(height: 24),
                _buildSectionTitle('Contributing Workers'),
                const SizedBox(height: 16),
                _buildWorkersList(state.details.workersContributing),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHeader(KioskDuesDetailsModel details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(details.name, style: AppTextStyle.heading2),
        const SizedBox(height: 4),
        Text('Kiosk ID: ${details.kioskId}',
            style: AppTextStyle.caption.copyWith(color: AppColors.neutral500)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyle.heading3.copyWith(fontSize: 18));
  }

  Widget _buildFinancialsSummary(DuesFinancials financials) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Generated',
            '${financials.totalDuesGenerated.toStringAsFixed(0)} EGP',
            AppColors.primary,
            Icons.monetization_on_outlined,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'Total Paid',
            '${financials.totalPaid.toStringAsFixed(0)} EGP',
            AppColors.success,
            Icons.check_circle_outline,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'Outstanding',
            '${financials.outstandingBalance.toStringAsFixed(0)} EGP',
            AppColors.error,
            Icons.pending_actions_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title,
              style: AppTextStyle.caption.copyWith(color: AppColors.neutral600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(value,
              style: AppTextStyle.bodyRegular.copyWith(
                  fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildDuesHistoryList(List<DuesHistoryItem> history) {
    if (history.isEmpty) {
      return _buildEmptyState('No dues history found.');
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: history.map((item) {
          final isLast = item == history.last;
          return Column(
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.isPaid
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.warning.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.isPaid ? Icons.check : Icons.access_time,
                    color: item.isPaid ? AppColors.success : AppColors.warning,
                    size: 20,
                  ),
                ),
                title: Text(
                  '${item.amount.toStringAsFixed(0)} EGP',
                  style: AppTextStyle.bodyRegular
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  DateFormat('MMM d, yyyy - h:mm a').format(item.createdAt),
                  style: AppTextStyle.caption,
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.isPaid
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.isPaid ? 'PAID' : 'PENDING',
                    style: AppTextStyle.caption.copyWith(
                      color:
                          item.isPaid ? AppColors.success : AppColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: AppColors.neutral200),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWorkersList(List<ContributingWorker> workers) {
    if (workers.isEmpty) {
      return _buildEmptyState('No contributing workers.');
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: workers.map((worker) {
          final isLast = worker == workers.last;
          return Column(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.neutral100,
                  child: Icon(Icons.person, color: AppColors.neutral500),
                ),
                title: Text(worker.name, style: AppTextStyle.bodyRegular),
                trailing: _buildWorkerStatusBadge(worker.status),
              ),
              if (!isLast)
                const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: AppColors.neutral200),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWorkerStatusBadge(String status) {
    Color color;
    if (status.toUpperCase() == 'ACTIVE') {
      color = AppColors.success;
    } else if (status.toUpperCase().contains('PENDING')) {
      color = AppColors.warning;
    } else {
      color = AppColors.neutral500;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: AppTextStyle.caption
            .copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Center(
        child: Text(message,
            style: AppTextStyle.bodyRegular
                .copyWith(color: AppColors.textSecondary)),
      ),
    );
  }
}
