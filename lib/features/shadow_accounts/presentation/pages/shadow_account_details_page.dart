import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/shadow_accounts/data/repositories/shadow_account_repository_impl.dart';
import 'package:dashboard_grow/features/shadow_accounts/domain/usecases/get_shadow_account_details_usecase.dart';
import 'package:dashboard_grow/features/shadow_accounts/presentation/cubit/shadow_account_details_cubit.dart';
import 'package:dashboard_grow/features/shadow_accounts/domain/usecases/update_follow_up_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ShadowAccountDetailsPage extends StatelessWidget {
  final String phone;

  const ShadowAccountDetailsPage({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShadowAccountDetailsCubit(
        GetShadowAccountDetailsUseCase(ShadowAccountRepositoryImpl()),
        UpdateFollowUpUseCase(ShadowAccountRepositoryImpl()),
      )..getDetails(phone),
      child: Scaffold(
        backgroundColor: const Color(0xffF8FAFC),
        appBar: AppBar(
          title: Text('Account Details', style: AppTextStyle.heading2),
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<ShadowAccountDetailsCubit, ShadowAccountDetailsState>(
          builder: (context, state) {
            if (state is ShadowAccountDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ShadowAccountDetailsFailure) {
              return Center(
                child: Text(state.message,
                    style: AppTextStyle.bodyRegular
                        .copyWith(color: AppColors.error)),
              );
            } else if (state is ShadowAccountDetailsLoaded) {
              final details = state.details;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(
                        context,
                        details.shadowAccount.phone,
                        details.shadowAccount.balance,
                        details.shadowAccount.lastFollowUp),
                    const SizedBox(height: 32),
                    Text('Transaction History', style: AppTextStyle.heading2),
                    const SizedBox(height: 16),
                    _buildTransactionsList(details.transactions),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String phone, String balance,
      String? lastFollowUp) {
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone Number', style: AppTextStyle.caption),
                  const SizedBox(height: 4),
                  Text(phone, style: AppTextStyle.heading3),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Available Balance', style: AppTextStyle.caption),
                  const SizedBox(height: 4),
                  Text('$balance points',
                      style: AppTextStyle.heading3
                          .copyWith(color: AppColors.primary)),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Last Follow Up', style: AppTextStyle.caption),
                  const SizedBox(height: 4),
                  Text(
                      lastFollowUp != null && lastFollowUp.isNotEmpty
                          ? _formatDate(lastFollowUp)
                          : 'Not set',
                      style: AppTextStyle.bodyMedium
                          .copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _selectDate(context, phone),
                icon: const Icon(Icons.calendar_today, size: 16),
                label: const Text('Update Follow-up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String phone) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      if (context.mounted) {
        context
            .read<ShadowAccountDetailsCubit>()
            .updateFollowUp(phone, formattedDate);
      }
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (_) {
      try {
        final date = DateFormat('dd-MM-yyyy').parse(dateStr);
        return DateFormat('dd-MM-yyyy').format(date);
      } catch (_) {
        return dateStr;
      }
    }
  }

  Widget _buildTransactionsList(List transactions) {
    if (transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: Text('No transactions found.')),
      );
    }

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
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final t = transactions[index];
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t.kioskName,
                    style: AppTextStyle.bodyMedium
                        .copyWith(fontWeight: FontWeight.bold)),
                Text('${t.amountNet} points',
                    style: AppTextStyle.setPoppinsTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success)),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Sender: ${t.senderName} (${t.senderRole})',
                    style: AppTextStyle.caption),
                Text(DateFormat('MMM d, yyyy HH:mm').format(t.createdAt),
                    style: AppTextStyle.caption),
              ],
            ),
          );
        },
      ),
    );
  }
}
