import 'package:flutter/material.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/dashboard/data/models/owner_model.dart';
import 'package:intl/intl.dart';

class OwnersPage extends StatefulWidget {
  const OwnersPage({super.key});

  @override
  State<OwnersPage> createState() => _OwnersPageState();
}

class _OwnersPageState extends State<OwnersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<OwnerModel> _dummyOwners = [
    OwnerModel(
      id: '1',
      name: 'Ahmed Mohamed',
      phone: '01012345678',
      status: OwnerStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      balance: 1500.0,
      totalKiosks: 2,
    ),
    OwnerModel(
      id: '2',
      name: 'Sara Ahmed',
      phone: '01123456789',
      status: OwnerStatus.approved,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      balance: 4500.0,
      totalKiosks: 4,
    ),
    OwnerModel(
      id: '3',
      name: 'Mahmoud Ali',
      phone: '01234567890',
      status: OwnerStatus.suspended,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      balance: 0.0,
      totalKiosks: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Owner Management', style: AppTextStyle.heading1),
              _buildAddOwnerButton(),
            ],
          ),
          const SizedBox(height: 32),
          _buildSearchAndFilters(),
          const SizedBox(height: 24),
          _buildTabs(),
          const SizedBox(height: 24),
          Expanded(child: _buildOwnersTable()),
        ],
      ),
    );
  }

  Widget _buildAddOwnerButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add_rounded, color: AppColors.white),
      label: Text('Invite New Owner', style: AppTextStyle.button),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by name, phone or ID...',
          hintStyle: AppTextStyle.bodySmall,
          border: InputBorder.none,
          icon: const Icon(Icons.search_rounded, color: AppColors.neutral500),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: AppColors.brandPrimary,
      unselectedLabelColor: AppColors.neutral600,
      indicatorColor: AppColors.brandPrimary,
      indicatorWeight: 3,
      labelStyle: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
      tabs: const [
        Tab(text: 'Pending'),
        Tab(text: 'Approved'),
        Tab(text: 'Suspended'),
        Tab(text: 'Freezed'),
        Tab(text: 'Rejected'),
      ],
    );
  }

  Widget _buildOwnersTable() {
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
              DataColumn(label: Text('Owner Info')),
              DataColumn(label: Text('Kiosks')),
              DataColumn(label: Text('Balance')),
              DataColumn(label: Text('Joined Date')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: _dummyOwners.map((owner) {
              return DataRow(cells: [
                DataCell(
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            AppColors.brandPrimary.withValues(alpha: 0.1),
                        child: Text(owner.name[0],
                            style: TextStyle(
                                color: AppColors.brandPrimary,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(owner.name,
                              style: AppTextStyle.bodySmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary)),
                          Text(owner.phone, style: AppTextStyle.caption),
                        ],
                      ),
                    ],
                  ),
                ),
                DataCell(Text(owner.totalKiosks.toString())),
                DataCell(Text('${owner.balance.toStringAsFixed(0)} EGP')),
                DataCell(
                    Text(DateFormat('MMM dd, yyyy').format(owner.createdAt))),
                DataCell(_buildStatusBadge(owner.status)),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.more_horiz_rounded),
                    onPressed: () {},
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OwnerStatus status) {
    Color color;
    switch (status) {
      case OwnerStatus.approved:
        color = AppColors.success;
        break;
      case OwnerStatus.pending:
        color = AppColors.warning;
        break;
      case OwnerStatus.suspended:
      case OwnerStatus.freezed:
        color = AppColors.error;
        break;
      case OwnerStatus.rejected:
        color = AppColors.neutral600;
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
