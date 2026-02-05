import 'package:dashboard_grow/features/workers/presentation/cubit/workers_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/workers/data/repositories/workers_repository_impl.dart';
import 'package:dashboard_grow/features/workers/domain/usecases/get_workers_usecase.dart';
import 'package:dashboard_grow/features/workers/presentation/cubit/workers_cubit.dart';
import 'package:dashboard_grow/features/workers/presentation/pages/worker_details_page.dart';
import 'package:intl/intl.dart';

class WorkersPage extends StatelessWidget {
  const WorkersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = WorkersRepositoryImpl();
        return WorkersCubit(GetWorkersUseCase(repository))..getWorkers();
      },
      child: const _WorkersView(),
    );
  }
}

class _WorkersView extends StatefulWidget {
  const _WorkersView();

  @override
  State<_WorkersView> createState() => _WorkersViewState();
}

class _WorkersViewState extends State<_WorkersView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Worker Management', style: AppTextStyle.heading1),
            const SizedBox(height: 32),
            _buildFilters(context),
            const SizedBox(height: 24),
            Expanded(child: _buildWorkersTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: (value) {
          context.read<WorkersCubit>().searchWorkers(value);
        },
        decoration: InputDecoration(
          hintText: 'Search workers by name or phone...',
          hintStyle: AppTextStyle.bodySmall,
          border: InputBorder.none,
          icon: const Icon(Icons.search_rounded, color: AppColors.neutral500),
          suffixIcon: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _searchController.clear();
              context.read<WorkersCubit>().getWorkers();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWorkersTable() {
    return BlocBuilder<WorkersCubit, WorkersState>(
      builder: (context, state) {
        if (state is WorkersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WorkersFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message,
                    style: AppTextStyle.bodyRegular
                        .copyWith(color: AppColors.error)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<WorkersCubit>().getWorkers(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is WorkersLoaded) {
          if (state.workers.isEmpty) {
            return Center(
                child:
                    Text('No workers found', style: AppTextStyle.bodyRegular));
          }
          return Container(
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: false,
                    headingRowColor:
                        WidgetStateProperty.all(AppColors.neutral100),
                    columns: const [
                      DataColumn(label: Text('Worker Info')),
                      DataColumn(label: Text('Kiosks')),
                      DataColumn(label: Text('Commission')),
                      DataColumn(label: Text('Transactions')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Joined Date')),
                    ],
                    rows: state.workers.map((worker) {
                      return DataRow(
                        onSelectChanged: (selected) {
                          if (selected == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WorkerDetailsPage(workerId: worker.id),
                              ),
                            );
                          }
                        },
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor:
                                      AppColors.primary.withOpacity(0.1),
                                  child: Text(
                                      worker.fullName.isNotEmpty
                                          ? worker.fullName[0]
                                          : '?',
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(worker.fullName,
                                        style: AppTextStyle.bodySmall.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary)),
                                    Text(worker.phone,
                                        style: AppTextStyle.caption),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          DataCell(Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: worker.kiosks
                                .map((k) =>
                                    Text(k.name, style: AppTextStyle.caption))
                                .toList(),
                          )),
                          DataCell(Text('${worker.commissionEarned} EGP')),
                          DataCell(Text(worker.transactionsCount.toString())),
                          DataCell(_buildStatusBadge(worker.isActive)),
                          DataCell(Text(DateFormat('MMM d, yyyy')
                              .format(worker.createdAt))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
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
