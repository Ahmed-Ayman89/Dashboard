import 'package:flutter/material.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/dashboard/data/models/dues_model.dart';
//

class DuesPage extends StatefulWidget {
  const DuesPage({super.key});

  @override
  State<DuesPage> createState() => _DuesPageState();
}

class _DuesPageState extends State<DuesPage> {
  final List<DuesModel> _dummyDues = [
    DuesModel(
      kioskId: 'K1',
      kioskName: 'City Mall Kiosk',
      ownerName: 'Ahmed Mohamed',
      totalDues: 5000.0,
      paidAmount: 3800.0,
      lastPaymentDate: DateTime.now().subtract(const Duration(days: 2)),
      daysSinceLastPayment: 2,
    ),
    DuesModel(
      kioskId: 'K2',
      kioskName: 'Downtown Kiosk',
      ownerName: 'Sara Ahmed',
      totalDues: 2500.0,
      paidAmount: 500.0, // Outstanding 2000 -> High Risk
      lastPaymentDate: DateTime.now().subtract(const Duration(days: 12)),
      daysSinceLastPayment: 12,
    ),
    DuesModel(
      kioskId: 'K3',
      kioskName: 'Green Plaza',
      ownerName: 'Mahmoud Ali',
      totalDues: 800.0,
      paidAmount: 800.0,
      lastPaymentDate: DateTime.now().subtract(const Duration(days: 5)),
      daysSinceLastPayment: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dues Management', style: AppTextStyle.heading1),
          const SizedBox(height: 32),
          _buildDuesOverview(),
          const SizedBox(height: 32),
          Text('Kiosk Dues Details', style: AppTextStyle.heading2),
          const SizedBox(height: 16),
          _buildDuesTable(),
        ],
      ),
    );
  }

  Widget _buildDuesOverview() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return Column(
            children: [
              _buildSummaryBox(
                  'Total Outstanding', '32,500 EGP', AppColors.brandPrimary),
              const SizedBox(height: 16),
              _buildSummaryBox('High Risk Kiosks', '5', AppColors.error),
              const SizedBox(height: 16),
              _buildSummaryBox(
                  'Collected Today', '4,200 EGP', AppColors.success),
            ],
          );
        }
        return Row(
          children: [
            Expanded(
              child: _buildSummaryBox(
                  'Total Outstanding', '32,500 EGP', AppColors.brandPrimary),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildSummaryBox('High Risk Kiosks', '5', AppColors.error),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildSummaryBox(
                  'Collected Today', '4,200 EGP', AppColors.success),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryBox(String label, String value, Color color) {
    return Container(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyle.bodySmall),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyle.heading2.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildDuesTable() {
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
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.neutral100),
              columns: const [
                DataColumn(label: Text('Kiosk')),
                DataColumn(label: Text('Owner')),
                DataColumn(label: Text('Total Created')),
                DataColumn(label: Text('Paid')),
                DataColumn(label: Text('Outstanding')),
                DataColumn(label: Text('Last Payment')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _dummyDues.map((due) {
                return DataRow(cells: [
                  DataCell(
                    Text(
                      due.kioskName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: due.isHighRisk
                            ? AppColors.error
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  DataCell(Text(due.ownerName)),
                  DataCell(Text('${due.totalDues.toStringAsFixed(0)} EGP')),
                  DataCell(Text('${due.paidAmount.toStringAsFixed(0)} EGP')),
                  DataCell(
                    Text(
                      '${due.outstanding.toStringAsFixed(0)} EGP',
                      style: TextStyle(
                        fontWeight: due.isHighRisk
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: due.isHighRisk
                            ? AppColors.error
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  DataCell(Text('${due.daysSinceLastPayment} days ago')),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.brandPrimary.withOpacity(0.1),
                        foregroundColor: AppColors.brandPrimary,
                        elevation: 0,
                      ),
                      child: const Text('Update'),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ));
  }
}
