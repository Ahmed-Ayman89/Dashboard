import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/owners/data/models/owner_details_model.dart';
import 'package:dashboard_grow/features/owners/data/repositories/owners_repository_impl.dart';
import 'package:dashboard_grow/features/owners/domain/usecases/get_owner_details_usecase.dart';
import 'package:dashboard_grow/features/owners/presentation/cubit/owner_details_cubit.dart';
import 'package:dashboard_grow/features/owners/domain/usecases/get_owner_graph_usecase.dart';
import 'package:dashboard_grow/features/owners/presentation/cubit/owner_graph_cubit.dart';
import 'package:dashboard_grow/features/owners/presentation/widgets/owner_graph_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:dashboard_grow/features/owners/domain/usecases/perform_owner_action_usecase.dart';

class OwnerDetailsPage extends StatelessWidget {
  final String ownerId;

  const OwnerDetailsPage({super.key, required this.ownerId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OwnerDetailsCubit(
            GetOwnerDetailsUseCase(OwnersRepositoryImpl()),
            PerformOwnerActionUseCase(OwnersRepositoryImpl()),
          )..getOwnerDetails(ownerId),
        ),
        BlocProvider(
          create: (context) => OwnerGraphCubit(
            GetOwnerGraphUseCase(OwnersRepositoryImpl()),
          ),
        ),
      ],
      child: _OwnerDetailsView(ownerId: ownerId),
    );
  }
}

