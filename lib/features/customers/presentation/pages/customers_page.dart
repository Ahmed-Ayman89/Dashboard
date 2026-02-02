import 'package:flutter/material.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/dashboard/data/models/customer_model.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final List<CustomerModel> _dummyCustomers = [
    CustomerModel(
      id: '1',
      phone: '01011223344',
      balance: 1250.0,
      pointsReceived: 5000,
      redemptionsCount: 3,
      appDownloaded: true,
      kiosksInteractedCount: 5,
    ),
    CustomerModel(
      id: '2',
      phone: '01199887766',
      balance: 150.0,
      pointsReceived: 200,
      redemptionsCount: 0,
      appDownloaded: false,
      kiosksInteractedCount: 1,
    ),
    CustomerModel(
      id: '3',
      phone: '01233445566',
      balance: 0.0,
      pointsReceived: 100,
      redemptionsCount: 0,
      appDownloaded: true,
      kiosksInteractedCount: 2,
      isSuspended: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customer Management', style: AppTextStyle.heading1),
          const SizedBox(height: 32),
          _buildSearch(),
          const SizedBox(height: 24),
          Expanded(child: _buildCustomersTable()),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search customers by phone...',
          hintStyle: AppTextStyle.bodySmall,
          border: InputBorder.none,
          icon: const Icon(Icons.search_rounded, color: AppColors.neutral500),
        ),
      ),
    );
  }

  Widget _buildCustomersTable() {
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
                headingRowColor: WidgetStateProperty.all(AppColors.neutral100),
                columns: const [
                  DataColumn(label: Text('Phone Number')),
                  DataColumn(label: Text('Balance')),
                  DataColumn(label: Text('Points Received')),
                  DataColumn(label: Text('App Status')),
                  DataColumn(label: Text('Kiosks')),
                  DataColumn(label: Text('Status')),
                ],
                rows: _dummyCustomers.map((customer) {
                  return DataRow(cells: [
                    DataCell(Text(customer.phone,
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(
                        Text('${customer.balance.toStringAsFixed(0)} EGP')),
                    DataCell(Text(customer.pointsReceived.toString())),
                    DataCell(_buildAppStatus(customer.appDownloaded)),
                    DataCell(Text(customer.kiosksInteractedCount.toString())),
                    DataCell(_buildStatusBadge(customer.isSuspended)),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ));
  }

  Widget _buildAppStatus(bool downloaded) {
    return Row(
      children: [
        Icon(
          downloaded ? Icons.check_circle_rounded : Icons.cancel_rounded,
          size: 16,
          color: downloaded ? AppColors.success : AppColors.neutral400,
        ),
        const SizedBox(width: 8),
        Text(downloaded ? 'Downloaded' : 'Not yet',
            style: AppTextStyle.bodySmall),
      ],
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
        isSuspended ? 'BANNED' : 'ACTIVE',
        style: AppTextStyle.caption
            .copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
