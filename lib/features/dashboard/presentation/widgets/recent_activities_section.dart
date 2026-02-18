import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/helper/app_text_style.dart';
import '../../domain/entities/dashboard_stats_entity.dart';

class RecentActivitiesSection extends StatelessWidget {
  final DashboardStatsEntity stats;

  const RecentActivitiesSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activities', style: AppTextStyle.heading2),
        const SizedBox(height: 16),
        if (isMobile)
          Column(
            children: [
              _buildSectionCard(
                  'Critical Alerts', stats.alerts, _buildAlertItem),
              const SizedBox(height: 16),
              _buildSectionCard(
                  'Recent Signups', stats.customerSignups, _buildSignupItem),
              const SizedBox(height: 16),
              _buildSectionCard(
                  'Overdue Dues', stats.overdueDues, _buildOverdueDueItem),
              const SizedBox(height: 16),
              _buildSectionCard('Pending Redemptions', stats.redemptionRequests,
                  _buildRedemptionItem),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildSectionCard(
                        'Critical Alerts', stats.alerts, _buildAlertItem),
                    const SizedBox(height: 16),
                    _buildSectionCard('Recent Signups', stats.customerSignups,
                        _buildSignupItem),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildSectionCard('Overdue Dues', stats.overdueDues,
                        _buildOverdueDueItem),
                    const SizedBox(height: 16),
                    _buildSectionCard('Pending Redemptions',
                        stats.redemptionRequests, _buildRedemptionItem),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildSectionCard<T>(
      String title, List<T> items, Widget Function(T) itemBuilder) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: AppTextStyle.bodySmall
                        .copyWith(fontWeight: FontWeight.bold)),
                if (items.isNotEmpty)
                  Text('${items.length} items',
                      style: AppTextStyle.caption
                          .copyWith(color: AppColors.neutral500)),
              ],
            ),
          ),
          const Divider(height: 1),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text('No recent $title', style: AppTextStyle.caption),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length > 5 ? 5 : items.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, indent: 20, endIndent: 20),
              itemBuilder: (context, index) => itemBuilder(items[index]),
            ),
          if (items.length > 5)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: TextButton(
                  onPressed: () {}, // Navigate to full list
                  child: Text('View All',
                      style: AppTextStyle.caption.copyWith(
                          color: AppColors.brandPrimary,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            )
          else
            const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildAlertItem(Alert alert) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            _getSeverityColor(alert.severity).withValues(alpha: 0.1),
        child: Icon(Icons.warning_amber_rounded,
            color: _getSeverityColor(alert.severity), size: 20),
      ),
      title: Text(alert.type,
          style: AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(alert.message,
              style: AppTextStyle.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Text(_formatDate(alert.createdAt),
              style: AppTextStyle.caption
                  .copyWith(fontSize: 10, color: AppColors.neutral400)),
        ],
      ),
      dense: true,
    );
  }

  Widget _buildSignupItem(CustomerSignupEntity signup) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.success.withValues(alpha: 0.1),
        child: const Icon(Icons.person_add_alt_1_rounded,
            color: AppColors.success, size: 20),
      ),
      title: Text(signup.fullName,
          style: AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(signup.phone, style: AppTextStyle.caption),
          Text(_formatDate(signup.createdAt),
              style: AppTextStyle.caption
                  .copyWith(fontSize: 10, color: AppColors.neutral400)),
        ],
      ),
      dense: true,
    );
  }

  Widget _buildOverdueDueItem(OverdueDueEntity due) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.error.withValues(alpha: 0.1),
        child: const Icon(Icons.money_off_csred_rounded,
            color: AppColors.error, size: 20),
      ),
      title: Text(due.kioskName,
          style: AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: AppTextStyle.caption,
              children: [
                const TextSpan(text: 'Owner: '),
                TextSpan(
                    text: due.ownerName,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text(_formatDate(due.createdAt),
              style: AppTextStyle.caption
                  .copyWith(fontSize: 10, color: AppColors.neutral400)),
        ],
      ),
      trailing: Text('${due.amount} PT',
          style: AppTextStyle.bodySmall
              .copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
      dense: true,
    );
  }

  Widget _buildRedemptionItem(RedemptionRequest redemption) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.warning.withValues(alpha: 0.1),
        child: const Icon(Icons.redeem_rounded,
            color: AppColors.warning, size: 20),
      ),
      title: Text(redemption.userName ?? 'Unknown User',
          style: AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Method: ${redemption.method}', style: AppTextStyle.caption),
          Text(_formatDate(redemption.createdAt),
              style: AppTextStyle.caption
                  .copyWith(fontSize: 10, color: AppColors.neutral400)),
        ],
      ),
      trailing: Text('${redemption.amount} PT',
          style: AppTextStyle.bodySmall.copyWith(
              color: AppColors.brandPrimary, fontWeight: FontWeight.bold)),
      dense: true,
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, h:mm a').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toUpperCase()) {
      case 'HIGH':
        return AppColors.error;
      case 'MEDIUM':
        return AppColors.warning;
      case 'LOW':
        return AppColors.success;
      default:
        return AppColors.neutral500;
    }
  }
}
