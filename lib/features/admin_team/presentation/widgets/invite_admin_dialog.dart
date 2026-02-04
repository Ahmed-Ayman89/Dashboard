import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helper/app_text_style.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../data/repositories/admin_team_repository_impl.dart';
import '../../domain/usecases/invite_admin_usecase.dart';
import '../cubit/admin_team_cubit.dart';
import '../cubit/admin_team_state.dart';

class InviteAdminDialog extends StatelessWidget {
  const InviteAdminDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminTeamCubit(
        InviteAdminUseCase(AdminTeamRepositoryImpl()),
      ),
      child: const _InviteAdminDialogContent(),
    );
  }
}

class _InviteAdminDialogContent extends StatefulWidget {
  const _InviteAdminDialogContent();

  @override
  State<_InviteAdminDialogContent> createState() =>
      _InviteAdminDialogContentState();
}

class _InviteAdminDialogContentState extends State<_InviteAdminDialogContent> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  String? _selectedRole;

  final List<String> _roles = ['SUPER_ADMIN', 'EDITOR', 'VIEWER'];

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AdminTeamCubit>().inviteAdmin(
            phone: _phoneController.text,
            fullName: _nameController.text,
            adminRole: _selectedRole!,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminTeamCubit, AdminTeamState>(
      listener: (context, state) {
        if (state is AdminTeamSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              message: state.message,
              type: SnackBarType.success,
            ),
          );
        } else if (state is AdminTeamFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              message: state.message,
              type: SnackBarType.error,
            ),
          );
        }
      },
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Container(
          width: 400.w,
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Invite New Admin', style: AppTextStyle.heading3),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text('Full Name', style: AppTextStyle.bodyRegular),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter full name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Text('Phone Number', style: AppTextStyle.bodyRegular),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (value.length < 11) return 'Invalid phone number';
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Text('Role', style: AppTextStyle.bodyRegular),
                SizedBox(height: 8.h),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    hintText: 'Select role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  items: _roles.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) return 'Please select a role';
                    return null;
                  },
                ),
                SizedBox(height: 32.h),
                BlocBuilder<AdminTeamCubit, AdminTeamState>(
                  builder: (context, state) {
                    final isLoading = state is AdminTeamLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Send Invitation',
                                style: AppTextStyle.button.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
