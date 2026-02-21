import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helper/app_text_style.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/set_password_usecase.dart';
import '../cubit/set_password_cubit.dart';
import '../cubit/set_password_state.dart';
import '../../../../core/services/notification_service.dart';
import 'package:flutter/foundation.dart';

class SetPasswordPage extends StatelessWidget {
  const SetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetPasswordCubit(
        SetPasswordUseCase(AuthRepositoryImpl()),
      ),
      child: const _SetPasswordForm(),
    );
  }
}

class _SetPasswordForm extends StatefulWidget {
  const _SetPasswordForm();

  @override
  State<_SetPasswordForm> createState() => _SetPasswordFormState();
}

class _SetPasswordFormState extends State<_SetPasswordForm> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SetPasswordCubit>().setPassword(
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<SetPasswordCubit, SetPasswordState>(
        listener: (context, state) {
          if (state is SetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                message: 'Password updated successfully',
                type: SnackBarType.success,
              ),
            );

            // Sync FCM Token after successful password set (as the user is now verified)
            if (!kIsWeb &&
                (defaultTargetPlatform == TargetPlatform.android ||
                    defaultTargetPlatform == TargetPlatform.iOS)) {
              NotificationService.instance.syncCurrentToken();
            }

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
              (route) => false,
            );
          } else if (state is SetPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                message: state.message,
                type: SnackBarType.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SetPasswordLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set New Password',
                      style: AppTextStyle.heading1,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Please create a new password for your account.',
                      style: AppTextStyle.bodyRegular.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                    SizedBox(height: 48.h),

                    // Password Field
                    Text('New Password', style: AppTextStyle.bodyRegular),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Enter new password',
                        hintStyle: TextStyle(color: AppColors.neutral400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        contentPadding: EdgeInsets.all(16.w),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.neutral400,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),

                    // Confirm Password Field
                    Text('Confirm Password', style: AppTextStyle.bodyRegular),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Confirm new password',
                        hintStyle: TextStyle(color: AppColors.neutral400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        contentPadding: EdgeInsets.all(16.w),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.neutral400,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 48.h),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => _onSubmit(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Set Password',
                                style: AppTextStyle.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
