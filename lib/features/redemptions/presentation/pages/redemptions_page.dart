import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/redemptions/data/models/redemption_model.dart';
import 'package:dashboard_grow/features/redemptions/data/repositories/redemptions_repository_impl.dart';
import 'package:dashboard_grow/features/redemptions/domain/usecases/get_redemptions_usecase.dart';
import 'package:dashboard_grow/features/redemptions/domain/usecases/process_redemption_usecase.dart';
import 'package:dashboard_grow/features/redemptions/presentation/cubit/redemptions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RedemptionsPage extends StatelessWidget {
  const RedemptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = RedemptionsRepositoryImpl();
        return RedemptionsCubit(
          GetRedemptionsUseCase(repository),
          ProcessRedemptionUseCase(repository),
        )..getRedemptions();
      },
      child: const _RedemptionsView(),
    );
  }
}

class _RedemptionsView extends StatelessWidget {
  const _RedemptionsView();

  void _showProcessDialog(BuildContext context, String id) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Process Redemption', style: AppTextStyle.heading3),
                  const SizedBox(height: 12),
                  Text(
                    'Do you want to Approve or Reject this redemption request?',
                    style: AppTextStyle.bodyRegular
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      labelText: 'Note (Optional)',
                      labelStyle: AppTextStyle.bodyMedium,
                      hintText: 'Add a note for the user...',
                      hintStyle: AppTextStyle.bodySmall
                          .copyWith(color: AppColors.neutral400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: AppColors.neutral300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: AppColors.neutral300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: AppColors.brandPrimary),
                      ),
                      filled: true,
                      fillColor: AppColors.neutral500,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    maxLines: 3,
                    style: AppTextStyle.bodyRegular,
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        child: Text('Cancel',
                            style: AppTextStyle.button
                                .copyWith(color: AppColors.neutral600)),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          context.read<RedemptionsCubit>().processRedemption(
                                id: id,
                                action: 'REJECT',
                                note: noteController.text,
                              );
                          Navigator.pop(dialogContext);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          side: const BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Reject',
                            style: AppTextStyle.button
                                .copyWith(color: AppColors.error)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          context.read<RedemptionsCubit>().processRedemption(
                                id: id,
                                action: 'APPROVE',
                                note: noteController.text,
                              );
                          Navigator.pop(dialogContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: Text('Approve', style: AppTextStyle.button),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Redemptions Requests', style: AppTextStyle.heading2),
                _buildFilterChips(context),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.neutral200),
                ),
                child: BlocConsumer<RedemptionsCubit, RedemptionsState>(
                  listener: (context, state) {
                    if (state is RedemptionProcessSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    } else if (state is RedemptionsFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is RedemptionsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RedemptionsLoaded) {
                      return _buildList(context, state.redemptions);
                    } else if (state is RedemptionsFailure) {
                      return Center(
                        child: Text(state.message,
                            style: AppTextStyle.bodyRegular
                                .copyWith(color: AppColors.error)),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<RedemptionModel> redemptions) {
    if (redemptions.isEmpty) {
      return Center(
          child: Text('No pending redemptions',
              style: AppTextStyle.bodyRegular
                  .copyWith(color: AppColors.neutral500)));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: AppColors.neutral200,
          dataTableTheme: DataTableThemeData(
            headingRowColor: WidgetStateProperty.all(AppColors.neutral100),
            dataRowColor: WidgetStateProperty.all(AppColors.white),
          ),
        ),
        child: DataTable(
          columns: [
            DataColumn(label: Text('Date', style: AppTextStyle.caption)),
            DataColumn(label: Text('Phone', style: AppTextStyle.caption)),
            DataColumn(label: Text('Role', style: AppTextStyle.caption)),
            DataColumn(label: Text('Amount', style: AppTextStyle.caption)),
            DataColumn(label: Text('Method', style: AppTextStyle.caption)),
            DataColumn(label: Text('Details', style: AppTextStyle.caption)),
            DataColumn(label: Text('Actions', style: AppTextStyle.caption)),
          ],
          rows: redemptions.map((redemption) {
            return DataRow(cells: [
              DataCell(Text(
                  DateFormat('MMM d, yyyy').format(redemption.createdAt),
                  style: AppTextStyle.bodySmall)),
              DataCell(
                  Text(redemption.userPhone, style: AppTextStyle.bodySmall)),
              DataCell(_buildRoleBadge(redemption.userRole)),
              DataCell(Text('${redemption.amount.toStringAsFixed(2)} EGP',
                  style: AppTextStyle.bodySmall)),
              DataCell(Text(redemption.method, style: AppTextStyle.bodySmall)),
              DataCell(Text(redemption.details, style: AppTextStyle.bodySmall)),
              DataCell(
                ElevatedButton(
                  onPressed: () => _showProcessDialog(context, redemption.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'Process',
                    style: AppTextStyle.setCairoWhite(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color color = AppColors.neutral600;
    if (role.toUpperCase() == 'WORKER') color = AppColors.brandSecondary;
    if (role.toUpperCase() == 'CUSTOMER') color = AppColors.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        role.toUpperCase(),
        style: AppTextStyle.caption
            .copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Row(
      children: [
        _buildFilterChip(context, 'Pending', AppColors.warning),
        const SizedBox(width: 8),
        _buildFilterChip(context, 'Approved', AppColors.success),
        const SizedBox(width: 8),
        _buildFilterChip(context, 'Rejected', AppColors.error),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, Color color) {
    return BlocBuilder<RedemptionsCubit, RedemptionsState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context
                .read<RedemptionsCubit>()
                .getRedemptions(status: label.toUpperCase());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.neutral200),
            ),
            child: Row(
              children: [
                Icon(Icons.circle, size: 8, color: color),
                const SizedBox(width: 6),
                Text(label,
                    style: AppTextStyle.bodySmall
                        .copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );
      },
    );
  }
}
