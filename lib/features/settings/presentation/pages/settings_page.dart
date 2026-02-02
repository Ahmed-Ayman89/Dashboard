import 'package:flutter/material.dart';
import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Platform Settings', style: AppTextStyle.heading1),
          const SizedBox(height: 32),
          _buildGlobalSettings(),
          const SizedBox(height: 32),
          _buildFinancialSettings(),
          const SizedBox(height: 32),
          _buildSystemRules(),
        ],
      ),
    );
  }

  Widget _buildGlobalSettings() {
    return _buildSettingsSection(
      title: 'Global App Settings',
      icon: Icons.settings_applications_rounded,
      children: [
        _buildSettingTile('Daily Kiosk Transaction Limit', '500 TX'),
        _buildSettingTile('Same Customer Limit (Per Day)', '3 TX'),
        _buildSettingTile('Minimum Redemption Amount', '50 EGP'),
        _buildSettingTile('Max. Kiosks per Owner', '4 Kiosks'),
        _buildSettingTile('Minimum Sending Amount', '10 Points'),
        _buildSettingTile('Maximum Sending Amount', '1000 Points'),
      ],
    );
  }

  Widget _buildFinancialSettings() {
    return _buildSettingsSection(
      title: 'Financial Settings',
      icon: Icons.monetization_on_rounded,
      children: [
        _buildSettingTile('Commission Amount', '5 Points (Fixed)'),
      ],
    );
  }

  Widget _buildSystemRules() {
    return _buildSettingsSection(
      title: 'System Rules & Legal',
      icon: Icons.gavel_rounded,
      children: [
        _buildSettingTile('Terms & Conditions Link', 'https://grow.app/terms'),
        _buildSettingTile('Privacy Policy Link', 'https://grow.app/privacy'),
      ],
    );
  }

  Widget _buildSettingsSection(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
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
          Row(
            children: [
              Icon(icon, color: AppColors.brandPrimary),
              const SizedBox(width: 12),
              Text(title, style: AppTextStyle.heading3),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.bodyRegular,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Text(value,
                  style: AppTextStyle.bodyRegular.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral700)),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.edit_rounded,
                    size: 20, color: AppColors.brandPrimary),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
