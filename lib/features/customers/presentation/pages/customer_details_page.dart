import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/core/widgets/custom_snackbar.dart';
import 'package:dashboard_grow/features/customers/data/models/customer_details_model.dart';
import 'package:dashboard_grow/features/customers/data/repositories/customers_repository_impl.dart';
import 'package:dashboard_grow/features/customers/domain/usecases/adjust_customer_balance_usecase.dart';
import 'package:dashboard_grow/features/customers/domain/usecases/get_customer_details_usecase.dart';
import 'package:dashboard_grow/features/customers/domain/usecases/update_customer_status_usecase.dart';
import 'package:dashboard_grow/features/customers/presentation/cubit/customer_balance_cubit.dart';
import 'package:dashboard_grow/features/customers/presentation/cubit/customer_details_cubit.dart';
import 'package:dashboard_grow/features/customers/presentation/cubit/customer_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CustomerDetailsPage extends StatelessWidget {
  final String customerId;

  const CustomerDetailsPage({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    final repository = CustomersRepositoryImpl();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CustomerDetailsCubit(GetCustomerDetailsUseCase(repository))
                ..getCustomerDetails(customerId),
        ),
        BlocProvider(
          create: (context) =>
              CustomerBalanceCubit(AdjustCustomerBalanceUseCase(repository)),
        ),
        BlocProvider(
          create: (context) =>
              CustomerStatusCubit(UpdateCustomerStatusUseCase(repository)),
        ),
      ],
      child: const _CustomerDetailsView(),
    );
  }
}

