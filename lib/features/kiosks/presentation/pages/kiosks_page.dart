import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';

import '../../data/repositories/kiosks_repository_impl.dart';
import '../../domain/usecases/get_kiosks_usecase.dart';
import '../cubit/kiosks_cubit.dart';
import '../cubit/kiosks_state.dart';
import 'kiosk_details_page.dart';

class KiosksPage extends StatelessWidget {
  const KiosksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KiosksCubit(
        GetKiosksUseCase(KiosksRepositoryImpl()),
      )..getKiosks(),
      child: const _KiosksView(),
    );
  }
}

class _KiosksView extends StatelessWidget {
  const _KiosksView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kiosk Management', style: AppTextStyle.heading1),
          const SizedBox(height: 32),
          _buildFilters(),
          const SizedBox(height: 24),
          Expanded(child: _buildKiosksTable()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search kiosks...',
                hintStyle: AppTextStyle.bodySmall,
                border: InputBorder.none,
                icon: const Icon(Icons.search_rounded,
                    color: AppColors.neutral500),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildFilterChip(
            'High Dues', Icons.warning_amber_rounded, AppColors.error),
        const SizedBox(width: 12),
        _buildFilterChip(
            'Active', Icons.check_circle_outline_rounded, AppColors.success),
      ],
    );
  }

  Widget _buildFilterChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(label,
              style:
                  AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildKiosksTable() {
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
          child: BlocBuilder<KiosksCubit, KiosksState>(
            builder: (context, state) {
              if (state is KiosksLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is KiosksFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message,
                          style: const TextStyle(color: AppColors.error)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () =>
                            context.read<KiosksCubit>().getKiosks(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is KiosksSuccess) {
                if (state.kiosks.isEmpty) {
                  return const Center(child: Text('No kiosks found.'));
                }
                return SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      showCheckboxColumn: false,
                      headingRowColor:
                          WidgetStateProperty.all(AppColors.neutral100),
                      columns: const [
                        DataColumn(label: Text('Kiosk Name')),
                        DataColumn(label: Text('Owner')),
                        DataColumn(label: Text('Location')),
                        DataColumn(label: Text('Daily TX')),
                        DataColumn(label: Text('Dues')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: state.kiosks.map((kiosk) {
                        return DataRow(
                            onSelectChanged: (_) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      KioskDetailsPage(kioskId: kiosk.id),
                                ),
                              );
                            },
                            cells: [
                              DataCell(Text(kiosk.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))),
                              DataCell(Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(kiosk.owner.fullName),
                                  Text(kiosk.owner.phone,
                                      style: AppTextStyle.caption),
                                ],
                              )),
                              DataCell(Text(kiosk.location ?? 'N/A')),
                              DataCell(
                                  Text(kiosk.dailyTransactions.toString())),
                              DataCell(
                                Text(
                                  '${kiosk.pendingDues.toStringAsFixed(0)} EGP',
                                  style: TextStyle(
                                    color: kiosk.pendingDues > 1000
                                        ? AppColors.error
                                        : AppColors.textPrimary,
                                    fontWeight: kiosk.pendingDues > 1000
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              DataCell(_buildStatusBadge(!kiosk.isActive)),
                            ]);
                      }).toList(),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ));
  }

  Widget _buildStatusBadge(bool isSuspended) {
    final color = isSuspended ? AppColors.error : AppColors.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isSuspended ? 'SUSPENDED' : 'ACTIVE',
        style: AppTextStyle.caption
            .copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
