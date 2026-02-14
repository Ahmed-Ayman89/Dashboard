import 'package:dashboard_grow/features/admin_team/presentation/cubit/admin_team_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/app_text_style.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/usecases/create_admin_usecase.dart';
import '../../domain/usecases/get_admins_usecase.dart';
import '../cubit/admin_team_cubit.dart';
import '../widgets/add_admin_dialog.dart';
import 'package:intl/intl.dart';

class AdminTeamPage extends StatelessWidget {
  const AdminTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = AdminRepositoryImpl();
        return AdminTeamCubit(
          GetAdminsUseCase(repository),
          CreateAdminUseCase(repository),
        )..getAdmins();
      },
      child: const _AdminTeamView(),
    );
  }
}

class _AdminTeamView extends StatelessWidget {
  const _AdminTeamView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        title: Text('Admin Team', style: AppTextStyle.heading3),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: BlocConsumer<AdminTeamCubit, AdminTeamState>(
        listener: (context, state) {
          if (state is AdminTeamFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                message: state.message,
                type: SnackBarType.error,
              ),
            );
          } else if (state is AdminTeamActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                message: state.message,
                type: SnackBarType.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminTeamLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminTeamLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Team Members', style: AppTextStyle.heading3),
                      ElevatedButton.icon(
                        onPressed: () => _showAddAdminDialog(context),
                        icon: const Icon(Icons.add, size: 20),
                        label: Text('Add Member', style: AppTextStyle.button),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (state.admins.isEmpty)
                    Center(
                        child: Text('No admins found',
                            style: AppTextStyle.bodyRegular))
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.neutral200),
                      ),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                  AppColors.neutral100),
                              columns: [
                                DataColumn(
                                    label: Text('Name',
                                        style: AppTextStyle.bodyMedium.copyWith(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Phone',
                                        style: AppTextStyle.bodyMedium.copyWith(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Role',
                                        style: AppTextStyle.bodyMedium.copyWith(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Status',
                                        style: AppTextStyle.bodyMedium.copyWith(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Joined Date',
                                        style: AppTextStyle.bodyMedium.copyWith(
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: state.admins.map((admin) {
                                return DataRow(cells: [
                                  DataCell(Text(admin.fullName,
                                      style: AppTextStyle.bodyRegular)),
                                  DataCell(Text(admin.phone,
                                      style: AppTextStyle.bodyRegular)),
                                  DataCell(_buildRoleBadge(admin.adminRole)),
                                  DataCell(_buildStatusBadge(admin.status)),
                                  DataCell(Text(
                                      DateFormat('MMM d, yyyy')
                                          .format(admin.createdAt),
                                      style: AppTextStyle.bodyRegular)),
                                ]);
                              }).toList(),
                            ),
                          ),
                          _buildPagination(context, state),
                        ],
                      ),
                    ),
                ],
              ),
            );
          } else if (state is AdminTeamFailure &&
              state is! AdminTeamActionLoading) {
            // Show empty or retry button
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Failed to load team', style: AppTextStyle.bodyRegular),
                TextButton(
                    onPressed: () => context.read<AdminTeamCubit>().getAdmins(),
                    child: const Text('Retry'))
              ],
            ));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddAdminDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<AdminTeamCubit>(),
        child: const AddAdminDialog(),
      ),
    );
  }

  Widget _buildPagination(BuildContext context, AdminTeamLoaded state) {
    final totalPages = (state.total / state.limit).ceil();
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${(state.page - 1) * state.limit + 1} to ${state.page * state.limit > state.total ? state.total : state.page * state.limit} of ${state.total} members',
            style: AppTextStyle.caption,
          ),
          Row(
            children: [
              IconButton(
                onPressed: state.page > 1
                    ? () => context
                        .read<AdminTeamCubit>()
                        .getAdmins(page: state.page - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text('Page ${state.page} of $totalPages',
                  style: AppTextStyle.bodySmall),
              const SizedBox(width: 8),
              IconButton(
                onPressed: state.page < totalPages
                    ? () => context
                        .read<AdminTeamCubit>()
                        .getAdmins(page: state.page + 1)
                    : null,
                icon: const Icon(Icons.chevron_right),
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color color = AppColors.neutral500;
    if (role == 'SUPER_ADMIN') color = AppColors.primary;
    if (role == 'EDITOR') color = AppColors.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        role.replaceAll('_', ' '),
        style: AppTextStyle.caption
            .copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = AppColors.neutral500;
    if (status == 'APPROVED') color = AppColors.success;
    if (status == 'PENDING') color = AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: AppTextStyle.caption
            .copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
