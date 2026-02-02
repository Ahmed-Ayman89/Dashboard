import 'package:flutter/material.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/dashboard/data/models/worker_model.dart';

class WorkersPage extends StatefulWidget {
  const WorkersPage({super.key});

  @override
  State<WorkersPage> createState() => _WorkersPageState();
}

class _WorkersPageState extends State<WorkersPage> {
  final List<WorkerModel> _dummyWorkers = [
    WorkerModel(
      id: '1',
      phone: '01098765432',
      kioskName: 'City Mall Kiosk',
      ownerName: 'Ahmed Mohamed',
      status: WorkerStatus.active,
      commissionEarned: 150.0,
      transactionsCompleted: 120,
    ),
    WorkerModel(
      id: '2',
      phone: '01155667788',
      kioskName: 'Downtown Kiosk',
      ownerName: 'Sara Ahmed',
      status: WorkerStatus.waiting,
      commissionEarned: 0.0,
      transactionsCompleted: 0,
    ),
    WorkerModel(
      id: '3',
      phone: '01211223344',
      kioskName: 'Green Plaza',
      ownerName: 'Mahmoud Ali',
      status: WorkerStatus.suspended,
      commissionEarned: 850.0,
      transactionsCompleted: 450,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Worker Management', style: AppTextStyle.heading1),
          const SizedBox(height: 32),
          _buildFilters(),
          const SizedBox(height: 24),
          Expanded(child: _buildWorkersTable()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search workers by phone or kiosk...',
          hintStyle: AppTextStyle.bodySmall,
          border: InputBorder.none,
          icon: const Icon(Icons.search_rounded, color: AppColors.neutral500),
        ),
      ),
    );
  }

  Widget _buildWorkersTable() {
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
                  DataColumn(label: Text('Kiosk')),
                  DataColumn(label: Text('Owner')),
                  DataColumn(label: Text('Commission')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _dummyWorkers.map((worker) {
                  return DataRow(cells: [
                    DataCell(Text(worker.phone,
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(worker.kioskName)),
                    DataCell(Text(worker.ownerName)),
                    DataCell(Text(
                        '${worker.commissionEarned.toStringAsFixed(0)} EGP')),
                    DataCell(_buildStatusBadge(worker.status)),
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
        ));
  }

  Widget _buildStatusBadge(WorkerStatus status) {
    Color color;
    String label;
    switch (status) {
      case WorkerStatus.active:
        color = AppColors.success;
        label = 'ACTIVE';
        break;
      case WorkerStatus.suspended:
        color = AppColors.error;
        label = 'SUSPENDED';
        break;
      case WorkerStatus.waiting:
        color = AppColors.warning;
        label = 'WAITING';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyle.caption
            .copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
