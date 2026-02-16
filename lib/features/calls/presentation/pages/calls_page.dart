import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/calls/data/repositories/calls_repository_impl.dart';
import 'package:dashboard_grow/features/calls/domain/usecases/get_calls_usecase.dart';
import 'package:dashboard_grow/features/calls/presentation/cubit/calls_cubit.dart';
import 'package:dashboard_grow/features/calls/presentation/pages/call_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CallsPage extends StatelessWidget {
  const CallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = CallsRepositoryImpl();
        return CallsCubit(GetCallsUseCase(repository))..getCalls();
      },
      child: const _CallsView(),
    );
  }
}

class _CallsView extends StatefulWidget {
  const _CallsView();

  @override
  State<_CallsView> createState() => _CallsViewState();
}

class _CallsViewState extends State<_CallsView> {
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
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
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
                child: BlocBuilder<CallsCubit, CallsState>(
                  builder: (context, state) {
                    if (state is CallsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CallsFailure) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message,
                                style: AppTextStyle.bodyRegular
                                    .copyWith(color: AppColors.error)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<CallsCubit>().getCalls(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is CallsLoaded) {
                      return Column(
                        children: [
                          Expanded(child: _buildCallsTable(context, state)),
                          _buildPagination(context, state),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Calls Management', style: AppTextStyle.heading1),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search calls...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
                onSubmitted: (value) {
                  context.read<CallsCubit>().updateFilters(search: value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildFilterChips(context),
      ],
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(context, 'All', null),
          const SizedBox(width: 12),
          _buildFilterChip(context, 'PENDING', AppColors.warning),
          const SizedBox(width: 12),
          _buildFilterChip(context, 'RESOLVED', AppColors.success),
          const SizedBox(width: 12),
          _buildFilterChip(context, 'REJECTED', AppColors.error),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, Color? color) {
    return InkWell(
      onTap: () {
        context
            .read<CallsCubit>()
            .updateFilters(status: label == 'All' ? null : label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.neutral200),
        ),
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
  }

  Widget _buildCallsTable(BuildContext context, CallsLoaded state) {
    if (state.calls.isEmpty) {
      return Center(
          child: Text('No calls found', style: AppTextStyle.bodyRegular));
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  showCheckboxColumn: false,
                  headingRowColor:
                      WidgetStateProperty.all(AppColors.neutral100),
                  columns: [
                    DataColumn(
                        label: Text('Customer', style: AppTextStyle.caption)),
                    DataColumn(
                        label: Text('Number', style: AppTextStyle.caption)),
                    DataColumn(
                        label: Text('Date', style: AppTextStyle.caption)),
                    DataColumn(
                        label: Text('Status', style: AppTextStyle.caption)),
                    DataColumn(
                        label: Text('Admin', style: AppTextStyle.caption)),
                    DataColumn(
                        label: Text('Created At', style: AppTextStyle.caption)),
                  ],
                  rows: state.calls.map((call) {
                    return DataRow(
                      onSelectChanged: (selected) {
                        if (selected == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CallDetailsPage(callId: call.id),
                            ),
                          );
                        }
                      },
                      cells: [
                        DataCell(
                          Text(
                            call.user?.fullName ?? 'Unknown',
                            style: AppTextStyle.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        DataCell(
                            Text(call.number, style: AppTextStyle.bodySmall)),
                        DataCell(Text(
                            DateFormat('MMM d, yyyy HH:mm').format(call.date),
                            style: AppTextStyle.bodySmall)),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color:
                                  _getStatusColor(call.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              call.status.toUpperCase(),
                              style: AppTextStyle.caption.copyWith(
                                color: _getStatusColor(call.status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text(call.admin?.fullName ?? '-',
                            style: AppTextStyle.bodySmall)),
                        DataCell(Text(
                            DateFormat('MMM d, yyyy').format(call.createdAt),
                            style: AppTextStyle.bodySmall)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return AppColors.warning;
      case 'RESOLVED':
        return AppColors.success;
      case 'REJECTED':
        return AppColors.error;
      default:
        return AppColors.neutral600;
    }
  }

  Widget _buildPagination(BuildContext context, CallsLoaded state) {
    if (state.total == 0) return const SizedBox.shrink();
    final totalPages = (state.total / state.limit).ceil();
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${(state.page - 1) * state.limit + 1} to ${state.page * state.limit > state.total ? state.total : state.page * state.limit} of ${state.total} calls',
            style: AppTextStyle.caption,
          ),
          Row(
            children: [
              IconButton(
                onPressed: state.page > 1
                    ? () =>
                        context.read<CallsCubit>().changePage(state.page - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
              ),
              const SizedBox(width: 8),
              Text('Page ${state.page} of $totalPages',
                  style: AppTextStyle.bodySmall),
              const SizedBox(width: 8),
              IconButton(
                onPressed: state.page < totalPages
                    ? () =>
                        context.read<CallsCubit>().changePage(state.page + 1)
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