class _OwnerDetailsView extends StatelessWidget {
  final String ownerId;
  const _OwnerDetailsView({required this.ownerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        title: Text('Owner Details', style: AppTextStyle.heading3),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<OwnerDetailsCubit, OwnerDetailsState>(
        builder: (context, state) {
          if (state is OwnerDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OwnerDetailsFailure) {
            return Center(
              child: Text(state.message,
                  style: AppTextStyle.bodyRegular
                      .copyWith(color: AppColors.error)),
            );
          } else if (state is OwnerDetailsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(context, state.owner.profile),
                  const SizedBox(height: 24),
                  _buildStatsCards(state.owner),
                  const SizedBox(height: 24),
                  OwnerGraphSection(ownerId: ownerId),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildSectionHeader('Kiosks'),
                            const SizedBox(height: 16),
                            _buildKiosksList(state.owner.kiosks),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            _buildSectionHeader('Recent History'),
                            const SizedBox(height: 16),
                            _buildHistoryList(state.owner.history),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(title,
              overflow: TextOverflow.ellipsis, style: AppTextStyle.heading3),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, OwnerProfile profile) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(profile.fullName,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.heading2),
                          ),
                          const SizedBox(width: 12),
                          _buildStatusBadge(profile.status),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(context, profile),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone,
                        size: 16, color: AppColors.neutral500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(profile.phone,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.bodyRegular
                              .copyWith(color: AppColors.neutral600)),
                    ),
                    const SizedBox(width: 24),
                    const Icon(Icons.calendar_today,
                        size: 16, color: AppColors.neutral500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                          'Joined ${DateFormat('MMM d, yyyy').format(profile.createdAt)}',
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.bodyRegular
                              .copyWith(color: AppColors.neutral600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, OwnerProfile profile) {
    // Actions based on status
    // PENDING -> Verify, Reject
    // ACTIVE -> Freeze, Delete
    // SUSPENDED/FROZEN -> Activate

    List<Widget> actions = [];

    if (profile.status.toUpperCase() == 'PENDING') {
      actions.add(_buildActionBtn(
          context, 'Adjust Status', Icons.edit_note, AppColors.primary, () {
        _showActionSelectionDialog(context, profile.id, ['VERIFY', 'REJECT']);
      }));
    } else if (profile.status.toUpperCase() == 'ACTIVE' ||
        profile.status.toUpperCase() == 'APPROVED') {
      actions.add(_buildActionBtn(
          context, 'Adjust Status', Icons.warning_amber, AppColors.warning, () {
        _showActionSelectionDialog(context, profile.id, ['FREEZE', 'DELETE']);
      }));
    } else if (profile.status.toUpperCase() == 'SUSPENDED' ||
        profile.status.toUpperCase() == 'FROZEN' ||
        profile.status.toUpperCase() == 'REJECTED') {
      actions.add(_buildActionBtn(
          context, 'Activate', Icons.check_circle, AppColors.success, () {
        _showActionDialog(context, profile.id, 'ACTIVATE');
      }));
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return Row(children: actions);
  }

  Widget _buildActionBtn(BuildContext context, String label, IconData icon,
      Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(label,
                style: AppTextStyle.bodySmall
                    .copyWith(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showActionSelectionDialog(
      BuildContext context, String ownerId, List<String> options) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Text('Select Action', style: AppTextStyle.heading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((action) {
            Color color = AppColors.primary;
            if (action == 'REJECT' ||
                action == 'DELETE' ||
                action == 'FREEZE') {
              color = AppColors.error;
            } else if (action == 'VERIFY' || action == 'ACTIVATE') {
              color = AppColors.success;
            }

            return ListTile(
              leading: Icon(Icons.circle, color: color, size: 12),
              title: Text(action, style: AppTextStyle.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                _showActionDialog(context, ownerId, action);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showActionDialog(BuildContext context, String ownerId, String action) {
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<OwnerDetailsCubit>(),
        child: AlertDialog(
          backgroundColor: AppColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('$action Owner', style: AppTextStyle.heading3),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Are you sure you want to $action this owner? Please provide a reason.',
                    style: AppTextStyle.bodySmall),
                const SizedBox(height: 16),
                TextFormField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    labelText: 'Reason',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Reason is required'
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<OwnerDetailsCubit>().performAction(
                        id: ownerId,
                        action: action,
                        reason: reasonController.text,
                      );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child:
                  const Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;
    String label = status;

    switch (status.toUpperCase()) {
      case 'APPROVED':
      case 'ACTIVE': // Handle ACTIVE as well
        bg = AppColors.success.withOpacity(0.1);
        fg = AppColors.success;
        label = 'Active';
        break;
      case 'PENDING':
        bg = AppColors.warning.withOpacity(0.1);
        fg = AppColors.warning;
        break;
      case 'SUSPENDED':
      case 'frozen': // check case
      case 'FROZEN':
      case 'REJECTED':
        bg = AppColors.error.withOpacity(0.1);
        fg = AppColors.error;
        break;
      default:
        bg = AppColors.neutral100;
        fg = AppColors.neutral600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyle.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatsCards(OwnerDetailsModel owner) {
    return LayoutBuilder(builder: (context, constraints) {
      final isSmallScreen = constraints.maxWidth < 600;
      final cardWidth = isSmallScreen
          ? (constraints.maxWidth - 16) / 2
          : (constraints.maxWidth - 32) / 3;

      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          SizedBox(
            width: cardWidth,
            child: _buildInfoCard(
              title: 'Wallet Balance',
              value: '${owner.financials.walletBalance.toStringAsFixed(2)} EGP',
              icon: Icons.account_balance_wallet,
              color: AppColors.primary,
            ),
          ),
          SizedBox(
            width: cardWidth,
            child: _buildInfoCard(
              title: 'Total Commission',
              value:
                  '${owner.financials.totalCommissionEarned.toStringAsFixed(2)} EGP',
              icon: Icons.monetization_on,
              color: AppColors.success,
            ),
          ),
          SizedBox(
            width: isSmallScreen ? constraints.maxWidth : cardWidth,
            child: _buildInfoCard(
              title: 'Total Transactions',
              value: owner.activity.totalTransactions.toString(),
              icon: Icons.receipt_long,
              color: AppColors.secondary,
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
              Expanded(
                child: Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.bodySmall
                        .copyWith(color: AppColors.neutral500)),
              ),
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

  Widget _buildKiosksList(List<OwnerKioskItem> kiosks) {
    if (kiosks.isEmpty) {
      return _buildEmptyState('No kiosks assigned');
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kiosks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final kiosk = kiosks[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.storefront, color: AppColors.secondary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kiosk.name,
                        style: AppTextStyle.bodyMedium
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${kiosk.workersCount} Workers',
                        style: AppTextStyle.caption),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${kiosk.pendingDues.toStringAsFixed(2)} EGP',
                      style: AppTextStyle.bodySmall.copyWith(
                          fontWeight: FontWeight.bold, color: AppColors.error)),
                  Text('Pending Dues', style: AppTextStyle.caption),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryList(OwnerHistory history) {
    if (history.transactions.isEmpty && history.redemptions.isEmpty) {
      return _buildEmptyState('No recent activity');
    }
    // Mixing transactions and redemptions or showing just tabs could differ.
    // Showing simple list for now.
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutral200)),
      child: const Center(child: Text('History log placeholder')),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Center(
          child: Text(message,
              style: AppTextStyle.bodyRegular
                  .copyWith(color: AppColors.neutral500))),
    );
  }
}
