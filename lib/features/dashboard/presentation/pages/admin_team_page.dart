import 'package:flutter/material.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import '../../../admin_team/presentation/widgets/invite_admin_dialog.dart';

class AdminTeamPage extends StatelessWidget {
  const AdminTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Admin Team Management', style: AppTextStyle.heading1),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const InviteAdminDialog(),
                        );
                      },
                      icon: const Icon(Icons.mail_outline_rounded,
                          color: AppColors.white),
                      label: Text('Invite Admin', style: AppTextStyle.button),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandPrimary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('Admin Team Management',
                        style: AppTextStyle.heading1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const InviteAdminDialog(),
                      );
                    },
                    icon: const Icon(Icons.mail_outline_rounded,
                        color: AppColors.white),
                    label: Text('Invite Admin', style: AppTextStyle.button),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                _buildAdminTile('Super Admin', 'super@grow.app', 'Full Access'),
                const Divider(),
                _buildAdminTile('Ahmed Admin', 'ahmed@grow.app', 'Manager'),
                const Divider(),
                _buildAdminTile('Sarah Viewer', 'sarah@grow.app', 'View Only'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminTile(String name, String email, String role) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.brandPrimary.withOpacity(0.1),
        child: Text(name[0],
            style: const TextStyle(
                color: AppColors.brandPrimary, fontWeight: FontWeight.bold)),
      ),
      title: Text(name,
          style:
              AppTextStyle.bodyRegular.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(email, style: AppTextStyle.caption),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(role,
            style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
