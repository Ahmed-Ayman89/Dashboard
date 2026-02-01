import 'package:flutter/material.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/dashboard/data/models/transaction_model.dart';
//

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final List<TransactionModel> _dummyTransactions = [
    TransactionModel(
      id: 'TX1001',
      senderName: 'Ahmed (Worker)',
      kioskName: 'City Mall',
      customerPhone: '01011223344',
      points: 500,
      commission: 5.0,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      status: TransactionStatus.completed,
    ),
    TransactionModel(
      id: 'TX1002',
      senderName: 'Sara (Owner)',
      kioskName: 'Downtown',
      customerPhone: '01122334455',
      points: 2500,
      commission: 5.0,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      status: TransactionStatus.flagged,
    ),
    TransactionModel(
      id: 'TX1003',
      senderName: 'Ali (Worker)',
      kioskName: 'Green Plaza',
      customerPhone: '01211223344',
      points: 100,
      commission: 5.0,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      status: TransactionStatus.completed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transaction Center', style: AppTextStyle.heading1),
          const SizedBox(height: 32),
          _buildFilters(),
          const SizedBox(height: 24),
          Expanded(child: _buildTransactionsTable()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          _buildFilterItem('Date Range', Icons.calendar_today_rounded),
          const VerticalDivider(width: 32),
          _buildFilterItem('Kiosk', Icons.store_rounded),
          const VerticalDivider(width: 32),
          _buildFilterItem('Status', Icons.filter_list_rounded),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded, size: 18),
            label: const Text('Export CSV'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neutral100,
              foregroundColor: AppColors.neutral800,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.neutral600),
        const SizedBox(width: 8),
        Text(label,
            style:
                AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(width: 4),
        const Icon(Icons.keyboard_arrow_down_rounded,
            size: 18, color: AppColors.neutral500),
      ],
    );
  }

  Widget _buildTransactionsTable() {
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
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Sender')),
              DataColumn(label: Text('Kiosk')),
              DataColumn(label: Text('Customer')),
              DataColumn(label: Text('Points')),
              DataColumn(label: Text('Status')),
            ],
            rows: _dummyTransactions.map((tx) {
              return DataRow(cells: [
                DataCell(Text(tx.id,
                    style: AppTextStyle.caption
                        .copyWith(fontWeight: FontWeight.bold))),
                DataCell(Text(tx.senderName)),
                DataCell(Text(tx.kioskName)),
                DataCell(Text(tx.customerPhone)),
                DataCell(Text(tx.points.toString())),
                DataCell(_buildStatusBadge(tx.status)),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TransactionStatus status) {
    Color color;
    switch (status) {
      case TransactionStatus.completed:
        color = AppColors.success;
        break;
      case TransactionStatus.flagged:
        color = AppColors.warning;
        break;
      case TransactionStatus.failed:
        color = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: AppTextStyle.caption
            .copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
