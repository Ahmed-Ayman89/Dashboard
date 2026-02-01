import 'package:flutter/material.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/dashboard/data/models/kiosk_model.dart';

class KiosksPage extends StatefulWidget {
  const KiosksPage({super.key});

  @override
  State<KiosksPage> createState() => _KiosksPageState();
}

class _KiosksPageState extends State<KiosksPage> {
  final List<KioskModel> _dummyKiosks = [
    KioskModel(
      id: '1',
      name: 'City Mall Kiosk',
      location: 'Cairo, Egypt',
      ownerName: 'Ahmed Mohamed',
      dues: 1200.0,
      dailyTransactions: 45,
    ),
    KioskModel(
      id: '2',
      name: 'Downtown Kiosk',
      location: 'Alexandria, Egypt',
      ownerName: 'Sara Ahmed',
      dues: 300.0,
      dailyTransactions: 12,
      isSuspended: true,
    ),
    KioskModel(
      id: '3',
      name: 'Green Plaza',
      location: 'Giza, Egypt',
      ownerName: 'Mahmoud Ali',
      dues: 0.0,
      dailyTransactions: 89,
    ),
  ];

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
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.neutral100),
            columns: const [
              DataColumn(label: Text('Kiosk Name')),
              DataColumn(label: Text('Owner')),
              DataColumn(label: Text('Location')),
              DataColumn(label: Text('Daily TX')),
              DataColumn(label: Text('Dues')),
              DataColumn(label: Text('Status')),
            ],
            rows: _dummyKiosks.map((kiosk) {
              return DataRow(cells: [
                DataCell(Text(kiosk.name,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(kiosk.ownerName)),
                DataCell(Text(kiosk.location)),
                DataCell(Text(kiosk.dailyTransactions.toString())),
                DataCell(
                  Text(
                    '${kiosk.dues.toStringAsFixed(0)} EGP',
                    style: TextStyle(
                      color: kiosk.dues > 1000
                          ? AppColors.error
                          : AppColors.textPrimary,
                      fontWeight: kiosk.dues > 1000
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                DataCell(_buildStatusBadge(kiosk.isSuspended)),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
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
