import 'package:flutter/material.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';

import 'package:dashboard_grow/core/widgets/custom_snackbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/usecases/set_password_usecase.dart';
import '../../../auth/presentation/cubit/set_password_cubit.dart';
import '../../../auth/presentation/cubit/set_password_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Platform Settings', style: AppTextStyle.heading1),
          const SizedBox(height: 32),
          _buildAccountSettings(),
          const SizedBox(height: 32),
          _buildGlobalSettings(),
          const SizedBox(height: 32),
          _buildFinancialSettings(),
          const SizedBox(height: 32),
          _buildSystemRules(),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    return _buildSettingsSection(
      title: 'Account Settings',
      icon: Icons.person_rounded,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Change Password',
                style: AppTextStyle.bodyRegular,
              ),
              ElevatedButton(
                onPressed: () => _showChangePasswordDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandPrimary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Change'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => SetPasswordCubit(
          SetPasswordUseCase(AuthRepositoryImpl()),
        ),
        child: const _ChangePasswordDialog(),
      ),
    );
  }

  Widget _buildGlobalSettings() {
    return _buildSettingsSection(
      title: 'Global App Settings',
      icon: Icons.settings_applications_rounded,
      children: [
        _buildSettingTile('Daily Kiosk Transaction Limit', '500 TX'),
        _buildSettingTile('Same Customer Limit (Per Day)', '3 TX'),
        _buildSettingTile('Minimum Redemption Amount', '50 EGP'),
        _buildSettingTile('Max. Kiosks per Owner', '4 Kiosks'),
        _buildSettingTile('Minimum Sending Amount', '10 Points'),
        _buildSettingTile('Maximum Sending Amount', '1000 Points'),
      ],
    );
  }

  Widget _buildFinancialSettings() {
    return _buildSettingsSection(
      title: 'Financial Settings',
      icon: Icons.monetization_on_rounded,
      children: [
        _buildSettingTile('Commission Amount', '5 Points (Fixed)'),
      ],
    );
  }

  Widget _buildSystemRules() {
    return _buildSettingsSection(
      title: 'System Rules & Legal',
      icon: Icons.gavel_rounded,
      children: [
        _buildSettingTile('Terms & Conditions Link', 'https://grow.app/terms'),
        _buildSettingTile('Privacy Policy Link', 'https://grow.app/privacy'),
      ],
    );
  }

  Widget _buildSettingsSection(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
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
          Row(
            children: [
              Icon(icon, color: AppColors.brandPrimary),
              const SizedBox(width: 12),
              Text(title, style: AppTextStyle.heading3),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.bodyRegular,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Text(value,
                  style: AppTextStyle.bodyRegular.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral700)),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.edit_rounded,
                    size: 20, color: AppColors.brandPrimary),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Change Password',
        style: AppTextStyle.heading3,
      ),
      content: SizedBox(
        width: 400.w,
        child: BlocConsumer<SetPasswordCubit, SetPasswordState>(
          listener: (context, state) {
            if (state is SetPasswordSuccess) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                  message: state.message,
                  type: SnackBarType.success,
                ),
              );
            } else if (state is SetPasswordFailure) {
              // Close dialog first if you want, or keep it open to show error
              // Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                  message: state.message,
                  type: SnackBarType.error,
                ),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      hintText: 'Enter new password',
                      prefixIcon: const Icon(Icons.lock_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.neutral300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.neutral300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.brandPrimary),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter new password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.neutral300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.neutral300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.brandPrimary),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            );
          },
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.neutral600,
          ),
          child: const Text('Cancel'),
        ),
        BlocBuilder<SetPasswordCubit, SetPasswordState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state is SetPasswordLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<SetPasswordCubit>()
                            .setPassword(_passwordController.text);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandPrimary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: state is SetPasswordLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.white),
                    )
                  : const Text('Save Password'),
            );
          },
        ),
      ],
    );
  }
}
