import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/owners/data/models/owner_model.dart';
import 'package:dashboard_grow/features/owners/data/repositories/owners_repository_impl.dart';
import 'package:dashboard_grow/features/owners/domain/usecases/get_owners_usecase.dart';
import 'package:dashboard_grow/features/owners/presentation/cubit/owners_cubit.dart';
import 'package:dashboard_grow/features/owners/presentation/pages/owner_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OwnersPage extends StatelessWidget {
  const OwnersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OwnersCubit(
        GetOwnersUseCase(OwnersRepositoryImpl()),
      )..getOwners(),
      child: const _OwnersView(),
    );
  }
}

class _OwnersView extends StatefulWidget {
  const _OwnersView();

  @override
  State<_OwnersView> createState() => _OwnersViewState();
}

class _OwnersViewState extends State<_OwnersView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              Container(
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
                child: BlocBuilder<OwnersCubit, OwnersState>(
                  builder: (context, state) {
                    if (state is OwnersLoading && state is! OwnersLoaded) {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ));
                    } else if (state is OwnersFailure) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(state.message,
                              style: AppTextStyle.bodyRegular
                                  .copyWith(color: AppColors.error)),
                        ),
                      );
                    } else if (state is OwnersLoaded) {
                      if (state.owners.isEmpty) {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('No owners found.'),
                        ));
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTable(context, state.owners),
                          _buildPagination(context, state),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        final searchField = TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search owners...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
          onSubmitted: (value) {
            context.read<OwnersCubit>().getOwners(page: 1, search: value);
          },
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isWide)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Owners Management', style: AppTextStyle.heading1),
                        const SizedBox(height: 8),
                        Text('Manage and verify kiosk owners',
                            style: AppTextStyle.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(width: 300, child: searchField),
                ],
              )
            else ...[
              Text('Owners Management', style: AppTextStyle.heading1),
              const SizedBox(height: 4),
              Text('Manage and verify kiosk owners',
                  style: AppTextStyle.bodyMedium),
              const SizedBox(height: 16),
              searchField,
            ],
            const SizedBox(height: 24),
            _buildFilterChips(context),
          ],
        );
      },
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(context, 'All', null),
          const SizedBox(width: 12),
          _buildFilterChip(context, 'Pending', AppColors.warning),
          const SizedBox(width: 12),
          _buildFilterChip(
              context,
              'Active',
              AppColors
                  .success), // Mapped to APPROVED in logic usually, handled by backend
          const SizedBox(width: 12),
          _buildFilterChip(context, 'Suspended', AppColors.error),
        ],
      ),
    );
  }

  Widget _buildPagination(BuildContext context, OwnersLoaded state) {
    final totalPages = (state.total / state.limit).ceil();
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'Showing ${(state.page - 1) * state.limit + 1} to ${state.page * state.limit > state.total ? state.total : state.page * state.limit} of ${state.total} owners',
              style: AppTextStyle.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: state.page > 1
                    ? () => context.read<OwnersCubit>().getOwners(
                          page: state.page - 1,
                          limit: state.limit,
                        )
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
                    ? () => context.read<OwnersCubit>().getOwners(
                          page: state.page + 1,
                          limit: state.limit,
                        )
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

  Widget _buildFilterChip(BuildContext context, String label, Color? color) {
    return BlocBuilder<OwnersCubit, OwnersState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            String status = label;
            if (label == 'Active') status = 'APPROVED';

            context.read<OwnersCubit>().getOwners(page: 1, status: status);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]),
            child: Row(
              children: [
                if (color != null) ...[
                  Icon(Icons.circle, size: 8, color: color),
                  const SizedBox(width: 8),
                ],
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

  Widget _buildTable(BuildContext context, List<OwnerModel> owners) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width -
              64, // Accounts for page padding
        ),
        child: DataTable(
          showCheckboxColumn: false,
          headingRowColor:
              WidgetStateProperty.all(AppColors.neutral100.withOpacity(0.5)),
          dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.hovered)) {
              return AppColors.primary.withOpacity(0.05);
            }
            return null; // Use default
          }),
          horizontalMargin: 24,
          columnSpacing: 24,
          dividerThickness: 0, // Cleaner look
          columns: [
            DataColumn(
                label: Text('Owner Info',
                    style: AppTextStyle.bodySmall
                        .copyWith(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Status',
                    style: AppTextStyle.bodySmall
                        .copyWith(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Joined Date',
                    style: AppTextStyle.bodySmall
                        .copyWith(fontWeight: FontWeight.bold))),
          ],
          rows: owners.map((owner) {
            return DataRow(
              onSelectChanged: (_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OwnerDetailsPage(ownerId: owner.id),
                  ),
                );
              },
              cells: [
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          owner.fullName.isNotEmpty ? owner.fullName[0] : '?',
                          style: AppTextStyle.bodySmall
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(owner.fullName,
                              style: AppTextStyle.bodyMedium
                                  .copyWith(fontWeight: FontWeight.bold)),
                          Text(owner.phone, style: AppTextStyle.caption),
                        ],
                      ),
                    ],
                  ),
                ),
                DataCell(_buildStatusBadge(owner.status)),
                DataCell(Text(DateFormat('MMM d, yyyy').format(owner.createdAt),
                    style: AppTextStyle.bodySmall)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;
    String label = status;

    switch (status.toUpperCase()) {
      case 'APPROVED':
        bg = AppColors.success.withOpacity(0.1);
        fg = AppColors.success;
        label = 'Active';
        break;
      case 'PENDING':
        bg = AppColors.warning.withOpacity(0.1);
        fg = AppColors.warning;
        break;
      case 'SUSPENDED':
      case 'REJECTED':
        bg = AppColors.error.withOpacity(0.1);
        fg = AppColors.error;
        break;
      default:
        bg = AppColors.neutral100;
        fg = AppColors.neutral600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyle.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