class _CustomerDetailsView extends StatelessWidget {
  const _CustomerDetailsView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CustomerDetailsCubit, CustomerDetailsState>(
          listener: (context, state) {
            if (state is CustomerDetailsFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                  message: state.message,
                  type: SnackBarType.error,
                ),
              );
            }
          },
        ),
        BlocListener<CustomerBalanceCubit, CustomerBalanceState>(
          listener: (context, state) {
            if (state is CustomerBalanceSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                  message: 'Balance adjusted successfully',
                  type: SnackBarType.success,
                ),
              );
              Navigator.of(context).pop(); // Close dialog
              _refreshDetails(context);
            } else if (state is CustomerBalanceFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                  message: state.message,
                  type: SnackBarType.error,
                ),
              );
            }
          },
        ),
        BlocListener<CustomerStatusCubit, CustomerStatusState>(
          listener: (context, state) {
            if (state is CustomerStatusSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                  message: 'Status updated successfully',
                  type: SnackBarType.success,
                ),
              );
              Navigator.of(context).pop(); // Close dialog
              _refreshDetails(context);
            } else if (state is CustomerStatusFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                  message: state.message,
                  type: SnackBarType.error,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xffF8FAFC),
        appBar: AppBar(
          title: Text('Customer Details', style: AppTextStyle.heading3),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<CustomerDetailsCubit, CustomerDetailsState>(
          builder: (context, state) {
            if (state is CustomerDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CustomerDetailsLoaded) {
              final customer = state.customer;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(context, customer.profile),
                    const SizedBox(height: 24),
                    _buildStatsCards(customer),
                    const SizedBox(height: 32),
                    Text('Active Spaces', style: AppTextStyle.heading3),
                    const SizedBox(height: 16),
                    _buildSpacesList(customer.spaces),
                    const SizedBox(height: 32),
                    Text('Kiosk Interactions', style: AppTextStyle.heading3),
                    const SizedBox(height: 16),
                    _buildKiosksList(customer.kioskInteractions),
                    const SizedBox(height: 32),
                    Text('Recent Transactions', style: AppTextStyle.heading3),
                    const SizedBox(height: 16),
                    _buildTransactionsList(customer.recentTransactions),
                  ],
                ),
              );
            } else if (state is CustomerDetailsFailure) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load customer details',
                      style: AppTextStyle.bodyRegular),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () => _refreshDetails(context),
                      child: const Text('Retry'))
                ],
              ));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _refreshDetails(BuildContext context) {
    final state = context.read<CustomerDetailsCubit>().state;
    if (state is CustomerDetailsLoaded) {
      context
          .read<CustomerDetailsCubit>()
          .getCustomerDetails(state.customer.profile.id);
    }
  }

  Widget _buildProfileHeader(BuildContext context, CustomerProfile profile) {
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
                Text(profile.fullName, style: AppTextStyle.heading2),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone,
                        size: 16, color: AppColors.neutral500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(profile.phone,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.bodyRegular),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusBadge(profile.isActive),
                    if (profile.isVerified) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.verified,
                          size: 20, color: AppColors.primary),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: AppColors.neutral500),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Joined ${DateFormat('MMM d, yyyy').format(profile.createdAt)}',
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.caption,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.smartphone,
                        size: 14,
                        color: profile.appDownloaded
                            ? AppColors.success
                            : AppColors.neutral500),
                    const SizedBox(width: 4),
                    Text(
                      profile.appDownloaded ? 'App Installed' : 'No App',
                      style: AppTextStyle.caption.copyWith(
                          color: profile.appDownloaded
                              ? AppColors.success
                              : AppColors.neutral500),
                    ),
                  ],
                )
              ],
            ),
          ),
          Column(
            children: [
              ElevatedButton.icon(
                onPressed: () => _showAdjustBalanceDialog(context, profile.id),
                icon: const Icon(Icons.account_balance_wallet, size: 18),
                label: const Text('Adjust Balance'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () =>
                    _showStatusDialog(context, profile.id, profile.isActive),
                icon: Icon(
                    profile.isActive ? Icons.block : Icons.check_circle_outline,
                    size: 18),
                label: Text(profile.isActive ? 'Suspend' : 'Activate'),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      profile.isActive ? AppColors.error : AppColors.success,
                  side: BorderSide(
                      color: profile.isActive
                          ? AppColors.error
                          : AppColors.success),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAdjustBalanceDialog(BuildContext context, String customerId) {
    final amountController = TextEditingController();
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<CustomerBalanceCubit>(),
        child: AlertDialog(
          backgroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance_wallet,
                    size: 32, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text('Adjust Balance', style: AppTextStyle.heading3),
              const SizedBox(height: 8),
              Text(
                'Enter the amount to adjust the customer\'s balance.',
                style: AppTextStyle.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: amountController,
                  style: AppTextStyle.bodyRegular,
                  decoration: InputDecoration(
                    labelText: 'Amount (EGP)',
                    hintText: 'e.g., 50 or -50',
                    hintStyle: AppTextStyle.caption,
                    labelStyle: AppTextStyle.bodyMedium,
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
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.neutral100.withOpacity(0.5),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: reasonController,
                  style: AppTextStyle.bodyRegular,
                  decoration: InputDecoration(
                    labelText: 'Reason',
                    hintText: 'Why are you adjusting the balance?',
                    hintStyle: AppTextStyle.caption,
                    labelStyle: AppTextStyle.bodyMedium,
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
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.neutral100.withOpacity(0.5),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.neutral300),
                      ),
                    ),
                    child: Text('Cancel',
                        style: AppTextStyle.bodyMedium
                            .copyWith(color: AppColors.textPrimary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child:
                      BlocBuilder<CustomerBalanceCubit, CustomerBalanceState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is CustomerBalanceLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  context
                                      .read<CustomerBalanceCubit>()
                                      .adjustBalance(
                                        id: customerId,
                                        amount:
                                            double.parse(amountController.text),
                                        reason: reasonController.text,
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is CustomerBalanceLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : Text('Submit',
                                style: AppTextStyle.button
                                    .copyWith(color: Colors.white)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusDialog(
      BuildContext context, String customerId, bool isActive) {
    final noteController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final newStatus = isActive ? 'SUSPENDED' : 'ACTIVE';
    final actionColor = isActive ? AppColors.error : AppColors.success;
    final actionIcon = isActive ? Icons.block : Icons.check_circle_outline;

    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<CustomerStatusCubit>(),
        child: AlertDialog(
          backgroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: actionColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(actionIcon, size: 32, color: actionColor),
              ),
              const SizedBox(height: 16),
              Text(
                isActive ? 'Suspend Customer' : 'Activate Customer',
                style: AppTextStyle.heading3,
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to ${isActive ? 'suspend' : 'activate'} this customer?',
                style: AppTextStyle.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: noteController,
                  style: AppTextStyle.bodyRegular,
                  decoration: InputDecoration(
                    labelText: 'Note / Reason',
                    hintText: 'Add a note for this action',
                    hintStyle: AppTextStyle.caption,
                    labelStyle: AppTextStyle.bodyMedium,
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
                      borderSide: BorderSide(color: actionColor, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.neutral100.withOpacity(0.5),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a note';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.neutral300),
                      ),
                    ),
                    child: Text('Cancel',
                        style: AppTextStyle.bodyMedium
                            .copyWith(color: AppColors.textPrimary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BlocBuilder<CustomerStatusCubit, CustomerStatusState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: actionColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: state is CustomerStatusLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  context
                                      .read<CustomerStatusCubit>()
                                      .updateStatus(
                                        id: customerId,
                                        status: newStatus,
                                        note: noteController.text,
                                      );
                                }
                              },
                        child: state is CustomerStatusLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : Text(isActive ? 'Suspend' : 'Activate',
                                style: AppTextStyle.button
                                    .copyWith(color: Colors.white)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(CustomerDetailsModel customer) {
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
              title: 'Total Balance',
              value: '${customer.balance.toStringAsFixed(2)} EGP',
              icon: Icons.account_balance_wallet,
              color: AppColors.primary,
            ),
          ),
          SizedBox(
            width: cardWidth,
            child: _buildInfoCard(
              title: 'Points Earned',
              value: '${customer.totalPointsReceived.toInt()}',
              icon: Icons.star,
              color: AppColors.warning,
            ),
          ),
          SizedBox(
            width: isSmallScreen ? constraints.maxWidth : cardWidth,
            child: _buildInfoCard(
              title: 'Transactions',
              value: customer.totalTransactions.toString(),
              icon: Icons.receipt,
              color: AppColors.success,
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

  Widget _buildSpacesList(List<CustomerSpace> spaces) {
    if (spaces.isEmpty) {
      return _buildEmptyState('No active spaces');
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.8,
      ),
      itemCount: spaces.length,
      itemBuilder: (context, index) {
        final space = spaces[index];
        final progress =
            space.target > 0 ? (space.balance / space.target) : 0.0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(space.name,
                      style: AppTextStyle.bodyMedium
                          .copyWith(fontWeight: FontWeight.bold)),
                  Icon(Icons.savings,
                      color: AppColors.primary.withOpacity(0.7)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '${space.balance.toStringAsFixed(0)} / ${space.target.toStringAsFixed(0)}',
                          style: AppTextStyle.bodySmall
                              .copyWith(fontWeight: FontWeight.bold)),
                      Text('${(progress * 100).toStringAsFixed(1)}%',
                          style: AppTextStyle.caption
                              .copyWith(color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: AppColors.neutral100,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              Text(
                  'Deadline: ${DateFormat('MMM d, yyyy').format(space.deadline)}',
                  style: AppTextStyle.caption
                      .copyWith(color: AppColors.neutral500)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKiosksList(List<CustomerKioskInteraction> interactions) {
    if (interactions.isEmpty) {
      return _buildEmptyState('No kiosk interactions yet');
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: interactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final interaction = interactions[index];
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
                    Text(interaction.kioskName,
                        style: AppTextStyle.bodyMedium
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${interaction.transactionCount} Transactions',
                        style: AppTextStyle.caption),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${interaction.totalReceived.toStringAsFixed(0)} EGP',
                      style: AppTextStyle.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.success)),
                  Text('Total Received', style: AppTextStyle.caption),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionsList(List<CustomerTransaction> transactions) {
    if (transactions.isEmpty) {
      return _buildEmptyState('No recent transactions');
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.neutral100,
              child: const Icon(Icons.receipt_long,
                  size: 20, color: AppColors.neutral600),
            ),
            title: Text(tx.kioskName,
                style: AppTextStyle.bodySmall
                    .copyWith(fontWeight: FontWeight.bold)),
            subtitle: Text(
                DateFormat('MMM d, yyyy - hh:mm a').format(tx.createdAt),
                style: AppTextStyle.caption),
            trailing: Text('+${tx.amount.toStringAsFixed(2)} EGP',
                style: AppTextStyle.bodySmall.copyWith(
                    fontWeight: FontWeight.bold, color: AppColors.success)),
          );
        },
      ),
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

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color:
            (isActive ? AppColors.success : AppColors.error).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'INACTIVE',
        style: AppTextStyle.caption.copyWith(
          color: isActive ? AppColors.success : AppColors.error,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
