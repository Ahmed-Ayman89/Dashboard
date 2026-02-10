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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calls Management', style: AppTextStyle.heading1),
            const SizedBox(height: 32),
            Expanded(child: _buildCallsTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildCallsTable() {
    return BlocBuilder<CallsCubit, CallsState>(
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
                  onPressed: () => context.read<CallsCubit>().getCalls(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is CallsLoaded) {
          if (state.calls.isEmpty) {
            return Center(
                child: Text('No calls found', style: AppTextStyle.bodyRegular));
          }
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
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
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Number')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Admin')),
                      DataColumn(label: Text('Created At')),
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
                          DataCell(Text(call.number)),
                          DataCell(Text(DateFormat('MMM d, yyyy HH:mm')
                              .format(call.date))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: call.status == 'PENDING'
                                    ? AppColors.warning.withValues(alpha: 0.1)
                                    : AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                call.status,
                                style: AppTextStyle.caption.copyWith(
                                  color: call.status == 'PENDING'
                                      ? AppColors.warning
                                      : AppColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(call.admin?.fullName ?? '-')),
                          DataCell(Text(DateFormat('MMM d, yyyy')
                              .format(call.createdAt))),
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
}
