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
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<OwnersCubit>().getOwners();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
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
                          if (state.isFetchingMore)
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Owners Management', style: AppTextStyle.heading1),
            const SizedBox(height: 8),
            Text(
              'Manage and verify kiosk owners',
              style: AppTextStyle.bodyMedium,
            ),
          ],
        ),
        SizedBox(
          width: 300,
          child: TextField(
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
              context
                  .read<OwnersCubit>()
                  .getOwners(refresh: true, search: value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context, List<OwnerModel> owners) {
    return DataTable(
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
        DataColumn(
            label: Text('Actions',
                style: AppTextStyle.bodySmall
                    .copyWith(fontWeight: FontWeight.bold))),
      ],
      rows: owners.map((owner) {
        return DataRow(
          cells: [
            DataCell(
              Row(
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
            DataCell(
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OwnerDetailsPage(ownerId: owner.id),
                    ),
                  );
                },
                child: Text('View Details',
                    style: AppTextStyle.bodySmall
                        .copyWith(color: AppColors.primary)),
              ),
            ),
          ],
        );
      }).toList(),
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
