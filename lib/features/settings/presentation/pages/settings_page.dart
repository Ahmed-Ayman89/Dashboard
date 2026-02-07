import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/network/api_helper.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:dashboard_grow/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:dashboard_grow/features/settings/domain/entities/settings.dart';
import 'package:dashboard_grow/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:dashboard_grow/features/settings/domain/usecases/update_settings_usecase.dart';
import 'package:dashboard_grow/features/settings/presentation/cubit/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiHelper = APIHelper();
    final remoteDataSource = SettingsRemoteDataSourceImpl(apiHelper: apiHelper);
    final repository =
        SettingsRepositoryImpl(remoteDataSource: remoteDataSource);

    return BlocProvider(
      create: (context) => SettingsCubit(
        getSettingsUseCase: GetSettingsUseCase(repository: repository),
        updateSettingsUseCase: UpdateSettingsUseCase(repository: repository),
      )..getSettings(),
      child: Scaffold(
        body: BlocConsumer<SettingsCubit, SettingsState>(
          listener: (context, state) {
            if (state is SettingsActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                ),
              );
            } else if (state is SettingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SettingsLoaded) {
              return _SettingsContent(settings: state.settings);
            } else if (state is SettingsActionLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  final Settings settings;

  const _SettingsContent({required this.settings});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Platform Settings', style: AppTextStyle.heading1),
          const SizedBox(height: 32),
          _buildSection('Global Settings', [
            _buildSettingItem(context, 'Daily Kiosk Limit',
                settings.global.dailyKioskLimit.toString(), 'daily_kiosk_limit',
                isNumber: true),
            _buildSettingItem(
                context,
                'Same Customer Limit',
                settings.global.sameCustomerLimit.toString(),
                'same_customer_limit',
                isNumber: true),
            _buildSettingItem(
                context,
                'Min Redemption Amount',
                settings.global.minRedemptionAmount.toString(),
                'min_redemption_amount',
                isNumber: true),
            _buildSettingItem(
                context,
                'Min Sending Amount',
                settings.global.minSendingAmount.toString(),
                'min_sending_amount',
                isNumber: true),
            _buildSettingItem(context, 'Goal Setup Limit',
                settings.global.goalSetupLimit.toString(), 'goal_setup_limit',
                isNumber: true),
          ]),
          const SizedBox(height: 24),
          _buildSection('Financial Settings', [
            _buildSettingItem(
                context,
                'Commission Amount',
                settings.financial.commissionAmount.toString(),
                'commission_amount',
                isNumber: true),
            _buildSettingItem(context, 'Commission Type',
                settings.financial.commissionType, 'commission_type'),
          ]),
          const SizedBox(height: 24),
          _buildSection('Rules & Policies', [
            _buildSettingItem(context, 'KYC Requirements',
                settings.rules.kycRequirements, 'kyc_requirements'),
            _buildSettingItem(context, 'Worker Restrictions',
                settings.rules.workerRestrictions, 'worker_restrictions'),
            _buildSettingItem(context, 'Account Freeze Rules',
                settings.rules.accountFreezeRules, 'account_freeze_rules'),
            _buildSettingItem(context, 'Terms & Conditions',
                settings.rules.termsAndConditions, 'terms_and_conditions'),
            _buildSettingItem(context, 'Privacy Policy',
                settings.rules.privacyPolicy, 'privacy_policy'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
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
          Text(title, style: AppTextStyle.heading2),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, String label, String value, String key,
      {bool isNumber = false}) {
    return InkWell(
      onTap: () => _showEditDialog(context, label, value, key, isNumber),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: AppTextStyle.bodyMedium
                    .copyWith(color: AppColors.neutral500)),
            const SizedBox(width: 16),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      style: AppTextStyle.bodyMedium
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit, size: 16, color: AppColors.neutral500),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String label, String currentValue,
      String key, bool isNumber) {
    final controller = TextEditingController(text: currentValue);
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit $label', style: AppTextStyle.heading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update the value and provide a description for this change.',
              style: AppTextStyle.bodyMedium,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              style: AppTextStyle.bodyRegular,
              decoration: InputDecoration(
                labelText: 'New Value',
                labelStyle: AppTextStyle.bodyMedium,
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
                hintText: 'Enter new $label',
                hintStyle: AppTextStyle.bodySmall,
                filled: true,
                fillColor: AppColors.neutral100,
              ),
              keyboardType: isNumber
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
              inputFormatters: isNumber
                  ? [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'))
                    ]
                  : [],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              style: AppTextStyle.bodyRegular,
              decoration: InputDecoration(
                labelText: 'Description / Reason',
                labelStyle: AppTextStyle.bodyMedium,
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
                hintText: 'Why are you changing this?',
                hintStyle: AppTextStyle.bodySmall,
                filled: true,
                fillColor: AppColors.neutral100,
              ),
              maxLines: 3,
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
              final newValue = controller.text;
              final description = descriptionController.text;

              if (newValue.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Value cannot be empty')),
                );
                return;
              }

              if (description.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Description is required')),
                );
                return;
              }

              dynamic valueToSend = newValue;
              if (isNumber) {
                valueToSend = num.tryParse(newValue);
                if (valueToSend == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid number format')),
                  );
                  return;
                }
              }

              context
                  .read<SettingsCubit>()
                  .updateSetting(key, valueToSend, description);
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
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
