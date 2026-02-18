import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/helper/role_helper.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/calls/data/repositories/calls_repository_impl.dart';
import 'package:dashboard_grow/features/calls/domain/usecases/get_call_details_usecase.dart';
import 'package:dashboard_grow/features/calls/domain/usecases/update_call_status_usecase.dart';
import 'package:dashboard_grow/features/calls/presentation/cubit/call_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CallDetailsPage extends StatelessWidget {
  final String callId;

  const CallDetailsPage({super.key, required this.callId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = CallsRepositoryImpl();
        return CallDetailsCubit(
          GetCallDetailsUseCase(repository),
          updateCallStatusUseCase: UpdateCallStatusUseCase(repository),
        )..getCallDetails(callId);
      },
      child: const _CallDetailsView(),
    );
  }
}

class _CallDetailsView extends StatelessWidget {
  const _CallDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        title: const Text('Call Details'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: BlocBuilder<CallDetailsCubit, CallDetailsState>(
        builder: (context, state) {
          if (state is CallDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CallDetailsFailure) {
            return Center(child: Text(state.message));
          } else if (state is CallDetailsLoaded) {
            final call = state.call;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Call Information'),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    children: [
                      _buildInfoRow('Call ID', call.id),
                      _buildInfoRow('Number', call.number),
                      _buildInfoRow('Date',
                          DateFormat('MMM d, yyyy HH:mm').format(call.date)),
                      _buildInfoRow('Status', call.status),
                      _buildInfoRow('Created At',
                          DateFormat('MMM d, yyyy').format(call.createdAt)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('User Information'),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    children: [
                      _buildInfoRow('User Name', call.user?.fullName ?? '-'),
                      _buildInfoRow('User Phone', call.user?.phone ?? '-'),
                      _buildInfoRow('User ID', call.userId),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const SizedBox(height: 32),
                  if (call.admin != null) ...[
                    _buildSectionTitle('Admin Information'),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      children: [
                        _buildInfoRow(
                            'Admin Name', call.admin?.fullName ?? '-'),
                        _buildInfoRow('Admin ID', call.adminId ?? '-'),
                      ],
                    ),
                  ],
                  const SizedBox(height: 32),
                  if (call.status == 'PENDING') ...[
                    FutureBuilder<bool>(
                      future: RoleHelper.canTakeActions(),
                      builder: (context, snapshot) {
                        if (snapshot.data != true)
                          return const SizedBox.shrink();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Actions'),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<CallDetailsCubit>()
                                          .updateStatus(call.id, 'RESOLVED');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.success,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Mark as Resolved',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<CallDetailsCubit>()
                                          .updateStatus(call.id, 'REJECTED');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.error,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Reject Call',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyle.heading3,
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColors.neutral500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: AppTextStyle.bodyRegular.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
