import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/dashboard/data/models/kiosk_detail_model.dart';
import '../../data/repositories/kiosks_repository_impl.dart';
import '../../domain/usecases/get_kiosk_details_usecase.dart';
import '../../domain/usecases/update_kiosk_usecase.dart';
import '../../domain/usecases/get_kiosk_graph_usecase.dart';
import '../cubit/kiosk_graph_cubit.dart';
import '../widgets/kiosk_graph_section.dart';
import '../../domain/usecases/change_kiosk_status_usecase.dart';
import '../../domain/usecases/adjust_kiosk_dues_usecase.dart';
import '../cubit/kiosk_details_cubit.dart';
import '../cubit/kiosk_details_state.dart';
import 'kiosk_dues_details_page.dart';

class KioskDetailsPage extends StatelessWidget {
  final String kioskId;

  const KioskDetailsPage({super.key, required this.kioskId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final repository = KiosksRepositoryImpl();
            return KioskDetailsCubit(
              GetKioskDetailsUseCase(repository),
              UpdateKioskUseCase(repository),
              ChangeKioskStatusUseCase(repository),
              AdjustKioskDuesUseCase(repository),
            )..getKioskDetails(kioskId);
          },
        ),
        BlocProvider(
          create: (context) => KioskGraphCubit(
            GetKioskGraphUseCase(KiosksRepositoryImpl()),
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xffF8FAFC),
        appBar: AppBar(
          title: const Text('Kiosk Details'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          titleTextStyle:
              AppTextStyle.heading3.copyWith(color: AppColors.textPrimary),
        ),
        body: _KioskDetailsView(kioskId: kioskId),
      ),
    );
  }
}

