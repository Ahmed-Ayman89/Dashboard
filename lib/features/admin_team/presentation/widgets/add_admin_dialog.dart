import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/app_text_style.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/admin_model.dart';
import '../cubit/admin_team_cubit.dart';
import '../cubit/admin_team_state.dart';

class AddAdminDialog extends StatefulWidget {
  const AddAdminDialog({super.key});

  @override
  State<AddAdminDialog> createState() => _AddAdminDialogState();
}

class _AddAdminDialogState extends State<AddAdminDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedRole;

  final List<String> _roles = ['SUPER_ADMIN', 'EDITOR', 'VIEWER'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = CreateAdminRequest(
        fullName: _nameController.text,
        phone: _phoneController.text,
        adminRole: _selectedRole!,
      );
      context.read<AdminTeamCubit>().createAdmin(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminTeamCubit, AdminTeamState>(
      listener: (context, state) {
        if (state is AdminTeamActionSuccess) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final isLoading = state is AdminTeamActionLoading;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Add New Admin', style: AppTextStyle.heading3),
          content: Container(
            width: 400, // Fixed width for desktop/tablet look
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    style: AppTextStyle.bodyRegular,
                    decoration:
                        _buildInputDecoration('Full Name', 'Enter full name'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Full name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    style: AppTextStyle.bodyRegular,
                    decoration:
                        _buildInputDecoration('Phone', 'Enter phone number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Phone is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    style: AppTextStyle.bodyRegular,
                    decoration: _buildInputDecoration('Role', 'Select role'),
                    items: _roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role.replaceAll('_', ' ')),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Role is required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: AppTextStyle.button
                      .copyWith(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: isLoading ? null : _onSubmit,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text('Add Member', style: AppTextStyle.button),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _buildInputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle:
          AppTextStyle.bodyMedium.copyWith(color: AppColors.textSecondary),
      hintStyle: AppTextStyle.caption.copyWith(color: AppColors.neutral400),
      filled: true,
      fillColor: AppColors.neutral100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.neutral300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.neutral300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
