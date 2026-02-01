import 'package:flutter/material.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/dashboard/data/models/audit_log_model.dart';

class AuditLogPage extends StatelessWidget {
  const AuditLogPage({super.key});

  static final List<AuditLogModel> _dummyLogs = [
    AuditLogModel(
      id: 'L001',
      adminName: 'Super Admin',
      action: 'Approved Redemption',
      target: 'RD8001 (Ahmed Mohamed)',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    AuditLogModel(
      id: 'L002',
      adminName: 'Admin Sarah',
      action: 'Suspended Kiosk',
      target: 'Downtown Kiosk',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AuditLogModel(
      id: 'L003',
      adminName: 'Super Admin',
      action: 'Changed Settings',
      target: 'Commission Amount',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Audit Log', style: AppTextStyle.heading1),
          const SizedBox(height: 8),
          Text(
              'Track every administrative action for security and accountability.',
              style: AppTextStyle.bodyMedium),
          const SizedBox(height: 32),
          Expanded(
            child: Container(
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
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _dummyLogs.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final log = _dummyLogs[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.neutral100,
                      child: const Icon(Icons.history_rounded,
                          color: AppColors.neutral600),
                    ),
                    title: Row(
                      children: [
                        Text(log.adminName,
                            style: AppTextStyle.bodySmall
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text('performed', style: AppTextStyle.bodySmall),
                        const SizedBox(width: 8),
                        Text(log.action,
                            style: AppTextStyle.bodySmall.copyWith(
                                color: AppColors.brandPrimary,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    subtitle: Text(
                        'Target: ${log.target} • ${index + 1} hours ago',
                        style: AppTextStyle.caption),
                    trailing: const Icon(Icons.info_outline_rounded,
                        size: 18, color: AppColors.neutral400),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Note: Using a slightly different model in the UI for simplicity in dummy data display.
extension on AuditLogModel {
  // Add some logic if needed
}