class _KioskDetailsView extends StatelessWidget {
  final String kioskId;
  const _KioskDetailsView({required this.kioskId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KioskDetailsCubit, KioskDetailsState>(
      builder: (context, state) {
        if (state is KioskDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is KioskDetailsFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message,
                    style: const TextStyle(color: AppColors.error)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context
                      .read<KioskDetailsCubit>()
                      .getKioskDetails(kioskId),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is KioskDetailsSuccess) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context, state.kiosk.profile),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildOwnerCard(state.kiosk.owner)),
                    const SizedBox(width: 24),
                    Expanded(
                        child: _buildDuesCard(
                            context, state.kiosk.dues, state.kiosk.profile.id)),
                  ],
                ),
                const SizedBox(height: 24),
                KioskGraphSection(kioskId: kioskId),
                const SizedBox(height: 24),
                Text('Goals', style: AppTextStyle.heading2),
                const SizedBox(height: 16),
                _buildGoalsList(state.kiosk.goals),
                const SizedBox(height: 24),
                Text('Workers', style: AppTextStyle.heading2),
                const SizedBox(height: 16),
                _buildWorkersList(state.kiosk.workers),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, KioskProfile profile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.storefront,
                color: AppColors.primary, size: 36),
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
                      child: Text(profile.name, style: AppTextStyle.heading2),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              color: AppColors.primary),
                          onPressed: () => _showUpdateDialog(context, profile),
                          tooltip: 'Edit Kiosk',
                        ),
                        const SizedBox(width: 4),
                        _buildStatusActionButton(context, profile),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (profile.location != null) ...[
                      const Icon(Icons.location_on_outlined,
                          size: 18, color: AppColors.neutral500),
                      const SizedBox(width: 4),
                      Text(profile.location!, style: AppTextStyle.bodyRegular),
                      const SizedBox(width: 16),
                    ],
                    _buildStatusBadge(profile.isActive),
                  ],
                ),
                if (profile.kioskType != null) ...[
                  const SizedBox(height: 8),
                  Text('Type: ${profile.kioskType}',
                      style: AppTextStyle.bodySmall
                          .copyWith(color: AppColors.neutral500)),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusActionButton(BuildContext context, KioskProfile profile) {
    return IconButton(
      icon: Icon(
        profile.isActive ? Icons.block_outlined : Icons.check_circle_outline,
        color: profile.isActive ? AppColors.error : AppColors.success,
      ),
      onPressed: () => _showStatusDialog(context, profile),
      tooltip: profile.isActive ? 'Suspend Kiosk' : 'Activate Kiosk',
    );
  }

  // ... (Dialog methods remain unchanged as they were just polished) ...

  Widget _buildStatusBadge(bool isActive) {
    final color = isActive ? AppColors.success : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'SUSPENDED',
        style: AppTextStyle.caption
            .copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOwnerCard(KioskOwnerDetail owner) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutral200),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline,
                  color: AppColors.textPrimary, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Owner Details',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.heading3),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Name', owner.fullName),
          _buildDetailRow('Phone', owner.phone),
        ],
      ),
    );
  }

  Widget _buildDuesCard(BuildContext context, KioskDues dues, String kioskId) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutral200),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        KioskDuesDetailsPage(kioskId: kioskId),
                  ));
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined,
                          color: AppColors.textPrimary, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Dues Details',
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.heading3),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right,
                          color: AppColors.neutral500, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_note, color: AppColors.primary),
              tooltip: 'Adjust Dues',
              onPressed: () => _showAdjustDuesDialog(context, kioskId),
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(dues.amount ?? 0).toStringAsFixed(0)} Points',
                  style:
                      AppTextStyle.heading2.copyWith(color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Status', dues.isPaid ? 'Paid' : 'Unpaid',
              isError: !dues.isPaid),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: AppTextStyle.bodyRegular
                    .copyWith(color: AppColors.textSecondary)),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(value,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: AppTextStyle.bodyRegular.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isError ? AppColors.error : AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsList(List<KioskGoal> goals) {
    if (goals.isEmpty) {
      return Center(
          child: Text("No active goals.",
              style: AppTextStyle.bodyRegular
                  .copyWith(color: AppColors.textSecondary)));
    }
    return Column(
      children: goals
          .map((goal) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.neutral200),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutral900.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(goal.title,
                            style: AppTextStyle.bodyRegular
                                .copyWith(fontWeight: FontWeight.w600)),
                        if (goal.deadline != null)
                          Text(
                              'Deadline: ${goal.deadline.toString().split(' ')[0]}',
                              style: AppTextStyle.caption
                                  .copyWith(color: AppColors.neutral500)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${goal.target}',
                            style: AppTextStyle.heading3
                                .copyWith(color: AppColors.primary)),
                        const SizedBox(height: 4),
                        _buildGoalStatusChip(goal.status),
                      ],
                    )
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildGoalStatusChip(String status) {
    Color color;
    if (status.toUpperCase() == 'ACHIEVED') {
      color = AppColors.success;
    } else if (status.toUpperCase() == 'PENDING') {
      color = AppColors.warning;
    } else {
      color = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyle.caption
            .copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildWorkersList(List<KioskWorker> workers) {
    if (workers.isEmpty) {
      return Center(
          child: Text("No workers found.",
              style: AppTextStyle.bodyRegular
                  .copyWith(color: AppColors.textSecondary)));
    }
    return Column(
      children: workers
          .map((worker) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.neutral200),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutral900.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person,
                          color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(worker.name,
                              style: AppTextStyle.bodyRegular
                                  .copyWith(fontWeight: FontWeight.w600)),
                          Text(worker.phone,
                              style: AppTextStyle.caption
                                  .copyWith(color: AppColors.neutral500)),
                        ],
                      ),
                    ),
                    _buildWorkerStatusChip(worker.status),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildWorkerStatusChip(String status) {
    Color color;
    if (status.toUpperCase() == 'ACTIVE') {
      color = AppColors.success;
    } else if (status.toUpperCase() == 'PENDING_INVITE') {
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
        status.replaceAll('_', ' ').toUpperCase(),
        style: AppTextStyle.caption
            .copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

InputDecoration _buildInputDecoration(String label, {String? hint}) {
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

void _showUpdateDialog(BuildContext context, KioskProfile profile) {
  final nameController = TextEditingController(text: profile.name);
  final locationController = TextEditingController(text: profile.location);
  final addressController = TextEditingController(text: profile.address);
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Update Kiosk', style: AppTextStyle.heading3),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              style: AppTextStyle.bodyRegular,
              decoration: _buildInputDecoration('Name'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: locationController,
              style: AppTextStyle.bodyRegular,
              decoration: _buildInputDecoration('Location'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Location is required'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: addressController,
              style: AppTextStyle.bodyRegular,
              decoration: _buildInputDecoration('Address'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Address is required' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text('Cancel',
              style:
                  AppTextStyle.button.copyWith(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              context.read<KioskDetailsCubit>().updateKiosk(
                profile.id,
                {
                  'name': nameController.text,
                  'location': locationController.text,
                  'address': addressController.text,
                },
              );
              Navigator.pop(dialogContext);
            }
          },
          child: Text('Update', style: AppTextStyle.button),
        ),
      ],
    ),
  );
}

void _showStatusDialog(BuildContext context, KioskProfile profile) {
  final reasonController = TextEditingController();
  final isSuspending = profile.isActive;
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        isSuspending ? 'Suspend Kiosk' : 'Activate Kiosk',
        style: AppTextStyle.heading3.copyWith(
          color: isSuspending ? AppColors.error : AppColors.success,
        ),
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isSuspending
                  ? 'Are you sure you want to suspend this kiosk?'
                  : 'Are you sure you want to activate this kiosk?',
              style: AppTextStyle.bodyRegular,
            ),
            if (isSuspending) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: reasonController,
                style: AppTextStyle.bodyRegular,
                decoration: _buildInputDecoration('Reason',
                    hint: 'Enter reason for suspension'),
                validator: (value) =>
                    isSuspending && (value == null || value.isEmpty)
                        ? 'Reason is required'
                        : null,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text('Cancel',
              style:
                  AppTextStyle.button.copyWith(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSuspending ? AppColors.error : AppColors.success,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            if (isSuspending) {
              if (formKey.currentState!.validate()) {
                context.read<KioskDetailsCubit>().changeStatus(
                      profile.id,
                      !profile.isActive,
                      reasonController.text,
                    );
                Navigator.pop(dialogContext);
              }
            } else {
              context.read<KioskDetailsCubit>().changeStatus(
                    profile.id,
                    !profile.isActive,
                    null,
                  );
              Navigator.pop(dialogContext);
            }
          },
          child: Text(isSuspending ? 'Suspend' : 'Activate',
              style: AppTextStyle.button),
        ),
      ],
    ),
  );
}

void _showAdjustDuesDialog(BuildContext context, String kioskId) {
  final amountController = TextEditingController();
  final reasonController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Adjust Kiosk Dues', style: AppTextStyle.heading3),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: amountController,
              style: AppTextStyle.bodyRegular,
              decoration: _buildInputDecoration('Amount (Points)',
                  hint: 'e.g. 500 or -200'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Amount is required';
                }
                if (double.tryParse(value) == null) {
                  return 'Enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: reasonController,
              style: AppTextStyle.bodyRegular,
              decoration: _buildInputDecoration('Reason'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Reason is required' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text('Cancel',
              style:
                  AppTextStyle.button.copyWith(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final amount = double.parse(amountController.text);
              context.read<KioskDetailsCubit>().adjustDues(
                    kioskId,
                    amount,
                    reasonController.text,
                  );
              Navigator.pop(dialogContext);
            }
          },
          child: Text('Adjust', style: AppTextStyle.button),
        ),
      ],
    ),
  );
}
