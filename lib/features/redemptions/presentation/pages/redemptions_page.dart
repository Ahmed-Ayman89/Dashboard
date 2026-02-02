import 'package:flutter/material.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/dashboard/data/models/redemption_model.dart';
import 'package:intl/intl.dart';

class RedemptionsPage extends StatefulWidget {
  const RedemptionsPage({super.key});

  @override
  State<RedemptionsPage> createState() => _RedemptionsPageState();
}

class _RedemptionsPageState extends State<RedemptionsPage> {
  final List<RedemptionModel> _dummyRedemptions = [
    RedemptionModel(
      id: 'RD8001',
      userType: UserType.owner,
      userName: 'Ahmed Mohamed',
      amount: 500.0,
      paymentMethod: 'Vodafone Cash',
      paymentDetails: '01012345678',
      requestedAt: DateTime.now().subtract(const Duration(hours: 4)),
      status: RedemptionStatus.pending,
    ),
    RedemptionModel(
      id: 'RD8002',
      userType: UserType.worker,
      userName: 'Sami Ali',
      amount: 150.0,
      paymentMethod: 'InstaPay',
      paymentDetails: 'sami@instapay',
      requestedAt: DateTime.now().subtract(const Duration(days: 1)),
      status: RedemptionStatus.approved,
    ),
    RedemptionModel(
      id: 'RD8003',
      userType: UserType.customer,
      userName: 'Mona Zein',
      amount: 50.0,
      paymentMethod: 'Bank Transfer',
      paymentDetails: 'Account: 12345678',
      requestedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      status: RedemptionStatus.rejected,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Redemption Requests', style: AppTextStyle.heading1),
          const SizedBox(height: 32),
          _buildSummaryCards(),
          const SizedBox(height: 32),
          Expanded(child: _buildRedemptionsQueue()),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return Column(
            children: [
              _buildMiniCard('Pending', '15', AppColors.warning),
              const SizedBox(height: 16),
              _buildMiniCard(
                  'Total Today', '1,250 EGP', AppColors.brandPrimary),
              const SizedBox(height: 16),
              _buildMiniCard('Processed', '42', AppColors.success),
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: _buildMiniCard('Pending', '15', AppColors.warning)),
            const SizedBox(width: 24),
            Expanded(
                child: _buildMiniCard(
                    'Total Today', '1,250 EGP', AppColors.brandPrimary)),
            const SizedBox(width: 24),
            Expanded(
                child: _buildMiniCard('Processed', '42', AppColors.success)),
          ],
        );
      },
    );
  }

  Widget _buildMiniCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyle.bodySmall),
                const SizedBox(height: 8),
                Text(value,
                    style: AppTextStyle.heading3.copyWith(color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedemptionsQueue() {
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
                  DataColumn(label: Text('User')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Method')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Action')),
                ],
                rows: _dummyRedemptions.map((red) {
                  return DataRow(cells: [
                    DataCell(Text(red.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(red.userType.name.toUpperCase())),
                    DataCell(Text('${red.amount.toStringAsFixed(0)} EGP')),
                    DataCell(Text(red.paymentMethod)),
                    DataCell(Text(
                        DateFormat('MMM dd, HH:mm').format(red.requestedAt))),
                    DataCell(_buildStatusBadge(red.status)),
                    DataCell(
                      red.status == RedemptionStatus.pending
                          ? Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check_circle_rounded,
                                      color: AppColors.success),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel_rounded,
                                      color: AppColors.error),
                                  onPressed: () {},
                                ),
                              ],
                            )
                          : const Text('-'),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ));
  }

  Widget _buildStatusBadge(RedemptionStatus status) {
    Color color;
    switch (status) {
      case RedemptionStatus.pending:
        color = AppColors.warning;
        break;
      case RedemptionStatus.approved:
        color = AppColors.success;
        break;
      case RedemptionStatus.rejected:
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
